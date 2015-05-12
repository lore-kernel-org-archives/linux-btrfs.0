Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:54985 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750829AbbELAq1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 May 2015 20:46:27 -0400
Message-ID: <55514D5F.70107@cn.fujitsu.com>
Date: Tue, 12 May 2015 08:46:23 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: Omar Sandoval <osandov@osandov.com>, David Sterba <dsterba@suse.cz>,
        <linux-btrfs@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 0/6] Btrfs: show subvolume name and ID in /proc/mounts
References: <cover.1428614837.git.osandov@osandov.com> <20150511094258.GA18249@mew>
In-Reply-To: <20150511094258.GA18249@mew>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



-------- Original Message  --------
Subject: Re: [PATCH v2 0/6] Btrfs: show subvolume name and ID in 
/proc/mounts
From: Omar Sandoval <osandov@osandov.com>
To: David Sterba <dsterba@suse.cz>, Qu Wenruo <quwenruo@cn.fujitsu.com>, 
<linux-btrfs@vger.kernel.org>
Date: 2015年05月11日 17:42

> On Thu, Apr 09, 2015 at 02:34:50PM -0700, Omar Sandoval wrote:
>> Here's version 2 of providing the subvolume name and ID in /proc/mounts.
>>
>> It turns out that getting the name of a subvolume reliably is a bit
>> trickier than it would seem because of how mounting subvolumes by ID is
>> implemented. In particular, in that case, the dentry we get for the root
>> of the mount is not necessarily attached to the dentry tree, which means
>> that the obvious solution of just dumping the dentry does not work. The
>> solution I put together makes the tradeoff of churning a bit more code
>> in order to avoid implementing this with weird hacks.
>>
>> Changes from v1 (https://lkml.org/lkml/2015/4/8/16):
>>
>> - Put subvol= last in show_options
>> - Change commit log to remove comment about userspace having no way to
>>    know which subvolume is mounted, as David pointed out you can use
>>    btrfs inspect-internal rootid <mountpoint>
>> - Split up patch 2
>> - Minor coding style fixes
>>
>> This still applies to v4.0-rc7. Tested manually and with the script
>> below (updated from v1).
>>
>> Thanks!
>>
>> Omar Sandoval (6):
>>    Btrfs: lock superblock before remounting for rw subvol
>>    Btrfs: remove all subvol options before mounting top-level
>>    Btrfs: clean up error handling in mount_subvol()
>>    Btrfs: fail on mismatched subvol and subvolid mount options
>>    Btrfs: unify subvol= and subvolid= mounting
>>    Btrfs: show subvol= and subvolid= in /proc/mounts
>>
>>   fs/btrfs/super.c | 376 ++++++++++++++++++++++++++++++++++++-------------------
>>   fs/seq_file.c    |   1 +
>>   2 files changed, 251 insertions(+), 126 deletions(-)
>>
>
> Hi, everyone,
>
> Just wanted to revive this so we can hopefully come up with a solution
> we agree on in time for 4.2.
>
> Just to recap, my approach (and also Qu Wenruo's original approach) is
> to convert subvolid= mounts to subvol= mounts at mount time, which makes
> showing the subvolume in /proc/mounts easy. The benefit of this approach
> is that looking at mount information, which is supposed to be a
> lightweight operation, is simple and always works. Additionally, we'll
> have the info in a convenient format in /proc/mounts in addition to
> /proc/$PID/mountinfo. The only caveat is that a mount by subvolid can
> fail if the mount races with a rename of the subvolume.
>
> Qu Wenruo's second approach was to instead convert the subvolid to a
> subvolume path when reading /proc/$PID/mountinfo. The benefit of this
> approach is that mounts by subvolid will always succeed in the face of
> concurrent renames. However, instead, getting the subvolume path in
> mountinfo can now fail, and it makes what should probably be a
> lightweight operation somewhat complex.
>
> In terms of the code, I think the original approach is cleaner: the
> heavy lifting is done when mounting instead of when reading a proc file.
> Additionally, I don't think that the concurrent rename race will be much
> of a problem in practice. I can't imagine that too many people are
> actively renaming subvolumes at the same time as they are mounting them,
> and even if they are, I don't think it's so surprising that it would
> fail. On the other hand, reading mount info while renaming subvolumes
> might be marginally more common, and personally, if that failed, I'd be
> unpleasantly surprised.
>
> Orthogonal to that decision is the precedence of subvolid= and subvol=.
> Although it's true that mount options usually have last-one-wins
> behavior, I think David's argument regarding the principle of least
> surprise is solid. Namely, someone's going to be unhappy with a
> seemingly arbitrary decision when they don't match.
>
> Sorry for the long-winded email! Thoughts, David, Qu?
>
> Thanks,
>
I'm OK with your patchset, just as you mentioned, concurrently mount 
with rename is not such a common thing.
And I'm also happy with the cleaner unified mount codes.

Thanks,
Qu
