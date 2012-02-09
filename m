From: Liu Bo <liubo2009@cn.fujitsu.com>
Subject: Re: Bulk discard doesn't work after add/delete of devices
Date: Thu, 09 Feb 2012 16:42:00 +0800
Message-ID: <4F3386D8.6010108@cn.fujitsu.com>
References: <20270.59513.240729.662692@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Lutz Euler <lutz.euler@freenet.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20270.59513.240729.662692@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>

On 02/06/2012 04:37 AM, Lutz Euler wrote:
> ... maybe even the block group cache is nonfunctional then?
> 
> I am using a btrfs file system, mirrored data and metadata on two SSDs,
> and recently tried for the first time to run fstrim on it. fstrim
> unexpectedly said "0 bytes were trimmed". strace -T shows that it spends
> only a few microseconds in the ioctl system call (basically the overhead
> of strace, it seems), so I engaged in some "printk" debugging and found
> that after "btrfs_trim_fs" executes its first statement,
> 
>   cache = btrfs_lookup_block_group(fs_info, range->start);
> 
> cache is 0. As the file system was created with a very recent kernel and
> always mounted with the default "space_cache" option I guessed that this
> might have something to do with the fact that I exchanged both the
> filesystem's devices earlier (as you can see from the devid's in the
> following output -- this is the only btrfs file system on the machine):
> 
> # btrfs fi show /dev/sda3
> Label: none  uuid: 88af7576-3027-4a3b-a5ae-34bfd167982f
> 	Total devices 2 FS bytes used 28.13GB
> 	devid    4 size 74.53GB used 38.06GB path /dev/sdb1
> 	devid    3 size 75.24GB used 38.06GB path /dev/sda3
> 
> ("exchanged" means: I created the filesystem as a mirror of sdb1 and
> sdb2, put data on it, then added sda3, balanced, deleted sdb2, balanced
> again, then unmounted, repartitioned sdb1 and sdb2 together as a larger
> sdb1, mounted degraded, added sdb1, balanced and deleted "missing".)
> 
> So I tried to reproduce this and got the following:
> 
> # dd if=/dev/zero of=img0 bs=1 count=0 seek=5G
> # dd if=/dev/zero of=img1 bs=1 count=0 seek=5G
> # losetup -f img0
> # losetup -f img1
> # mkfs.btrfs -d raid1 -m raid1 /dev/loop0 /dev/loop1
> # mount /dev/loop0 /mnt
> # fstrim -v /mnt
> /mnt: 4332265472 bytes were trimmed
> 
> (The above mentioned kernel instrumentation shows that "cache" was
> not 0 here.)
> 
> # dd if=/dev/zero of=img2 bs=1 count=0 seek=5G
> # losetup -f img2
> # btrfs device add /dev/loop2 /mnt
> # btrfs device delete /dev/loop0 /mnt
> # fstrim -v /mnt
> /mnt: 0 bytes were trimmed
> 
> ("cache" was 0 here.)
> 
> Software versions: See my earlier mail about degraded mirrors;
> reproducing the issue was on v3.3-rc2-172-g23783f8. I built fstrim
> from git, that is, util-linux pulled yesterday from git.kernel.org.
> 
> What's going on here?
> If the space cache is indeed broken on this filesystem, can I repair
> it without risk to my data?
> By mounting with "nospace_cache" once or somehow using "clear_cache"?
> 

Hi Lutz,

Would you please test the following patch on your box?

thanks,
liubo

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 77ea23c..b6e2c92 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -7653,9 +7653,16 @@ int btrfs_trim_fs(struct btrfs_root *root, struct fstrim_range *range)
 	u64 start;
 	u64 end;
 	u64 trimmed = 0;
+	u64 total_bytes = btrfs_super_total_bytes(fs_info->super_copy);
 	int ret = 0;
 
-	cache = btrfs_lookup_block_group(fs_info, range->start);
+	/*
+	 * try to trim all FS space, our block group may start from non-zero.
+	 */
+	if (range->len == total_bytes)
+		cache = btrfs_lookup_first_block_group(fs_info, range->start);
+	else
+		cache = btrfs_lookup_block_group(fs_info, range->start);
 
 	while (cache) {
 		if (cache->key.objectid >= (range->start + range->len)) {
-- 
1.6.5.2


> Greetings,
> 
> Lutz
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

