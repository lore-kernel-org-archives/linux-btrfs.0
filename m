Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.22]:47075 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752483Ab2HEJSG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 5 Aug 2012 05:18:06 -0400
Message-ID: <501E3A64.1080405@gmx.net>
Date: Sun, 05 Aug 2012 11:18:28 +0200
From: Arne Jansen <sensille@gmx.net>
MIME-Version: 1.0
To: Mitch Harder <mitch.harder@sabayonlinux.org>
CC: Josef Bacik <jbacik@fusionio.com>, linux-btrfs@vger.kernel.org,
        Alexander Block <ablock84@googlemail.com>
Subject: Re: [PATCH] Btrfs: barrier before waitqueue_active
References: <1343852708-24009-1-git-send-email-jbacik@fusionio.com> <CAKcLGm-gow-BgowGmW+kzpZZHPme3Ltr-A4NmnSA+SYdPGwdzw@mail.gmail.com> <CAKcLGm9sJNRmrVvruwpYZM-eQo7TRUY9HwZ5rYOKLo7+KEWWkA@mail.gmail.com>
In-Reply-To: <CAKcLGm9sJNRmrVvruwpYZM-eQo7TRUY9HwZ5rYOKLo7+KEWWkA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 08/03/2012 04:43 PM, Mitch Harder wrote:
> On Wed, Aug 1, 2012 at 7:21 PM, Mitch Harder
> <mitch.harder@sabayonlinux.org> wrote:
>> On Wed, Aug 1, 2012 at 3:25 PM, Josef Bacik <jbacik@fusionio.com> wrote:
>>> We need an smb_mb() before waitqueue_active to avoid missing wakeups.
>>> Before Mitch was hitting a deadlock between the ordered flushers and the
>>> transaction commit because the ordered flushers were waiting for more refs
>>> and were never woken up, so those smp_mb()'s are the most important.
>>> Everything else I added for correctness sake and to avoid getting bitten by
>>> this again somewhere else.  Thanks,
>>>
>>
>> This patch seems to make it tougher to hit a deadlock, but I'm still
>> encountering intermittent deadlocks using this patch when running
>> multiple rsync threads.
>>
>> I've also tested "Patch 2", and that has me hitting a deadlock even
>> quicker (when starting several copying threads).
>>
>> I also found a slight performance hit using this patch.  On a 3.4.6
>> kernel (merged with the 3.5_rc for-linus branch), I would typically
>> complete my rsync test in ~265 seconds.  Also, I can't recall hitting
>> a deadlock on the 3.4.6 kernel (with 3.5_rc for-linus).  When using
>> this patch, the test would take ~310 seconds (when it didn't hit a
>> deadlock).
>>
> 
> I've bisected my deadlock back to:
> Btrfs: hooks for qgroup to record delayed refs (commit 546adb0d).
> 

I've got it reproduced here and, I think, nailed it down. I'll send a
patch tomorrow after discussing it with Jan.

-Arne

> This issue may be the same problem Alexander Block is discussing in
> another thread on the Btrfs Mailing List:
> http://article.gmane.org/gmane.comp.file-systems.btrfs/19028
> 
> I'm using multiple rsync threads instead of the new send/receive
> function.  But we're both hitting deadlocks that bisect back to the
> same commit.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

