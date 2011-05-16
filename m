From: liubo <liubo2009@cn.fujitsu.com>
Subject: Re: crash in btrfsck, btrfs-debug-tree, etc
Date: Mon, 16 May 2011 16:08:23 +0800
Message-ID: <4DD0DB77.6040103@cn.fujitsu.com>
References: <4BD89481.1060201@acm.org> <4BDF4013.7090000@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Linux btrfs <linux-btrfs@vger.kernel.org>
To: "Vladimir G. Ivanovic" <vladimir@acm.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4BDF4013.7090000@acm.org>
List-ID: <linux-btrfs.vger.kernel.org>

On 05/04/2010 05:28 AM, Vladimir G. Ivanovic wrote:
> No help, eh? At the minimum, it would be nice if btrfsck were fixed...
> 

Not sure if the following one will help you to show the metadata, but you
can give it a try and go on using btrfs-debug-tree.

diff --git a/disk-io.c b/disk-io.c
index a6e1000..90f2831 100644
--- a/disk-io.c
+++ b/disk-io.c
@@ -204,12 +204,8 @@ struct extent_buffer *read_tree_block(struct btrfs_root *root, u64 bytenr,
 		eb->dev_bytenr = multi->stripes[0].physical;
 		kfree(multi);
 		ret = read_extent_from_disk(eb);
-		if (ret == 0 && check_tree_block(root, eb) == 0 &&
-		    csum_tree_block(root, eb, 1) == 0 &&
-		    verify_parent_transid(eb->tree, eb, parent_transid) == 0) {
-			btrfs_set_buffer_uptodate(eb);
+		if (ret == 0)
 			return eb;
-		}
 		num_copies = btrfs_num_copies(&root->fs_info->mapping_tree,
 					      eb->start, eb->len);
 		if (num_copies == 1) {


thanks,
liubo.

> Unfortunately, now btrfs will NOT mount the drive, so I am now
> completely without data. The mount error is:
> 
>     kernel: device fsid c64b56bd1c869bb3-e85f95a29c7dd3ad devid 1
> transid 21547 /dev/sdc1
>     kernel: btrfs bad tree block start 14052438117991321731 20971520
>     kernel: btrfs bad tree block start 14052438117991321731 20971520
>     kernel: btrfs bad tree block start 8532476744452893537 20971520
>     kernel: btrfs: failed to read chunk root on sdc1
>     kernel: btrfs: open_ctree failed
> 
> --- Vladimir
> 
> Vladimir G. Ivanovic                            http://www.leonora.org
> +1 650 450 4101                                       vladimir@acm.org
> 
> 
> on 04/28/2010 01:03 PM Vladimir G. Ivanovic said the following:
>> I overwrote some part of the first 195641856 bytes of a 1TB (nominal)
>> btrfs volume (I CTRL-C'd out
>> before dd finished.) OK, OK, you may stop laughing now. Surely something
>> similar has happened to
>> you. No? Then it will, someday.
>>
>> First things first: A huge congratulations to the btrfs team because the
>> btrfs volume is still
>> usable. I do get many errors similar to:
>>
>>     kernel: btrfs bad tree block start 3050544144921548175 12056985
>>
>> but for many of my files, I don't get errors.
>>
>> Now, onto my problems. My first thought was to btrfsck the unmount
>> volume, but btrfsck crashes:
>>
>>     # btrfsck /dev/sdc1
>>     btrfsck: disk-io.c:723: open_ctree_fd: Assertion
>> `!(!chunk_root->node)' failed.
>>     Aborted (core dumped)
>>
>> So does btrfs-debug-tree, and I suspect other utilities will as well. I
>> tried the latest utilities
>> from btrfs-progs-unstable, but they too crash with the same error. (I'm
>> on a Athlon64-powered
>> netbook running Fedora 12. btrfs's version is 0.19.) In particular, so
>> does btrfs-image, so I can't
>> share the volume's metadata.
>>
>> So, until the utilities are fixed, what are my options?
>>
>> * Can I create a snapshot of the root volume? Would I end up with
>> everything that could be read in
>>   the snapshot, or would it also have errors? If this is a good idea,
>> would these commands work?
>>
>>       btrfsctl -s snapshot_of_root /mnt/chopin1
>>       mount.btrfs -o subvol=snapshot_of_root /dev/sdc1 /mnt/snap
>>
>>   do the trick, assuming that btrfsctl doesn't also crash? Then what?
>> Copy the snapshot to another
>>   disk? Somehow make the new snapshot the new root, allowing me to
>> delete the old root?
>>
>> * Should I just try and copy the data to another disk and reformat my
>> current volume?
>>
>> * Is there a way of testing whether a particular file is good other than
>> (slowly) going through
>>   each and every file while watching syslog? cat, for example, doesn't
>> return an error when the
>>   file is bad, so I don't think I can write a shell script to copy good
>> files to another volume.
>>
>> Are there other options that I haven't considered?
>>
>> Thanks for all help.
>>
>> --- Vladimir
>>
>>   
> 

