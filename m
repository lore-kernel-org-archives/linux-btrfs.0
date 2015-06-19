Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:45588 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751400AbbFSB0U (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 18 Jun 2015 21:26:20 -0400
Subject: Re: [PATCH RFC] btrfs: csum: Introduce partial csum for tree block.
To: <dsterba@suse.cz>, Facebook <clm@fb.com>, <linux-btrfs@vger.kernel.org>
References: <1434078015-8868-1-git-send-email-quwenruo@cn.fujitsu.com>
 <557B076B.7050500@fb.com> <557E86A9.8040207@cn.fujitsu.com>
 <20150615131507.GL6761@twin.jikos.cz> <557F7A5F.5010206@cn.fujitsu.com>
 <557F8C78.7080304@cn.fujitsu.com> <55822008.1090305@cn.fujitsu.com>
 <1434643066.28534.0@mail.thefacebook.com> <20150618170632.GI6761@suse.cz>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <55836FB3.1060704@cn.fujitsu.com>
Date: Fri, 19 Jun 2015 09:26:11 +0800
MIME-Version: 1.0
In-Reply-To: <20150618170632.GI6761@suse.cz>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



David Sterba wrote on 2015/06/18 19:06 +0200:
> On Thu, Jun 18, 2015 at 11:57:46AM -0400, Facebook wrote:
>>> New new comments?
>>
>> As our block sizes get bigger, it makes sense to think about more fine
>> grained checksums.  We're using crcs for:
>>
>> 1) memory corruption on the way down to the storage.  We could be very
>> small (bitflips) or smaller chunks (dma corrupting the whole bio).  The
>> places I've seen this in production, the partial crcs might help save a
>> percentage of the blocks, but overall the corruptions were just too
>> pervasive to get back the data.
>>
>> 2) incomplete writes.  We're sending down up to 64K btree blocks, the
>> storage might only write some of them.
>>
>> 3) IO errors from the drive.  These are likely to fail in much bigger
>> chunks and the partial csums probably won't help at all.
>>
>> I think the best way to repair all of these is with replication, either
>> RAID5/6 or some number of mirrored copies.  It's more reliable than
>> trying to stitch together streams from multiple copies, and the code
>> complexity is much lower.
>
> I agree with that. I'm still not convinced that adding all the kernel
> code to repair the data is justified, compared to the block-level
> redundancy alternatives.

Totally agree with this.
That's why we have support for RAID1/5/6/10.

I also hate to add complexity to kernel codes, especially when the scrub 
codes are already quite complex.

But in fact, my teammate Zhao Lei is already doing some work to make 
scrub codes clean and neat.
During his work, one of the thing needs to clean is the function to use 
the bios without IO error to rebuild a tree block from different mirrors.

I found it quite similar with the concept of partial csum, and may 
extract some quite generic codes for both of them, and hope to reduce 
the code amount overall.

But anyway, the main part, scrub support for partial csum, is still just
a basic idea(although some coding is already done), so I hopes to see 
more ideas even it's against partial csum.

>
>> But, where I do find the partial crcs interesting is the ability to
>> more accurately detect those three failure modes with our larger block
>> sizes.  That's pure statistics based on the crc we've chosen and the
>> size of the block.  The right answer might just be a different crc, but
>> I'm more than open to data here.
>
> Good point, the detection aspect costs only the increased checksumming
> and reporting. My assumption is that this will happen infrequently and
> can point out serious hardware problems. In that case taking the
> filesytem offline is a workable option and improving the userspace tools
> to actually attempt the targeted block repair seems easier. Note that
> this would come after redundant raid would not be able to fix it.
>

My original cause for partial csum is to improve btrfsck btree repair codes.
Current btree repair codes will drop all child nodes/leaves, which is 
quite a big loss, and deadly if the error happens at tree root.
If using partial csum, we can reduce the damage to as less as 1/8 of the 
node/leave.

So I'm completely OK to implement it in btrfsck, as it's much much 
easier to code and debug in user-space.


But the level of repair is not as high as btrfsck, which overall do 
repair in a higher level, like inode/file/extent repair.
With the nature of partial csum, it leans towards block level more.
So the idea comes to me to do it in kernel scrub codes.

For my personal opinion, if Zhao Lei and I can make the scrub codes much 
clearer and neater, I still consider the kernel scrub implement worthy a 
try.

Thanks,
Qu
