Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from brockman.in8.de ([85.214.220.56]:44998 "EHLO mail.in8.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758696Ab3G3KeP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 30 Jul 2013 06:34:15 -0400
Message-ID: <51F79530.50006@jan-o-sch.net>
Date: Tue, 30 Jul 2013 12:28:00 +0200
From: Jan Schmidt <mail@jan-o-sch.net>
MIME-Version: 1.0
To: BJ Quinn <bj@placs.net>
CC: Jan Schmidt <list.btrfs@jan-o-sch.net>, linux-btrfs@vger.kernel.org,
        psusi@cfl.rr.com, Freddie Cash <fjwcash@gmail.com>
Subject: Re: Cloning a Btrfs partition
References: <20759263.6051.1375111952352.JavaMail.root@mail.placs.net>
In-Reply-To: <20759263.6051.1375111952352.JavaMail.root@mail.placs.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, July 29, 2013 at 17:32 (+0200), BJ Quinn wrote:
> Thanks for the response!  Not sure I want to roll a custom kernel on this
> particular system.  Any idea on when it might make it to 3.10 stable or 
> 3.11?  Or should I just revert back to 3.9?

I missed that it's in fact in 3.11 and if I got Liu Bo right he's going to send
it to 3.10 stable soon.

Thanks,
-Jan

> Thanks!
> 
> -BJ
> 
> ----- Original Message ----- 
> 
> From: "Jan Schmidt" <list.btrfs@jan-o-sch.net> 
> Sent: Monday, July 29, 2013 3:21:51 AM 
> 
> Hi BJ, 
> 
> [original message rewrapped] 
> 
> On Thu, July 25, 2013 at 18:32 (+0200), BJ Quinn wrote: 
>> (Apologies for the double post -- forgot to send as plain text the first time 
>> around, so the list rejected it.) 
>>
>> I see that there's now a btrfs send / receive and I've tried using it, but 
>> I'm getting the oops I've pasted below, after which the FS becomes 
>> unresponsive (no I/O to the drive, no CPU usage, but all attempts to access 
>> the FS results in a hang). I have an internal drive (single drive) that 
>> contains 82GB of compressed data with a couple hundred snapshots. I tried 
>> taking the first snapshot and making a read only copy (btrfs subvolume 
>> snapshot -r) and then I connected an external USB drive and ran btrfs send / 
>> receive to that external drive. It starts working and gets a couple of GB in 
>> (I'd expect the first snapshot to be about 20GB) and then gets the following 
>> error. I had to use the latest copy of btrfs-progs from git, because the 
>> package installed on my system (btrfs-progs-0.20-0.2.git91d9eec) simply 
>> returned "invalid argument" when trying to run btrfs send / receive. Thanks 
>> in advance for any info you may have. 
> 
> The problem has been introduced with rbtree ulists in 3.10, commit 
> 
> Btrfs: add a rb_tree to improve performance of ulist search 
> 
> You should be safe to revert that commit, it's a performance optimization 
> attempt. Alternatively, you can apply the published fix 
> 
> Btrfs: fix crash regarding to ulist_add_merge 
> 
> It has not made it into 3.10 stable or 3.11, yet, but is contained in Josef's 
> btrfs-next 
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/josef/btrfs-next.git 
> 
> Thanks, 
> -Jan 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
