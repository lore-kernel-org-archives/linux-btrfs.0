Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f66.google.com ([209.85.215.66]:35445 "EHLO
	mail-lf0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751029AbcEHFAM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 8 May 2016 01:00:12 -0400
Received: by mail-lf0-f66.google.com with SMTP id u64so17634475lff.2
        for <linux-btrfs@vger.kernel.org>; Sat, 07 May 2016 22:00:10 -0700 (PDT)
Subject: Re: [PATCH] btrfs-progs: udev: add rules for dm devices
To: Jeff Mahoney <jeffm@suse.com>, linux-btrfs <linux-btrfs@vger.kernel.org>
References: <6ddc2c5c-42df-e7ca-daff-8848cbc3d9e9@suse.com>
From: Andrei Borzenkov <arvidjaar@gmail.com>
Message-ID: <572EC7D7.8040608@gmail.com>
Date: Sun, 8 May 2016 08:00:07 +0300
MIME-Version: 1.0
In-Reply-To: <6ddc2c5c-42df-e7ca-daff-8848cbc3d9e9@suse.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

06.05.2016 22:27, Jeff Mahoney пишет:
> Systemd's btrfs rule runs btrfs dev ready on each device
> as it's discovered.  The btrfs command is executed as a builtin
> command via an IMPORT{builtin} rule, which means it gets
> executed at rule evaluation time, not rule execution time.  That
> means that the device mapper links haven't been setup yet and the only
> nodes that can be depended upon are /dev/dm-#.  That we see
> /dev/mapper/name names in /proc/mounts is only because we replace the
> device name we have cached with the one passed in via mount.  If
> we have a multi-device file system and the primary device is removed,
> the remaining devices will show /dev/dm-#.  In addition, if the

And I still do not understand why it is bad while /dev/sd#n is good.

> udev rule is executed again by someone generating a change event (e.g.
> partprobe), the names are also replaced by the /dev/dm-# names.
> 
> This patch adds a new rule that adds a run rule that calls btrfs dev
> ready again using the device mapper links once they're created.
> ---
>  64-btrfs-dm.rules | 10 ++++++++++
>  Makefile.in       |  7 +++++++
>  configure.ac      |  2 ++
>  3 files changed, 19 insertions(+)
>  create mode 100644 64-btrfs-dm.rules
> 
> diff --git a/64-btrfs-dm.rules b/64-btrfs-dm.rules
> new file mode 100644
> index 0000000..bbe1c35
> --- /dev/null
> +++ b/64-btrfs-dm.rules
> @@ -0,0 +1,10 @@
> +SUBSYSTEM!="block", GOTO="btrfs_end"
> +KERNEL!="dm-[0-9]*", GOTO="btrfs_end"
> +ACTION!="add|change", GOTO="btrfs_end"
> +ENV{ID_FS_TYPE}!="btrfs", GOTO="btrfs_end"
> +
> +# Once the device mapper symlink is created, tell btrfs about it
> +# so we get the friendly name in /proc/mounts (and tools that read it)
> +ENV{DM_NAME}=="?*", TEST=="/dev/mapper/$env{DM_NAME}", RUN{builtin}+="btrfs ready /dev/mapper/$env{DM_NAME}"
> +

That won't work for the very first event (presumably "add"). /dev/mapper
link is created only after all rules have been processed, so it will
always evaluate to false.

> +LABEL="btrfs_end"
> diff --git a/Makefile.in b/Makefile.in
> index 19697ff..d555f6a 100644
> --- a/Makefile.in
> +++ b/Makefile.in
> @@ -83,11 +83,15 @@ libbtrfs_headers = send-stream.h send-utils.h send.h rbtree.h btrfs-list.h \
>  	       extent_io.h ioctl.h ctree.h btrfsck.h version.h
>  TESTS = fsck-tests.sh convert-tests.sh
>  
> +udev_rules = 64-btrfs-dm.rules
> +
>  prefix ?= @prefix@
>  exec_prefix = @exec_prefix@
>  bindir = @bindir@
>  libdir ?= @libdir@
>  incdir = @includedir@/btrfs
> +udevdir = @UDEVDIR@
> +udevruledir = ${udevdir}/rules.d
>  
>  ifeq ("$(origin V)", "command line")
>    BUILD_VERBOSE = $(V)
> @@ -377,6 +381,9 @@ install: $(libs) $(progs_install) $(INSTALLDIRS)
>  	cp -a $(lib_links) $(DESTDIR)$(libdir)
>  	$(INSTALL) -m755 -d $(DESTDIR)$(incdir)
>  	$(INSTALL) -m644 $(headers) $(DESTDIR)$(incdir)
> +ifneq ($(udevdir), "")
> +	$(INSTALL) -m644 $(udev_rules) $(DESTDIR)$(udevruledir)
> +endif
>  
>  install-static: $(progs_static) $(INSTALLDIRS)
>  	for p in $(progs_static) ; do \
> diff --git a/configure.ac b/configure.ac
> index fc343ea..4af7474 100644
> --- a/configure.ac
> +++ b/configure.ac
> @@ -124,6 +124,8 @@ PKG_STATIC(UUID_LIBS_STATIC, [uuid])
>  PKG_CHECK_MODULES(ZLIB, [zlib])
>  PKG_STATIC(ZLIB_LIBS_STATIC, [zlib])
>  
> +PKG_CHECK_VAR([UDEVDIR], [udev], [udevdir])
> +
>  dnl lzo library does not provide pkg-config, let use classic way
>  AC_CHECK_LIB([lzo2], [lzo_version], [
>  	LZO2_LIBS="-llzo2"
> 

