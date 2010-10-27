From: liubo <liubo2009@cn.fujitsu.com>
Subject: Re: [PATCH 1/6] Btrfs: fix deadlock in btrfs_commit_transaction
Date: Wed, 27 Oct 2010 08:41:56 +0800
Message-ID: <4CC77554.3090103@cn.fujitsu.com>
References: <1288033662-21464-1-git-send-email-sage@newdream.net> <1288033662-21464-2-git-send-email-sage@newdream.net> <4CC67930.4030406@cn.fujitsu.com> <Pine.LNX.4.64.1010260931310.7660@cobra.newdream.net> <20101026170615.GE13254@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Chris Mason <chris.mason@oracle.com>,
	Sage Weil <sage@newdream.net>,
	Linux Btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20101026170615.GE13254@think>
List-ID: <linux-btrfs.vger.kernel.org>

On 10/27/2010 01:06 AM, Chris Mason wrote:
> On Tue, Oct 26, 2010 at 09:36:26AM -0700, Sage Weil wrote:
>> On Tue, 26 Oct 2010, liubo wrote:
>>> Since wake_up() itself provides a implied wmb, and a wq active check, 
>>> it is better to drop "if (wq)" in __btrfs_end_transaction().
>> I see.  It could also be
>>
>>         smb_mb();
>>         if (wq)
>>                 wake_up();
>>
>> but just calling wake_up() unconditionally is simpler, and fewer barriers 
>> in the wake_up case.  I'm not attached to the if (wq); I just kept it 
>> because it was there already.
> 
> wake_up() provides an implied barrier because it takes the lock.  I
> usually do the smp_mb() + if (wq) dance when I'm working on a relatively
> hot waitqueue.

Anyway, it is your style.
:) 

thanks,
liubo

> 
> -chris
> 
> 
> 
> 

