Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-gg0-f174.google.com ([209.85.161.174]:41755 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754098Ab2HCOnJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 3 Aug 2012 10:43:09 -0400
Received: by ggnl2 with SMTP id l2so908003ggn.19
        for <linux-btrfs@vger.kernel.org>; Fri, 03 Aug 2012 07:43:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAKcLGm-gow-BgowGmW+kzpZZHPme3Ltr-A4NmnSA+SYdPGwdzw@mail.gmail.com>
References: <1343852708-24009-1-git-send-email-jbacik@fusionio.com>
	<CAKcLGm-gow-BgowGmW+kzpZZHPme3Ltr-A4NmnSA+SYdPGwdzw@mail.gmail.com>
Date: Fri, 3 Aug 2012 09:43:09 -0500
Message-ID: <CAKcLGm9sJNRmrVvruwpYZM-eQo7TRUY9HwZ5rYOKLo7+KEWWkA@mail.gmail.com>
Subject: Re: [PATCH] Btrfs: barrier before waitqueue_active
From: Mitch Harder <mitch.harder@sabayonlinux.org>
To: Josef Bacik <jbacik@fusionio.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Aug 1, 2012 at 7:21 PM, Mitch Harder
<mitch.harder@sabayonlinux.org> wrote:
> On Wed, Aug 1, 2012 at 3:25 PM, Josef Bacik <jbacik@fusionio.com> wrote:
>> We need an smb_mb() before waitqueue_active to avoid missing wakeups.
>> Before Mitch was hitting a deadlock between the ordered flushers and the
>> transaction commit because the ordered flushers were waiting for more refs
>> and were never woken up, so those smp_mb()'s are the most important.
>> Everything else I added for correctness sake and to avoid getting bitten by
>> this again somewhere else.  Thanks,
>>
>
> This patch seems to make it tougher to hit a deadlock, but I'm still
> encountering intermittent deadlocks using this patch when running
> multiple rsync threads.
>
> I've also tested "Patch 2", and that has me hitting a deadlock even
> quicker (when starting several copying threads).
>
> I also found a slight performance hit using this patch.  On a 3.4.6
> kernel (merged with the 3.5_rc for-linus branch), I would typically
> complete my rsync test in ~265 seconds.  Also, I can't recall hitting
> a deadlock on the 3.4.6 kernel (with 3.5_rc for-linus).  When using
> this patch, the test would take ~310 seconds (when it didn't hit a
> deadlock).
>

I've bisected my deadlock back to:
Btrfs: hooks for qgroup to record delayed refs (commit 546adb0d).

This issue may be the same problem Alexander Block is discussing in
another thread on the Btrfs Mailing List:
http://article.gmane.org/gmane.comp.file-systems.btrfs/19028

I'm using multiple rsync threads instead of the new send/receive
function.  But we're both hitting deadlocks that bisect back to the
same commit.
