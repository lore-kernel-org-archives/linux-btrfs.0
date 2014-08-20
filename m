Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:24233 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751728AbaHTBQ0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 19 Aug 2014 21:16:26 -0400
Message-ID: <53F3F6E4.6070406@cn.fujitsu.com>
Date: Wed, 20 Aug 2014 09:16:20 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>,
        Josef Bacik <jbacik@fb.com>, Chris Mason <clm@fb.com>
Subject: Re: [PATCH] btrfs: Don't continue mounting when superblock csum mismatches
 even generation is less than 10.
References: <1403599753-4072-1-git-send-email-quwenruo@cn.fujitsu.com> <53E2E9A3.6060206@cn.fujitsu.com> <20140819171842.GC1553@twin.jikos.cz>
In-Reply-To: <20140819171842.GC1553@twin.jikos.cz>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


-------- Original Message --------
Subject: Re: [PATCH] btrfs: Don't continue mounting when superblock csum 
mismatches even generation is less than 10.
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Date: 2014年08月20日 01:18
> On Thu, Aug 07, 2014 at 10:51:15AM +0800, Qu Wenruo wrote:
>> It seems that the patch is rejected in patchwork,
> It was not me :)
>
>> Could any one tell me the reason?
> I'd understand that the patch is no longer needed after the original
> problem went away, but it's not what you describe in your changelog.
>  From that point the reason might not be compelling.
>
>>> Above commit will cause disaster if someone try to mount a newly created but
>>> later corrupted btrfs filesystem.
> The generation after mkfs is something like 4 or 5, this means that the
> corruption would have to happen in the first few transaction commits,
> this is unlikely and the filesystem will be probably fairly empty at
> that time.
>
> If the concern is about corrupted generation counter itself in the
> superblock, then yes this could hurt.
>
> It's still possible to compare the 1st superblock with the copies, the
> one at offset 64M is available in 99%, there are enough data to make a
> decision what's actually corrupted. This could catch more corruption
> than just the generation counter.
>
>  From the output of btrfs-show-super:
>
> generation              56392
> chunk_root_generation   56392
> cache_generation        56392
> uuid_tree_generation    56392
>
> the generation is duplicated several times, so a minimal patch could be
> to do additional comparison with the others.
Thanks for the explaination.
But in fact, when investigating some bugs (not kernel bugzilla but 
proprietary one), I found not only one but two
disk images whose superblock csum doesn't match and a lot of values go 
crazy.
For example, num_devices goes to 871878361089 and serval bits diffs in 
dev_item.fsid and fsid.
BTW, cache generation is also crazy.

Normally, such superblock should not be mountable since the csum doesn't 
match.
But due to the mentioned commit, the generation (4) is below 10 and 
kernel just ignore the csum error,
and finally, a kernel BUG is triggered, since a lot of things go wrong 
anything is possible.

So I sent the patch and hope to avoid such problem.

Thanks,
Qu
>
>>> And before btrfs entered mainline, btrfs-progs has already superblock
>>> checksum. See btrfs-progs commit: 5ccd1715fa2eaad0b26037bb53706779c8c93b5f
>>> (superblock duplication by Yan Zheng).
> The superblock checksum was not calculated the same way as in kernel,
> but with the missing check this was not detected.
>
>>> Before commit 5ccd17, mkfs.btrfs uses 16K as super offset, while current btrfs
>>> uses 64K super offset, anyway old btrfs without super csum will not be
>>> mountable due to the change of super offset.
>>>
>>> So backward compatibility is not a problem.
> Superblocks at offset 16k are not supported anymore AFAICT.

