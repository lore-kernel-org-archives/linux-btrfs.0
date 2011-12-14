From: WuBo <wu.bo@cn.fujitsu.com>
Subject: Re: [PATCH] Btrfs: don't panic if orphan item already exists
Date: Wed, 14 Dec 2011 10:07:39 +0800
Message-ID: <4EE804EB.5070209@cn.fujitsu.com>
References: <1323798951-4329-1-git-send-email-josef@redhat.com> <4EE7A172.2010105@cfl.rr.com> <20111213190942.GA3602@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Phillip Susi <psusi@cfl.rr.com>, linux-btrfs@vger.kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20111213190942.GA3602@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>

On 12/14/2011 03:09 AM, Josef Bacik wrote:
> On Tue, Dec 13, 2011 at 02:03:14PM -0500, Phillip Susi wrote:
>> On 12/13/2011 12:55 PM, Josef Bacik wrote:
>>> I've been hitting this BUG_ON() in btrfs_orphan_add when running xfstest 269 in
>>> a loop.  This is because we will add an orphan item, do the truncate, the
>>> truncate will fail for whatever reason (*cough*ENOSPC*cough*) and then we're
>>> left with an orphan item still in the fs.  Then we come back later to do another
>>> truncate and it blows up because we already have an orphan item.  This is ok so
>>> just fix the BUG_ON() to only BUG() if ret is not EEXIST.  Thanks,
>>
>> Wouldn't it be better to fix the underlying bug, and remove the
>> orphan item when the truncate fails?
>>
> 
> No because we still need the thing to be cleaned up.  If the truncate fails we
> need to leave the orphan item there so the next time the fs is mounted the inode
> is cleaned up, that's not a bug.  Thanks,
> 
> Josef

Hi, Josef

I'm digging this issue too, actually xfstests 083 also can trigger this BUG_ON
while run loops. and I agreed with Phillip's opinion that we'd better "fix the 
underlying bug". If the btrfs_truncate faild with ENOSPC, we should not even call 
btrfs_orphan_del to clean the memory orphan list so that the next orphan item
insert will be skipped.

But, there is still a trouble. The user will get the fail result while the orphan 
inode still left in the fs. It's strange. So in the end of the btrfs_truncate,
if the btrfs_update_inode is successed, I will delete the orphan inode anyway.

what do you think of this idea? I'll make a patch if you do not have any comment.

BTW, 083 will always make the btrfs_truncate fail with btrfs_truncate_inode_items
for ENOSPC when the disk is almost full.

thanks
wubo

> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
