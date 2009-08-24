From: Sage Weil <sage@newdream.net>
Subject: Re: [PATCH]Re: The first character disappears
Date: Mon, 24 Aug 2009 10:11:09 -0700 (PDT)
Message-ID: <Pine.LNX.4.64.0908240956500.2289@cobra.newdream.net>
References: <bcf98daa0908232200r854444dwde3cfcf6b2181c6b@mail.gmail.com>
 <bcf98daa0908232217m85e5479je26f9d37df39f6f7@mail.gmail.com>
 <20090824115232.GC15449@think> <4A928CEF.2060903@dpf.gov.br>
 <bcf98daa0908240652p22b786a9m9c9b3d563b0903f6@mail.gmail.com>
 <bcf98daa0908240722y6a6e767ahfab958d8e973370c@mail.gmail.com>
 <bcf98daa0908240942l1f2ad95v609321409434801c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Atila <atila.alr@dpf.gov.br>, linux-btrfs@vger.kernel.org,
	Chris Mason <chris.mason@oracle.com>
To: Markus Suvanto <markus.suvanto@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <bcf98daa0908240942l1f2ad95v609321409434801c@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 24 Aug 2009, Markus Suvanto wrote:
> Now I notice that I can reproduce this index file corrupt only if
> compress is enabled.

The file clone ioctl doesn't fully support cloning compressed inline 
extents.  IIRC the problem is that the clone ioctl can operate on an 
arbitrary (block-aligned) file range, which may require splitting a 
compressed inline extent.  That means decompressing into a temporary 
buffer and then recompressing, and I didn't get around to doing that.

But as long as the full compressed inline extent is getting cloned it is 
supposed to get copied.  I think the problem is that the check for the 
uncompressed extent size is using ram_bytes, which is only an upper bound, 
so it's incorrectly deciding the whole extent isn't wanted and bailing 
out.

Can you tell me if the change below fixes the problem?

Thanks-
sage


diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 7cdddd1..e8e4ebe 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1100,7 +1100,8 @@ static long btrfs_ioctl_clone(struct file *file, unsigned long srcfd,
                                        new_key.offset += skip;
                                }
 
-                               if (key.offset + datal > off+len)
+                               if (key.offset + datal > off+len &&
+                                   key.offset + datal < src->i_size)
                                        trim = key.offset + datal - (off+len);
 
                                if (comp && (skip || trim)) {





> 
> lvm lvcreate -L 5G -n btrfs_test /dev/vg_md1
> mkbtrfs /dev/mapper/vg_md1-btrfs_test
> mount -t btrfs -o subvol=.,compress  /dev/mapper/vg_md1-btrfs_test /tmp/btrfs/
> btrfsctl -S test /tmp/btrfs/
> cd /tmp/btrfs/test/
> git clone /usr/src/linux-2.6/
> /tmp/btrfs-progs-unstable/bcp linux-2.6/ linux-2.6_copy
> cd linux-2.6_copy/
> git status
> 
> error: bad index file sha1 signature
> fatal: index file corrupt
> 
> 
> But without compress:
> 
> mkbtrfs /dev/mapper/vg_md1-btrfs_test
> mount -t btrfs -o subvol=.  /dev/mapper/vg_md1-btrfs_test /tmp/btrfs/
> btrfsctl -S test /tmp/btrfs/
> cd /tmp/btrfs/test/
> git clone /usr/src/linux-2.6/
> /tmp/btrfs-progs-unstable/bcp linux-2.6/ linux-2.6_copy
> cd linux-2.6_copy/
> git status
> 
> # On branch master
> nothing to commit (working directory clean)
> 
> 
> 2009/8/24 Markus Suvanto <markus.suvanto@gmail.com>:
> > Ok, the first problem is fixed but after bcp
> > git status
> > error: bad index file sha1 signature
> > fatal: index file corrupt
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
