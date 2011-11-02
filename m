From: "Helmut Hullen" <Hullen@t-online.de>
Subject: Re: [PATCH] Btrfs-progs: mention libattr dependency in INSTALL file
Date: 02 Nov 2011 17:39:00 +0100
Message-ID: <Bx5IMSIi1uB@helmut.hullen.de>
References: <1320246873-25457-1-git-send-email-idryomov@gmail.com>
Reply-To: helmut@hullen.de
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1320246873-25457-1-git-send-email-idryomov@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hallo, Ilya,

Du meintest am 02.11.11:

>  The Btrfs utility programs require libuuid to build.  This can be
> found  in the e2fsprogs sources, and is usually available as libuuid
> or e2fsprogs-devel from various distros.  The other dependency is
> libattr +(libattr1-dev in Debian-based distros).

Just for information: my btrfs-progs packet (integration-20111030) shows  
(via "ldd")

	libcom_err.so.2 => /lib/libcom_err.so.2 (0x401cc000)
	libcom_err.so.3 => /usr/X11R6/lib/libcom_err.so.3 (0x40061000)
	libc.so.6 => /lib/libc.so.6 (0x4003b000)
	libext2fs.so.2 => /lib/libext2fs.so.2 (0x40037000)
	libkrb5support.so.0 => /usr/lib/libkrb5support.so.0 (0x401cf000)
	/lib/ld-linux.so.2 (0x40000000)
	libpthread.so.0 => /lib/libpthread.so.0 (0x40037000)
	libresolv.so.2 => /lib/libresolv.so.2 (0x401d2000)
	libuuid.so.1 => /lib/libuuid.so.1 (0x40037000)

No "libattr". No special compiler option.

Slackware 13.37

Viele Gruesse!
Helmut
