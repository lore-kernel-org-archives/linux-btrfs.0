Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f47.google.com ([209.85.214.47]:36345 "EHLO
        mail-it0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753525AbcHYLcd (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 25 Aug 2016 07:32:33 -0400
Received: by mail-it0-f47.google.com with SMTP id e63so265486884ith.1
        for <linux-btrfs@vger.kernel.org>; Thu, 25 Aug 2016 04:32:33 -0700 (PDT)
Subject: Re: Please disable balance auto-resume for 4.9 (or even 4.8)
To: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <57BEBC92.2040404@applied-asynchrony.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <94acabb3-03c2-fc93-60c6-af55d67b0b5e@gmail.com>
Date: Thu, 25 Aug 2016 07:32:25 -0400
MIME-Version: 1.0
In-Reply-To: <57BEBC92.2040404@applied-asynchrony.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-08-25 05:38, Holger Hoffstätte wrote:
>
> Automatically resuming an interrupted balance has repeatedly caused all
> sorts of problems because it creates a possible failure mode when a user
> can least use it: after a crash/power loss/sudden reboot (which, like it
> or not, is the de facto "fix random problems" approach for many people).
>
> The idea behind the automnatic resume is good and important for cases
> like automation and unattended operation, but nevertheless right now
> it creates more problems than it fixes.
I would tend to agree.

If the system crashed in the middle of a balance, then we can't assume 
it was something other than the filesystem being balanced that caused 
the crash.  Resuming a balance in such a situation is risky and could 
even trigger another crash (yes, I've actually seen this happen, and it 
was a serious pain to debug).  If the balance was paused so the system 
could reboot with the intent of resuming it later, then the user knows 
they did this, and should be more than capable of resuming it themself. 
I've gotten to the point that all of the filesystems I manage have 
'skip_balance' in their mount options to avoid all the issues I've had, 
and because resuming a balance on a filesystem which is mounted on boot 
can insanely slow down the boot process.
>
> As far as I can see it should be easy enough to simply disable calling
> btrfs_resume_balance_async() at least on mount (in open_ctree()) and
> possibly on remount as well. The skip_balance flag could then simply
> be ignored or removed.
>
> I can't say how much work it would be to completely remove the persistent
> balance state or whether it is useful to be kept around for resume, but at
> least not continuing would stop filesystems from eating themselves further
> on mount.
I think we should keep the persistent balance state, it has on multiple 
occasions been useful to me (running a balance, power loss or some other 
condition requiring shutdown imminent, so I paused, shutdown, and then 
resumed after reboot), and removing it completely may break some things.

Personally, I think we should add an option to force resuming a balance 
on mount (resume_balance maybe?), and then switch to skip_balance being 
default.  This would allow people who still want the auto-resume 
behavior to keep it, while making the defaults safer.
