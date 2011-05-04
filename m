From: Josef Bacik <josef@redhat.com>
Subject: Re: kernel BUG at fs/btrfs/inode.c:149!
Date: Wed, 04 May 2011 14:21:54 -0400
Message-ID: <4DC19942.5010505@redhat.com>
References: <201105041626.36039.whirm@gmx.com> <4DC166D4.4000801@redhat.com> <201105041943.31809.whirm@gmx.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------050006070401000902050604"
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: whirm@gmx.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201105041943.31809.whirm@gmx.com>
List-ID: <linux-btrfs.vger.kernel.org>

This is a multi-part message in MIME format.
--------------050006070401000902050604
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 05/04/2011 01:43 PM, whirm@gmx.com wrote:
> On Wednesday 04 May 2011 16:46:44 Josef Bacik wrote:
>> On 05/04/2011 10:26 AM, whirm@gmx.com wrote:
>>> Hi all,
>>>
>>> Here's a traceback from a failed attempt to mount a btrfs in lvm in luks
>>> filesystem.
>>>
>>> Note that if I mount it readonly it mounts successfully (haven't tried to
>>> recover any data as I have recent backups).
>>>
>>> Yesterday I defragmented both / and /home with:
>>>
>>> find /home -xdev -type f -print0 | xargs -0 sudo ./btrfs filesystem
>>> defragment -c
>>>
>>> with btrfs-tools v0.19-35-g1b444cd and rebooted a couple of times. And
>>> today I got this traceback while trying to mount home at boot time (/ is
>>> working ok)
>>>
>>> btrfsck fails with the following error:
>>>
>>> couldn't open because of unsupported option features (8).
>>> btrfsck: disk-io.c:682: open_ctree_fd: Assertion `!(1)' failed.
>>>
>>> I'm using a 2.6.39-rc5+ kernel from Linus' tree.
>>>
>>> If someone needs any extra info, just ask for it, Ill keep the corrupted
>>> filesystem for a few days before destroying it.
>>>
>>> Thanks.
>>
>> I just posted a patch for this, please try
>>
>> [PATCH] Btrfs: fix how we do space reservation for truncate
>>
>> thanks,
>>
>> Josef
>
> Still getting the same traceback when trying to mount the filesystem (see file
> attached).

Argh sorry I was looking at the wrong part of that warning.  Can you run 
with this debug patch and send me the log?  Thanks,

Josef

--------------050006070401000902050604
Content-Type: text/plain;
 name="debug-free-space-cache.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="debug-free-space-cache.patch"

diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index 1bcbe76..236a938 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -417,6 +417,8 @@ int load_free_space_cache(struct btrfs_fs_info *fs_info,
 			}
 
 			if (entry->type == BTRFS_FREE_SPACE_EXTENT) {
+				printk(KERN_ERR "adding extent [%llu-%llu]\n",
+				       e->offset, e->bytes);
 				spin_lock(&block_group->tree_lock);
 				ret = link_free_space(block_group, e);
 				spin_unlock(&block_group->tree_lock);
@@ -431,6 +433,8 @@ int load_free_space_cache(struct btrfs_fs_info *fs_info,
 					page_cache_release(page);
 					goto free_cache;
 				}
+				printk(KERN_ERR "adding bitmap [%llu-%llu]\n",
+				       e->offset, e->bytes);
 				spin_lock(&block_group->tree_lock);
 				ret = link_free_space(block_group, e);
 				block_group->total_bitmaps++;

--------------050006070401000902050604--
