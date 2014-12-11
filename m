Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:52898 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S932623AbaLKAuI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 10 Dec 2014 19:50:08 -0500
Message-ID: <5488EA3D.9080905@cn.fujitsu.com>
Date: Thu, 11 Dec 2014 08:50:05 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v4 00/13] btrfs-progs:fsck: Add inode nlink mismatch and
References: <1418113652-25088-1-git-send-email-quwenruo@cn.fujitsu.com> <20141210123750.GA27601@twin.jikos.cz>
In-Reply-To: <20141210123750.GA27601@twin.jikos.cz>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


-------- Original Message --------
Subject: Re: [PATCH v4 00/13] btrfs-progs:fsck: Add inode nlink mismatch and
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Date: 2014年12月10日 20:37
> On Tue, Dec 09, 2014 at 04:27:19PM +0800, Qu Wenruo wrote:
>> The patchset introduce two new repair function and some helpers to
>> archive a huge goal:
>>    Repair btrfs whose fs tree's non-root leaf/node is corrupted when no
>>    duplication is valid.
>>
>> The two new repair functions are:
>>    repair_inode_nlinks():
>>      Repair any inode nlink related problem.
>>      From fixing the nlink number and related
>>      inode_ref/dir_index/dir_item to recovering file name and file type
>>      and salvage them into the lost+found dir.
>>      This does not only fix a case that some users reported but also
>>      cooperate with repair_inode_no_item() function to salvaged heavily
>>      damaged inode to lost+found dir.
>>
>>    repair_inode_no_item():
>>      Repair case for inode_item missing case, which is quite common when
>>      fs tree leaf/node is missing.
>>      This only does the inode item rebuild. Later recovery like move it
>>      to lost+found dir is done by repair_inode_nlinks().
>>
>> The main helper is the repair_btree() function, which will drops the
>> corrupted non-root leaf/node and rebalance the tree to keep the
>> correctness of the btree.
> Sounds a bit intrusive, but under the circumstances I don't see anything
> better to do.
Better non-destructive but less generic method may be introduced later.
My dream is to inspect each key and its item to rebuild each member, but 
it would takes a long long time
to implement.
>
>> With this patchset, even a non-root leaf/node is corrupted and no
>> duplication survived, btrfsck can still repair it to a mountable status.
>> (And normal rw should also be OK,)
>>
>> The remaining unfixable problems will be inode nbytes error with file
>> extent discounts error, which may be fixed in next patchset.
>>
>> Cc David:
>> Sorry for the huge change in the patchset and merge the old inode nlink
>> repair with new inode item rebuild patchset.
> No problem, the incremental changelogs helped a lot.
>
>> Since when developing inode item rebuild patchset, I found the old nlink
>> cooperated very bad with item rebuild and there is some duplicated codes
>> between the two patchset, no to mention the math lib introduced by nlink
>> repair patch.
>> So I decided to somewhat rebase the nlink repair patchset to provide
>> better generality.
> Great, the patchset looks good for merge, I'm adding it to 3.18. From
> now on please send only incremental changes and not the whole patchset.
> Thanks.
Thanks, this should be the last large update patchset.
Later work will focus on file extent recovery and should not interfere 
with this patch.

Thanks.
Qu
