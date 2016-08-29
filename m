Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:48372 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752154AbcH2CNC (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 28 Aug 2016 22:13:02 -0400
Subject: Re: btrfs send extremely slow (almost stuck)
To: Oliver Freyermuth <o.freyermuth@googlemail.com>,
        <linux-btrfs@vger.kernel.org>
References: <03b9d0b0-7001-7dd9-75cd-69d58b94d553@googlemail.com>
 <6bebd709-8fdd-5e88-650d-f1c551946505@cn.fujitsu.com>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <d7346353-8e61-27b1-df2f-aabcad0580f4@cn.fujitsu.com>
Date: Mon, 29 Aug 2016 10:12:49 +0800
MIME-Version: 1.0
In-Reply-To: <6bebd709-8fdd-5e88-650d-f1c551946505@cn.fujitsu.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 08/29/2016 10:11 AM, Qu Wenruo wrote:
>
>
> At 08/28/2016 11:38 AM, Oliver Freyermuth wrote:
>> Dear btrfs experts,
>>
>> I just tried to make use of btrfs send / receive for incremental
>> backups (using btrbk to simplify the process).
>> It seems that on my two machines, btrfs send gets stuck after
>> transferring some GiB - it's not fully halted, but instead of making
>> full use of the available I/O, I get something < 500 kiB on average,
>> which are just some "full speed spikes" with many seconds / minutes of
>> no I/O in between.
>>
>> During this "halting", btrfs send eats one full CPU core.
>> A "perf top" shows this is spent in "find_parent_nodes" and
>> "__merge_refs" inside the kernel.
>> I am using btrfs-progs 4.7 and kernel 4.7.0.
>
> Unknown bug, while unfortunately no good idea to solve yet.

Sorry, known bug, not unknown....

Thanks,
Qu
>
> I sent a RFC patch to completely disable shared extent detection, while
> got strong objection.
>
> I also submitted some other ideas on fixing it, while still got strong
> objection. Objection includes this is a performance problem, not a
> function problem and we should focus on function problem first and
> postpone such performance problem.
>
> And further more, Btrfs from the beginning of its design, focuses on
> fast snapshot creation, and takes backref walk as sacrifice.
> So it's not an easy thing to fix.
>
>>
>> I googled a bit and found related patchwork
>> (https://patchwork.kernel.org/patch/9238987/) which seems to
>> workaround high load in this area and mentions a real solution is
>> proposed but not yet there.
>>
>> Since this affects two machines of mine and backupping my root volume
>> would take about 80 hours in case I can extrapolate the average rate,
>> this means btrfs send is unusable to me.
>>
>> Can I assume this is a common issue which will be fixed in a later
>> kernel release (4.8, 4.9) or can I do something to my FS's to
>> workaround this issue?
>
> I don't expect there will be even an agreement on how to fix the problem
> in v4.1x.
>
> Fixes in send will lead to obvious speed improvement, while cause
> incompatibility or super complex design.
> Fixes in backref will lead to a backref rework, which normally comes
> with new regression, and we are even unsure if it will really help.
>
> If you just hate the super slow send, and can accept the extra space
> usage, please try this RFC patch:
>
> https://patchwork.kernel.org/patch/9245287/
>
>
> This patch, just as its name, will completely stop same extent(reflink)
> detection.
> Which will cause more space usage, while it skipped the super time
> consuming find_parent_nodes(), it should at least workaround your problem.
>
> I have some other idea to fix it with less aggressive idea, while since
> there is objection against it, I didn't code it further.
>
> But, since there are *REAL* *WORLD* users reporting such problem, I
> think I'd better restart the fix as an RFC.
>
> Thanks,
> Qu
>>
>> One FS is only two weeks old, the other one now about 1 year. I did
>> some balancing at some points of time to have more unallocated space
>> for trimming,
>> and used duperemove regularly to free space. One FS has skinny
>> extents, the other has not.
>>
>> Mount options are "rw,noatime,compress=zlib,ssd,space_cache,commit=120".
>>
>> Apart from that: No RAID or any other special configuration involved.
>>
>> Cheers and any help appreciated,
>>     Oliver
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


