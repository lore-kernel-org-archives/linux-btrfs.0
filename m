From: "Yan, Zheng " <yanzheng@21cn.com>
Subject: Re: Permissions issues on gentoo with sandbox and not only after
	conversion from ext4
Date: Wed, 16 Sep 2009 10:33:08 +0800
Message-ID: <3d0408630909151933p51fcc459u877dd4f456e288a0@mail.gmail.com>
References: <5f8586d40909151056w5a1ee847wd92de4c00d07e111@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Alex Dedul <rotmer@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <5f8586d40909151056w5a1ee847wd92de4c00d07e111@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

2009/9/16 Alex Dedul <rotmer@gmail.com>:
> Hi there!
>
> I recently converted from ext4 with btrfs-convert and right after i
> rebooted or so i started to get permissions issues when emerging many
> packages, but this happens not with all of them. So it writes
> something like this:
>
> strip: x86_64-pc-linux-gnu-strip --strip-unneeded -R .comment
> =A0 usr/lib64/python2.6/site-packages/gajim/trayicon.so
> ecompressdir: bzip2 -9 /usr/share/man
> QA Security Notice:
> - /usr/share/gajim/src/common/xmpp/auth_nb.pyc will be a world writab=
le file.
> - This may or may not be a security problem, most of the time it is o=
ne.
> - Please double check that gajim-9999-r2 really needs a world
> writeable bit and file bugs accordingly.
> QA Security Notice:
> - /usr/share/gajim/src/common/xmpp/bosh.pyc will be a world writable =
file.
> - This may or may not be a security problem, most of the time it is o=
ne.
> - Please double check that gajim-9999-r2 really needs a world
> writeable bit and file bugs accordingly.
> [...]
>
> Emerge uses sandbox which wraps chmod and seems like lots of other
> syscalls so i guess maybe this somehow related how sandbox
> inter-operates with btrfs or vice versa.. And this seems like happens
> only with files that were created during compilation phase or the
> like, not those that was just unpacked from distribution archive. So
> looks like umask issue maybe..

yes, It's umask issue. someone had reported it

>
> Also when i run btrfsck it gives me lots of weird stuff, log file is
> 22Mb for ~8Gb filesystem.. In a "compressed" way log looks like this:
>
> ---
> found 5608325374 bytes used err is 1
> total csum bytes: 4917240
> total tree bytes: 587296768
> btree space waste bytes: 165011603
> file data blocks allocated: 5036728320
> =A0referenced 5035507712
> Btrfs Btrfs v0.18

please use btrfs-progs v0.19

Yan, Zheng
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
