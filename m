Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f46.google.com ([74.125.82.46]:45267 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966540AbaFRNYx (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 18 Jun 2014 09:24:53 -0400
Received: by mail-wg0-f46.google.com with SMTP id y10so846360wgg.5
        for <linux-btrfs@vger.kernel.org>; Wed, 18 Jun 2014 06:23:09 -0700 (PDT)
Message-ID: <53A192B8.2040601@gmail.com>
Date: Wed, 18 Jun 2014 16:23:04 +0300
From: Konstantinos Skarlatos <k.skarlatos@gmail.com>
MIME-Version: 1.0
To: Marc MERLIN <marc@merlins.org>,
        Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
CC: linux-btrfs@vger.kernel.org, Chris Mason <clm@fb.com>,
        torvalds@linux-foundation.org
Subject: Re: frustrations with handling of crash reports
References: <20140519134915.GA27432@merlins.org> <539FE03F.5030306@jp.fujitsu.com> <20140617145957.GH19071@merlins.org> <20140617182745.GO19071@merlins.org>
In-Reply-To: <20140617182745.GO19071@merlins.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 17/6/2014 9:27 μμ, Marc MERLIN wrote:
> On Tue, Jun 17, 2014 at 07:59:57AM -0700, Marc MERLIN wrote:
>> It is also ok to answer "Any FS created or used before kernel 3.x can be
>> corrupted due to bugs we fixed in 3.y, thank you for your report but it's
>> not a good use of our time to investigate this"
>> (although newer kernels should not just crash with BUG(xxx) on unexpected
>> data, they should remount the FS read only).
> I was thinking about this some more, and I know I have no right to tell
> others what to do, so take this as a mere suggestion :)
>
> How about doing a release with cleanups and stabilization and better state
> reporting when things go wrong?
>
> This would give a good known version for users who have actual data and
> backups that can take many hours or days to restore (never mind downtime).
>
> A few things I was thinking about:
> 1) Wouldn't it be a good time to replace all the BUG ON statements with
> appropriate error handling? Unexpected data can happen, the kernel shouldn't
> crash that.
> At the very least it should remount read only and give maybe a wiki link to
> the user on what to do next (some bu reporting and recovery page)
>
> 2) On unexpected cases, output basic information on the filesystem or printk
> instructions to the user on how to gather data that would be sent to the
> list to be reviewed.
> This would include information on how old the filesystem is when it's
> possible to detect, and the instruction page could say "sorry, anything
> older than X, we don't want to hear about, we already fixed corruption bugs
> since then"
>
> 3) getting printk data on an end user machine when it just started refusing
> to write to disk can be challenging and cause useful debug info to be lost.
> Things I thinking about:
> a) make sure most btrfs bugs do not just hang the kernel
> b) recommend to users to send kernel syslog messages to an ext4 partition
>
> How does that sound?
I 100% agree with this. I also have a problem where btrfs decides to 
BUG_ON and force a kernel panic because it has found an unexpected type 
of metadata. Although in my case I was more lucky and had help and test 
patches from Liu Bo, I am still of the opinion that btrfs should not 
take down a whole system because it found something unexpected.

I guess that btrfs developers have put these BUG_ONs so that they get 
reports from users when btrfs gets in these unexpected situations. But 
if most of these reports are ignored or not resolved, then maybe there 
is no use for these BUG_ONs and they should be replaced with something 
more mild.

Keep in mind that if a system panics, then the only way to get logs from 
it is with serial or netconsole, so BUG_ON really makes it much harder 
for users to know what happened and send reports, and only the most 
technical and determined users will manage to send reports here. So I 
can guess that the real number of kernel panics due to btrfs is much 
higher, and most people are unable to report them, because they _never 
know_ that it was btrfs that caused their crash.

I know btrfs is still experimental, but it is in kernel since 
2009-01-09, so I think most users have some expectation of stability 
after something is 5.5 years in the mainline kernel.

So my suggestion is that basicaly the same with Marc's:

These BUG_ONs should be replaced with something that does not crash the 
system and gives out as much info as possible, so that users do not have 
to get here and ask for a debugging patch.  After all, btrfs is still 
experimental, right? :)

Furthermore, these problems should either remount the fs as readonly, or 
try to make the file that is implicated readonly, and report the 
filename, so users can delete it and continue with their lives without 
having to mkfs every few months. Or even make fsck able to fix these, 
and not choke on a few TB filesystem because it wants to use ridiculous 
amounts of RAM.

In general, btrfs must get _much_ better at reporting what happened, 
which file was implicated and if it is a multiple disk fs, the disk 
where the problem is and the sector where that occured.

PS.
I am not a kernel developer, so please be kind if I have said something 
completely wrong :)

>
> Thanks,
> Marc


-- 
Konstantinos Skarlatos

