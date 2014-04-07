Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:34192 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755316AbaDGTcX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 7 Apr 2014 15:32:23 -0400
Message-ID: <5342FD3D.3090905@fb.com>
Date: Mon, 7 Apr 2014 15:32:13 -0400
From: Chris Mason <clm@fb.com>
MIME-Version: 1.0
To: Marc MERLIN <marc@merlins.org>, Josef Bacik <jbacik@fb.com>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs on 3.14rc5 stuck on "btrfs_tree_read_lock           sync"
References: <20140407160506.GG10789@merlins.org> <5342CE0C.3070707@fb.com> <20140407185121.GI10222@merlins.org>
In-Reply-To: <20140407185121.GI10222@merlins.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 04/07/2014 02:51 PM, Marc MERLIN wrote:
> On Mon, Apr 07, 2014 at 12:10:52PM -0400, Josef Bacik wrote:
>> On 04/07/2014 12:05 PM, Marc MERLIN wrote:
>>> I was debugging my why backup failed to run, and eventually found it was
>>> stuck on sync:
>>> 14080       18:18 btrfs_tree_read_lock           sync
>>>
>>> This was hung for hours on this lock.
>>>
>>> Strangely, it looks like taking my sysrq-w hung the machine pretty hard for
>>> close to 30sec, but this seems to have unhung sync and in the end btrfs send
>>> completed after that.
>>>
>>> Sysqrq-w is here:
>>> https://urldefense.proofpoint.com/v1/url?u=http://marc.merlins.org/tmp/sysrq-btrfs-sync-hang.txt&k=ZVNjlDMF0FElm4dQtryO4A%3D%3D%0A&r=cKCbChRKsMpTX8ybrSkonQ%3D%3D%0A&m=IHXWC1Chbc0jEiUWu1v4Va9NOphtjPbjYp6yVMdUmXM%3D%0A&s=bd787a3422e9ff0972d2d09de7d424f56589aadc9d6db33e19fc44886dce604f
>>
>> Try Chris's integration branch in a few hours and see if that fixes
>> it.  Thanks,
>
> Mmmh, so I rebooted that server with 3.14.0 (no rc), and it was
> deadlocked a long time during boot (about 10mn) before it unlocked
> itself and finished booting.
>
> This is a bit vexing, I don't yet know which of my 3 btrfs filesystems
> is causing this, and how to fix it.
> After boot, it seems ok enough.
>
> You're recommending that I try btrfs-next on a 3.15 pre kernel, correct?
> If so would it be likely to fix my filesystem and let me go back to a
> stable 3.14? (I'm a bit warry about running some unstable 3.15 on it :).
>

Right now the fixes for this are in the integration branch on my git 
tree.  I think we've shaken  out all the problems, but if you want to 
wait until tomorrow I'll have it in my next branch (for linux-next).

-chris
