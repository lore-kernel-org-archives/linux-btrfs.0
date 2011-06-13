From: Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [PATCH] Btrfs: use the normal checksumming infrastructure for
 free space cache
Date: Mon, 13 Jun 2011 10:05:25 +0800
Message-ID: <4DF57065.3090109@cn.fujitsu.com>
References: <1307734827-10697-1-git-send-email-josef@redhat.com> <4DF56D60.4070208@cn.fujitsu.com> <1307929964-sup-6781@shiny>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Josef Bacik <josef@redhat.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1307929964-sup-6781@shiny>
List-ID: <linux-btrfs.vger.kernel.org>

Chris Mason wrote:
> Excerpts from Li Zefan's message of 2011-06-12 21:52:32 -0400:
>> Josef Bacik wrote:
>>> We used to store the checksums of the space cache directly in the space cache,
>>> however that doesn't work out too well if we have more space than we can fit the
>>> checksums into the first page.  So instead use the normal checksumming
>>> infrastructure.  There were problems with doing this originally but those
>>> problems don't exist now so this works out fine.  Thanks,
>>>
>>
>> This looks great, so I'll drop my patch that extends the original code to
>> allow more than 1 crc page.
> 
> I do like them a lot, but what happens when a special case crc kernel
> mounts a free space cache created by this patch?
> 

So we need a check, like the one in load_free_space_cache():

@@ -2650,6 +2650,11 @@ int load_free_ino_cache(struct btrfs_fs_info *fs_info, st
        if (IS_ERR(inode))
                goto out;
 
+ 	if (BTRFS_I(inode)->flags & BTRFS_INODE_NODATASUM) {
+ 		printk(KERN_INFO "Old style space inode found, converting.\n");
+ 		BTRFS_I(inode)->flags &= ~BTRFS_INODE_NODATASUM;
+ 	}
+
        if (root_gen != BTRFS_I(inode)->generation)
                goto out_put;

then we'll not trying to load the cache from disk but reconstruct the
cache by searching the fs tree.
