Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45555 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751144Ab2JJLtc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 10 Oct 2012 07:49:32 -0400
Date: Wed, 10 Oct 2012 12:49:27 +0100
From: "Richard W.M. Jones" <rjones@redhat.com>
To: Chris Mason <clmason@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Anyone seeing lots of "Check tree block failed" and other errors
 with latest kernel?
Message-ID: <20121010114927.GA25357@rhmail.home.annexia.org>
References: <20121008141642.GC24071@rhmail.home.annexia.org>
 <20121008142757.GB4132@shiny>
 <20121008145730.GD24071@rhmail.home.annexia.org>
 <20121008150419.GE4132@shiny>
 <20121008151513.GE24071@rhmail.home.annexia.org>
 <20121008212230.GA13692@rhmail.home.annexia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20121008212230.GA13692@rhmail.home.annexia.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Oct 08, 2012 at 10:22:30PM +0100, Richard W.M. Jones wrote:
> Adding sync() + fsync of each /dev/sd* device after the mkfs command
> does appear to fix the problem.
> 
> However it's a little bit difficult to know for sure because I might
> just be changing the timing of things by adding these calls.

An update:

Although doing the sync + fsync certainly makes the bug much much
rarer, it does not entirely eliminate it.  I have now seen one case
where this still happened (log below).

If there's anything else you'd like me to test, including kernel
patches, just let me know.

Rich.

Extract from the full log at:
http://kojipkgs.fedoraproject.org//work/tasks/7186/4577186/build.log

modprobe btrfs
[   15.823412] Btrfs loaded
grep ^[[:space:]]*btrfs$ /proc/filesystems
mkfs.btrfs /dev/sda1 /dev/sdb1
[   16.740868] device fsid 25aaca9b-0192-4cfd-a9eb-37fd222c2c8f devid 1 transid 1 /dev/sda1
[   16.743227] device fsid 25aaca9b-0192-4cfd-a9eb-37fd222c2c8f devid 1 transid 1 /dev/sda1
[   17.446334] device fsid 25aaca9b-0192-4cfd-a9eb-37fd222c2c8f devid 2 transid 3 /dev/sdb1
fsync /dev/sda
fsync /dev/sdb
fsync /dev/sdc
fsync /dev/sdd
libguestfs: recv_from_daemon: 40 bytes: 20 00 f5 f5 | 00 00 00 04 | 00 00 01 3d | 00 00 00 01 | 00 12 34 04 | ...
libguestfs: trace: mkfs_btrfs = 0
libguestfs: trace: mount "/dev/sda1" "/"
libguestfs: send_to_daemon: 68 bytes: 00 00 00 40 | 20 00 f5 f5 | 00 00 00 04 | 00 00 00 01 | 00 00 00 00 | ...
guestfsd: main_loop: proc 317 (mkfs_btrfs) took 2.39 seconds
guestfsd: main_loop: new request, len 0x40
mount -o  /dev/sda1 /sysroot/
[   17.838747] device fsid 25aaca9b-0192-4cfd-a9eb-37fd222c2c8f devid 2 transid 4 /dev/sdb1
[   17.917277] device fsid 25aaca9b-0192-4cfd-a9eb-37fd222c2c8f devid 1 transid 4 /dev/sda1
[   18.084520] device fsid 25aaca9b-0192-4cfd-a9eb-37fd222c2c8f devid 1 transid 4 /dev/sda1
[   18.132447] device fsid 25aaca9b-0192-4cfd-a9eb-37fd222c2c8f devid 1 transid 4 /dev/sda1
[   18.176566] btrfs: disk space caching is enabled
[   18.200901] btrfs bad tree block start 0 135168
[   18.213456] btrfs: open_ctree failed
mount: wrong fs type, bad option, bad superblock on /dev/sda1,
       missing codepage or helper program, or other error
       In some cases useful info is found in syslog - try
       dmesg | tail or so
guestfsd: error: /dev/sda1 on / (options: ''): mount: wrong fs type, bad option, bad superblock on /dev/sda1,
       missing codepage or helper program, or other error
       In some cases useful info is found in syslog - try
       dmesg | tail or so
libguestfs: recv_from_daemon: 284 bytes: 20 00 f5 f5 | 00 00 00 04 | 00 00 00 01 | 00 00 00 01 | 00 12 34 05 | ...
libguestfs: trace: mount = -1 (error)

-- 
Richard Jones, Virtualization Group, Red Hat http://people.redhat.com/~rjones
virt-df lists disk usage of guests without needing to install any
software inside the virtual machine.  Supports Linux and Windows.
http://et.redhat.com/~rjones/virt-df/
