Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from brockman.in8.de ([85.214.220.56]:49458 "EHLO mail.in8.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754759Ab3DXN7d (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 24 Apr 2013 09:59:33 -0400
Message-ID: <5177E53F.5060205@jan-o-sch.net>
Date: Wed, 24 Apr 2013 15:59:27 +0200
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
MIME-Version: 1.0
To: Josef Bacik <jbacik@fusionio.com>
CC: Chris Mason <clmason@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: separate sequence numbers for delayed ref tracking
 and tree mod log
References: <1366740027-27627-1-git-send-email-list.btrfs@jan-o-sch.net> <20130424130453.GF2631@localhost.localdomain> <5177DD35.8080802@jan-o-sch.net> <20130424134001.GH2631@localhost.localdomain>
In-Reply-To: <20130424134001.GH2631@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, April 24, 2013 at 15:40 (+0200), Josef Bacik wrote:
> On Wed, Apr 24, 2013 at 07:25:09AM -0600, Jan Schmidt wrote:
>> On Wed, April 24, 2013 at 15:04 (+0200), Josef Bacik wrote:
>>> On Tue, Apr 23, 2013 at 12:00:27PM -0600, Jan Schmidt wrote:
>>>> Sequence numbers for delayed refs have been introduced in the first version
>>>> of the qgroup patch set. To solve the problem of find_all_roots on a busy
>>>> file system, the tree mod log was introduced. The sequence numbers for that
>>>> were simply shared between those two users.
>>>>
>>>> However, at one point in qgroup's quota accounting, there's a statement
>>>> accessing the previous sequence number, that's still just doing (seq - 1)
>>>> just as it had to in the very first version.
>>>>
>>>> To satisfy that requirement, this patch makes the sequence number counter 64
>>>> bit and splits it into a major part (used for qgroup sequence number
>>>> counting) and a minor part (incremented for each tree modification in the
>>>> log). This enables us to go exactly one major step backwards, as required
>>>> for qgroups, while still incrementing the sequence counter for tree mod log
>>>> insertions to keep track of their order. Keeping them in a single variable
>>>> means there's no need to change all the code dealing with comparisons of two
>>>> sequence numbers.
>>>>
>>>> The sequence number is reset to 0 on commit (not new in this patch), which
>>>> ensures we won't overflow the two 32 bit counters.
>>>>
>>>> Without this fix, the qgroup tracking can occasionally go wrong and WARN_ONs
>>>> from the tree mod log code may happen.
>>>>
>>>> Signed-off-by: Jan Schmidt <list.btrfs@jan-o-sch.net>
>>>> ---
>>>>  fs/btrfs/ctree.c       |   36 +++++++++++++++++++++++++++++++++---
>>>>  fs/btrfs/ctree.h       |    7 ++-----
>>>>  fs/btrfs/delayed-ref.c |    6 ++++--
>>>>  fs/btrfs/disk-io.c     |    2 +-
>>>>  fs/btrfs/extent-tree.c |    5 +++--
>>>>  fs/btrfs/qgroup.c      |   13 ++++++++-----
>>>>  fs/btrfs/transaction.c |    2 +-
>>>>  7 files changed, 52 insertions(+), 19 deletions(-)
>>>>
>>>> diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
>>>> index 566d99b..b74136e 100644
>>>> --- a/fs/btrfs/ctree.c
>>>> +++ b/fs/btrfs/ctree.c
>>>> @@ -361,6 +361,36 @@ static inline void tree_mod_log_write_unlock(struct btrfs_fs_info *fs_info)
>>>>  }
>>>>  
>>>>  /*
>>>> + * increment the upper half of tree_mod_seq, set lower half zero
>>>> + *
>>>> + * must be called with fs_info->tree_mod_seq_lock held
>>>> + */
>>>> +static inline u64 btrfs_inc_tree_mod_seq_major(struct btrfs_fs_info *fs_info)
>>>> +{
>>>> +	u64 seq = atomic64_read(&fs_info->tree_mod_seq);
>>>> +	seq &= 0xffffffff00000000ull;
>>>> +	seq += 1ull << 32;
>>>> +	atomic64_set(&fs_info->tree_mod_seq, seq);
>>>> +	return seq;
>>>> +}
>>>
>>> This isn't going to work, you read in the value, inc it and then set the new
>>> value.  If somebody comes in and inc's in between the read and the sync, like
>>> btrfs_inc_tree_mod_seq_minor could do when you call tree_mod_alloc, you'll end
>>> up losing the minor update.  Thanks,
>>
>> I don't think I'll lose it. The minor update is made and returned to the one who
>> needs it, that number can still be used. There is no guarantee for two
>> concurrent modifications to which major a minor number belongs, though.
>>
> 
> Ah yeah it's returned, but then you'll end up with two things that have the same
> seq number when they shouldn't have.  I'm not sure if that's a bad thing or not,
> but from up here it looks like a bad thing, at the very least it's going to
> surprise anybody who goes to work on this code later and expects it to work out
> like a normal atomic would.  So either wrap it in a spin_lock (it looks like you
> already have a mod_seq_lock) or come up with something less crafty.  Thanks,

Okay, here comes the deal: I put the tree_mod_seq_lock around
btrfs_inc_tree_mod_seq_minor, I don't expect it really hurts anyway. But as soon
as David comes by and proves it in fact does hurt in one of his manifold use
cases, I'll start arguing again why we can remove it without replace.

Thanks,
-Jan


> Josef
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
