From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Btrfs v0.14 Released
Date: Fri, 2 May 2008 16:31:23 +0200 (CEST)
Message-ID: <alpine.LNX.1.10.0805021627460.6463@fbirervta.pbzchgretzou.qr>
References: <200804291601.32945.chris.mason@oracle.com>  <481A23AB.1020302@suse.com>  <alpine.LNX.1.10.0805020837490.6463@fbirervta.pbzchgretzou.qr>  <200805020852.51125.chris.mason@oracle.com> <c24352ca0805020715y46741317ve9897afd689d058f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Chris Mason <chris.mason@oracle.com>,
	Jeff Mahoney <jeffm@suse.com>,
	Tim Gardner <tim.gardner@canonical.com>,
	linux-fsdevel@vger.kernel.org, kernel-team@lists.ubuntu.com,
	linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	John Johansen <jjohansen@suse.de>
To: jeffschroeder@computer.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <c24352ca0805020715y46741317ve9897afd689d058f@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>


On Friday 2008-05-02 16:15, Jeff Schroeder wrote:
>
>Make is not my forte, but here is a working test to see if apparmor
>exists in Ubuntu 8.04.
>Maybe have make apply a patch to the btrfs source if this test
>succeeds? Does this work in SUSE?
>
>http://www.digitalprognosis.com/opensource/patches/btrfs/lame_apparmor_test_for_btrfs.patch

Woah, you rely on autoconf.h. Uh no thanks, let the build system handle it.

# -*- Makefile -*-

btrfs-objs := ...
obj-m += btrfs.o and-so-on.o

ifneq (${CONFIG_SECURITY_APPARMOR},)
EXTRA_CFLAGS += -DI_HAZ_AN_APPARMOR
endif

all:
	${MAKE} -C ${kdir} M=$PWD all;


Best of all, you can override that from the command line too...

	make CONFIG_SECURITY_APPARMOR=y

(and if you don't, it takes its value from the appropriate .config,
all without you having to care about autoconf.h)
