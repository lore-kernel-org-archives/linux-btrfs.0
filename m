From: David Sterba <dave@jikos.cz>
Subject: Re: [PATCH] mkfs: Handle creation of filesystem larger than the first device
Date: Wed, 14 Mar 2012 12:49:48 +0100
Message-ID: <20120314114947.GA30920@twin.jikos.cz>
References: <1327593785-23466-1-git-send-email-jack@suse.cz> <4F32F0AB.8030003@ubuntu.com> <20120208232015.GE1696@quack.suse.cz> <4F3337F6.7010900@ubuntu.com> <20120210104919.GE10509@quack.suse.cz>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Phillip Susi <psusi@ubuntu.com>, linux-btrfs@vger.kernel.org,
	Chris Mason <chris.mason@oracle.com>,
	David Sterba <dsterba@suse.cz>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120210104919.GE10509@quack.suse.cz>
List-ID: <linux-btrfs.vger.kernel.org>

For the record, this fixup is needed

--- a/utils.c
+++ b/utils.c
@@ -273,6 +273,9 @@ int make_btrfs(int fd, const char *device, const char *label,
        btrfs_set_item_offset(buf, btrfs_item_nr(buf, nritems), itemoff);
        btrfs_set_item_size(buf, btrfs_item_nr(buf, nritems), item_size);

+       if (num_bytes < dev_num_bytes)
+               dev_num_bytes = num_bytes;
+
        dev_item = btrfs_item_ptr(buf, nritems, struct btrfs_dev_item);
        btrfs_set_device_id(buf, dev_item, 1);
        btrfs_set_device_generation(buf, dev_item, 0);
---

otherwise a filesystem smaller than the block device will not report correct
size of the device and this inconsistency will trigger a bug (xfstests/015)

cow_file_range:

 895         BUG_ON(disk_num_bytes >
 896                btrfs_super_total_bytes(root->fs_info->super_copy));



$ mkfs.btrfs-small-bd-big-fs -b 100M /dev/sda10
SMALL VOLUME: forcing mixed metadata/data groups

WARNING! - Btrfs v0.19-190-gc1d427d IS EXPERIMENTAL
WARNING! - see http://btrfs.wiki.kernel.org before using

Created a data/metadata chunk of size 8388608
fs created label (null) on /dev/sda10
        nodesize 4096 leafsize 4096 sectorsize 4096 size 100.00MB
Btrfs v0.19-190-gc1d427d

$ btrfs fi show
Label: none  uuid: efecdeb1-bab3-40aa-bafa-4aae1e410f28
        Total devices 1 FS bytes used 28.00KB
        devid    1 size 10.00GB used 12.00MB path /dev/sda10
                        ^^^^^^^

$ df -h
Filesystem            Size  Used Avail Use% Mounted on
/dev/sda10            100M   28K   10G   1% /mnt/a10
                                   ^^^

I'm writing a kernel-side patch to prevent mounting such fs, unless -o recovery
is given and this will fix the fs size in superblock to sum of all device
sizes. Fsck could be enhanced in the same way.


david
