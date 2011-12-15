From: WuBo <wu.bo@cn.fujitsu.com>
Subject: Re: [PATCH] Btrfs: don't panic if orphan item already exists
Date: Thu, 15 Dec 2011 09:56:49 +0800
Message-ID: <4EE953E1.6010102@cn.fujitsu.com>
References: <1323798951-4329-1-git-send-email-josef@redhat.com> <4EE7A172.2010105@cfl.rr.com> <20111213190942.GA3602@localhost.localdomain> <4EE804EB.5070209@cn.fujitsu.com> <4EE8707D.7080504@cn.fujitsu.com> <20111214145843.GA1925@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Miao Xie <miaox@cn.fujitsu.com>, Phillip Susi <psusi@cfl.rr.com>,
	linux-btrfs@vger.kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20111214145843.GA1925@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>



On 12/14/2011 10:58 PM, Josef Bacik wrote:
> On Wed, Dec 14, 2011 at 05:46:37PM +0800, Miao Xie wrote:
>> On 	wed, 14 Dec 2011 10:07:39 +0800, WuBo wrote:
>>> On 12/14/2011 03:09 AM, Josef Bacik wrote:
>>>> On Tue, Dec 13, 2011 at 02:03:14PM -0500, Phillip Susi wrote:
>>>>> On 12/13/2011 12:55 PM, Josef Bacik wrote:
>>>>>> I've been hitting this BUG_ON() in btrfs_orphan_add when running xfstest 269 in
>>>>>> a loop.  This is because we will add an orphan item, do the truncate, the
>>>>>> truncate will fail for whatever reason (*cough*ENOSPC*cough*) and then we're
>>>>>> left with an orphan item still in the fs.  Then we come back later to do another
>>>>>> truncate and it blows up because we already have an orphan item.  This is ok so
>>>>>> just fix the BUG_ON() to only BUG() if ret is not EEXIST.  Thanks,
>>>>>
>>>>> Wouldn't it be better to fix the underlying bug, and remove the
>>>>> orphan item when the truncate fails?
>>>>>
>>>>
>>>> No because we still need the thing to be cleaned up.  If the truncate fails we
>>>> need to leave the orphan item there so the next time the fs is mounted the inode
>>>> is cleaned up, that's not a bug.  Thanks,
>>>>
>>>> Josef
>>>
>>> Hi, Josef
>>>
>>> I'm digging this issue too, actually xfstests 083 also can trigger this BUG_ON
>>> while run loops. and I agreed with Phillip's opinion that we'd better "fix the 
>>> underlying bug". If the btrfs_truncate faild with ENOSPC, we should not even call 
>>> btrfs_orphan_del to clean the memory orphan list so that the next orphan item
>>> insert will be skipped.
>>>
> 
> There is no "underlying bug", there is a shitty situation, the shitty situation
> where we dont have enough room to free up space.  There is no getting around
> this, there is no fix for this, we are fucked and there is nothing we can do
> about it.  We have to clean it up from the in memory list because otherwise we
> will complain when we go to destroy the inode, this is to catch the case that we
> _didn't_ do the cleanup properly, so that has to stay.
Oh I made a mistake, yes the orphan inode in memory list should be deleted.
thanks for your explain.

> 
> There is nothing wrong with leaving the orphan item there.  The next time we
> mount we will truncate to the i_size, so if later on down the road we were able
> to free up space and we could write to the inode again then i_size will grow and
> everything will be a-ok.  There is little dange in leaving the orphan item
> there.  The only danger is as Miao describes below...
If we left the orphan inode, I also worried another situation:
The disk is almost full, and there are a lot of inode truncate failing, 
and then left a lot of orphan inodes in fs. In the next mount, btrfs should clean
all of these orphan inodes even should do truncate again, which also need reserve space.
but the disk is full and mount will be failed.
So I think we'd better remove the orphan inode at the end of truncate. "update the
new i_size and remove the orphan item" is a good idea.

thanks
wubo

> 
>>> But, there is still a trouble. The user will get the fail result while the orphan 
>>> inode still left in the fs. It's strange. So in the end of the btrfs_truncate,
>>> if the btrfs_update_inode is successed, I will delete the orphan inode anyway.
>>
>> Another reason for that we should fix the underlying bug:
>> File0							| i_size
>> 							v
>> 	+-----------------------------------------------+
>> 	|						|
>> 	+-----------------------------------------------+
>>
>> The user truncated File0, but failed when doing truncation:
>> File0				| i_size	| real size
>> 				v		v
>> 	+---------------------------------------+
>> 	|					|
>> 	+---------------------------------------+
>>
>> The user did pre-allocation for File0 (keep size):
>> File0				| i_size	| pre-allocated extent	|
>> 				v		v			v
>> 	+---------------------------------------+-----------------------+
>> 	|					|			|
>> 	+---------------------------------------+-----------------------+
>>
>> And then, the user umounted and mount the file system again. Because we left the orphan item
>> in the file system, btrfs will drop the pre-allocated extent when mounting it. It is not
>> the expected result for users.
>>
> 
> This is the only case where we will truncate space that we think should be
> there.  I'm ok with it, because there is no actual data here, we're just
> trimming pre-allocated space.
> 
> The only other option is to keep track of inodes that have an orphan item and if
> we try to do anything to the inode (fallocate, write etc) we try and delete the
> orphan item first.  That is a lot of call paths to have
> 
> if (!list_empty(BTRFS_I(inode)->i_orphan))
> 	delete_orphan_item()
> 
> not to mention the case that the inode has left cache and we've re-read it back
> in, so everytime we read back in an inode we'll have to search for its
> corresponding orphan item to see if we didn't clean it up at some point in the
> past, which is going to mean an extra search on every inode lookup which is
> going to suck, just to deal with the case that somebody used fallocate with
> FALLOC_FL_KEEP_SIZE.
> 
> So my patch is the lesser of two evils, either we leave the damn thing in there
> and deal with the remote chance that somebody preallocated space on the end of
> the file after failing to do a truncate, or we put a bunch of performance
> sucking checks and an extra btree search on every inode lookup to deal with this
> remote chance.  My choice is my patch.
> 
> Josef "really needs a vacation" Bacik
> 
