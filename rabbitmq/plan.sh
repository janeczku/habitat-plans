pkg_name=rabbitmq
pkg_origin=rancher
pkg_version=3.6.2
pkg_license=('MPL-1.1')
pkg_maintainer="Jan Bruder <jan@rancher.com>"
pkg_dirname=rabbitmq_server-${pkg_version}
pkg_source=https://www.rabbitmq.com/releases/rabbitmq-server/v${pkg_version}/rabbitmq-server-generic-unix-${pkg_version}.tar.xz
pkg_filename=${pkg_name}-${pkg_version}.tar.xz
pkg_shasum=2de3b0c93ed6ae009648c855253602402246a0ae06e6aefa60637673fa8aa112
pkg_deps=(core/coreutils core/erlang/18.3)
pkg_expose=(4369 25672 5672 15672) # 4369 (epmd), 25672 (clustering), 5672 (AMQP), 15672 (HTTP API)

do_build() {
  # Since our pgk_dirname matches the folder in the RabbitMQ source archive we do not
  # have to do anything here
  return 0
}

do_install() {
  # The RabbitMQ source files were extracted to the HAB_CACHE_SRC_PATH in do_build(),
  # so now they need to be copied into the root directory of our package.
  build_line "Copying files from $PWD"
  cp -r * ${pkg_prefix}

  # Create the rabbitmq-env.conf and set the config file location to the rabbitmq.conf
  # template in our config directory. We also make the rabbitmq-server log to stdout.
  # rabbitmq-server automatically appends the '.conf' to the path, so we need to
  # omit the suffix here.
  build_line "Setting RabbitMQ environment options"
  cat > ${pkg_prefix}/etc/rabbitmq/rabbitmq-env.conf << EOF
CONFIG_FILE=$pkg_svc_config_path/rabbitmq
LOGS=-
SASL_LOGS=-
EOF
  chmod 644 ${pkg_prefix}/etc/rabbitmq/rabbitmq-env.conf
}
