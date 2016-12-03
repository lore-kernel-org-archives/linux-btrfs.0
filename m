Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw0-f181.google.com ([209.85.161.181]:34829 "EHLO
        mail-yw0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750949AbcLCUmo (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 3 Dec 2016 15:42:44 -0500
Received: by mail-yw0-f181.google.com with SMTP id i145so236149405ywg.2
        for <linux-btrfs@vger.kernel.org>; Sat, 03 Dec 2016 12:42:43 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1776088.42rHLKPlSp@thetick>
References: <1776088.42rHLKPlSp@thetick>
From: Chris Murphy <lists@colorremedies.com>
Date: Sat, 3 Dec 2016 13:42:42 -0700
Message-ID: <CAJCQCtRxhjKAcZy7wuXCFM1=70eG+TJPwEoyD7zq0iEw8f2urQ@mail.gmail.com>
Subject: Re: system hangs due to qgroups
To: Marc Joliet <marcec@gmx.de>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Dec 3, 2016 at 11:40 AM, Marc Joliet <marcec@gmx.de> wrote:
> Hello all,
>
> I'm having some trouble with btrfs on a laptop, possibly due to qgroups.
> Specifically, some file system activities (e.g., snapshot creation,
> baloo_file_extractor from KDE Plasma) cause the system to hang for up to about
> 40 minutes, maybe more.

Do you get any blocked tasks kernel messages? If so, issue sysrq+w
during the hang, and then check the system log (dmesg may not contain
everything if the command fills the message buffer). If it's a hang
without any kernel messages, then issue sysrq+t.

https://www.kernel.org/doc/Documentation/sysrq.txt




>
> After I next turned on the laptop, the balance resumed, causing bootup to
> fail, after which I remembered about the skip_balance mount option, which I
> tried in a rescue shell from an initramfs.

The file system is the root filesystem? If so, skip_balance may not be
happening soon enough. Use kernel parameter rootflags=skip_balance
which will apply this mount option at the very first moment the file
system is mounted during boot.



> Since I couldn't use skip_balance, and logically can't destroy qgroups on a
> read-only file system, I decided to wait for a regular mount to finish.  That
> has been running since Tuesday, and I am slowly growing impatient.

Haha, no kidding! I think that's very patient.


> Thus I arrive at my question(s): is there anything else I can try, short of
> reformatting and restoring from backup?  Can I use btrfs-check here, or any
> other tool?  Or...?

Yes, btrfs-progs 4.8.5 has the latest qgroup checks, so if there's
something wrong it should find it and if not that's a bug of its own.



> Also, should I be able to avoid reformatting: how do I properly disable quota
> support?

'btrfs quota disable' is the only command that applies to this and it
requires rw mount; there's no 'noquota' mount option.

-- 
Chris Murphy
