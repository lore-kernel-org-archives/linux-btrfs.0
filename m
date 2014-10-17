Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:47557 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751194AbaJQMxV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 17 Oct 2014 08:53:21 -0400
Date: Fri, 17 Oct 2014 08:53:06 -0400
From: Chris Mason <clm@fb.com>
Subject: Re: unexplainable corruptions 3.17.0
To: Tomasz Torcz <tomek@pipebreaker.pl>
CC: <linux-btrfs@vger.kernel.org>
Message-ID: <1413550386.755.1@mail.thefacebook.com>
In-Reply-To: <20141017085448.GA1050018@mother.pipebreaker.pl>
References: <20141017085448.GA1050018@mother.pipebreaker.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Oct 17, 2014 at 4:54 AM, Tomasz Torcz <tomek@pipebreaker.pl> 
wrote:
> On Fri, Oct 17, 2014 at 04:29:36PM +0800, Liu Bo wrote:
>>  On Fri, Oct 17, 2014 at 10:10:09AM +0200, Tomasz Torcz wrote:
>>  > On Fri, Oct 17, 2014 at 04:02:03PM +0800, Liu Bo wrote:
>>  > > >   Recently I've observed some corruptions to systemd's journal
>>  > > > files which are somewhat puzzling. This is especially worrying
>>  > > > as this is btrfs raid1 setup and I expected auto-healing.
>>  > > > read(4, 0x1001000, 65536)               = -1 EIO 
>> (Input/output error)
>> 
>>  Well..I don't know exactly what's the cause, but as the file is 
>> NOCOW, it writes
>>  data in place, have you experienced a hard reboot or something 
>> recently?
> 
>   Nothing like that.  Server is on an UPS, there were couple normal 
> shutdowns
> this year (few kernel upgrades).
> 
>>  And any message in dmesg log while getting EIO by reading the file?
> 
>   Nothing in dmesg, no btrfs messages, no SCSI/SATA errors, nothing. 
> That's
> why I find those corruptions mysterious.
>   Maybe there is some way to inspect internal btrfs state and find 
> out what
> causing the problems?  Or maybe this is related to patch mentioned in 
> this thread?

This sounds like the problem fixed with some patches to our extent 
mapping code  that went in with the merge window.  I've cherry picked a 
few for stable and I'm running them through tests now.  They are in my 
stable-3.17 branch, and I'll send to Greg once Linus grabs the revert 
for the last one.

But, if you want to try that branch out, it may fix this EIO.  
Otherwise we'll start sending you debugging.

-chris



