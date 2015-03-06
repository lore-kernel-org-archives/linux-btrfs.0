Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f52.google.com ([209.85.220.52]:34630 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933309AbbCFKBP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 6 Mar 2015 05:01:15 -0500
Received: by paceu11 with SMTP id eu11so36425046pac.1
        for <linux-btrfs@vger.kernel.org>; Fri, 06 Mar 2015 02:01:15 -0800 (PST)
Date: Fri, 6 Mar 2015 02:01:13 -0800
From: Omar Sandoval <osandov@osandov.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, Chris Mason <clm@fb.com>,
        David Sterba <dsterba@suse.cz>
Cc: bo.li.liu@oracle.com, Eryu Guan <guaneryu@gmail.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: btrfs oops while mounting fuzzed btrfs image
Message-ID: <20150306100113.GA26485@mew>
References: <20150305070933.GB17015@dhcp-13-216.nay.redhat.com>
 <20150305094611.GA4147@localhost.localdomain>
 <20150305101354.GC17015@dhcp-13-216.nay.redhat.com>
 <20150305102701.GE4147@localhost.localdomain>
 <54F90937.70309@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <54F90937.70309@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Mar 06, 2015 at 09:56:07AM +0800, Qu Wenruo wrote:
> 
> 
> -------- Original Message  --------
> Subject: Re: btrfs oops while mounting fuzzed btrfs image
> From: Liu Bo <bo.li.liu@oracle.com>
> To: Eryu Guan <guaneryu@gmail.com>
> Date: 2015年03月05日 18:27
> 
> >On Thu, Mar 05, 2015 at 06:13:54PM +0800, Eryu Guan wrote:
> >>On Thu, Mar 05, 2015 at 05:46:12PM +0800, Liu Bo wrote:
> >>>On Thu, Mar 05, 2015 at 03:09:33PM +0800, Eryu Guan wrote:
> >>>>Hi,
> >>>>
> >>>>I was testing btrfs with fsfuzzer and encountered a divide error on
> >>>>mount, kernel version 3.19 and 4.0-rc1.
> >>>>
> >>>>I found a similar bug on kernel bugzilla
> >>>>
> >>>>https://bugzilla.kernel.org/show_bug.cgi?id=88611
> >>>>
> >>>>Please find the fuzzed btrfs image in the buzilla, and the following
> >>>>command will reproduce:
> >>>>
> >>>>mount -o loop btrfs.img /mnt/btrfs
> >>>
> >>>A divide by 0 oops.
> >>>
> >>>My printk shows that a raid56 chunk has a negative map->length, so we need to find out
> >>>how fsfuzzer made that.  Can you share your script so that we can
> >>>reproduce the oops?
> >>
> >>You can download fsfuzzer from here:
> >>
> >>http://people.redhat.com/sgrubb/files/fsfuzzer-0.7.tar.gz
> >>
> >>What it does is simply writing random garbage to the first 10% of the
> >>fs image. You can take a look at fsfuzz and mangle.c
> >
> >Will take a look, but I guess writing the first 10% of fs image may mess up fs's super block,
> >if it does then we can do nothing about it except throwing a WARNING_ONCE().
> >
> >Thanks,
> >
> >-liubo
> I'm using the same tool to do enhance btrfsck, and the tool will skip the
> first 1M bytes by default, so superblock is not affected.
> 
> Thanks,
> Qu

Hi, Qu,

I'm not seeing that in the code I'm looking at :( In fsfuzz:447, I see
the mangle executable called with an offset starting at 0, which would
mean that the superblock isn't safe. (Btw, that line also indicates that
we potentially write to the entire file system image, not just the
beginning. My understanding from mangle.c is that up to 10% of the file
contents are modified, not the first 10% of the file by length. Someone
please correct me if I'm wrong!).

Indeed, Eryu's dmesg shows:

[  309.384037] BTRFS: super block crcs don't match, older mkfs detected

This commit is relevant:

----
commit 667e7d94a1683661cff5fe9a0fa0d7f8fdd2c007
Author: Chris Mason <chris.mason@fusionio.com>
Date:   Tue May 7 11:00:13 2013 -0400

    Btrfs: allow superblock mismatch from older mkfs
    
    We've added new checks to make sure the super block crc is correct
    during mount.  A fresh filesystem from an older mkfs won't have the
    crc set.  This adds a warning when it finds a newly created filesystem
    but doesn't fail the mount.
    
    Signed-off-by: Chris Mason <chris.mason@fusionio.com>

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index bc423f7e..4e9ebe1 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -383,6 +383,11 @@ static int btrfs_check_super_csum(char *raw_disk_sb)
 
 		if (memcmp(raw_disk_sb, result, csum_size))
 			ret = 1;
+
+		if (ret && btrfs_super_generation(disk_sb) < 10) {
+			printk(KERN_WARNING "btrfs: super block crcs don't match, older mkfs detected\n");
+			ret = 0;
+		}
 	}
 
 	if (csum_type >= ARRAY_SIZE(btrfs_csum_sizes)) {
----

So, it looks like the super block is corrupted, but we ignore it because
this is a fresh filesystem. I can easily trigger a related panic with
this:

----
while true; do
	dd if=/dev/urandom of=btrfs.img bs=1M count=16
	mkfs.btrfs btrfs.img
	dd if=/dev/urandom of=btrfs.img bs=1 seek=$((64 * 1024 + 88)) count=8 conv=notrunc
	mount -o loop btrfs.img /mnt && umount /mnt
done
----

I'm not sure that this is exactly what's happening with Eryu's image,
but it's definitely an issue. I also don't know whether it's safe to get
rid of that special case. It looks like it's needed for btrfs-progs
before v3.12 (November 2013). Chris? David?

Thanks!
-- 
Omar
