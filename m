Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f53.google.com ([209.85.218.53]:34416 "EHLO
	mail-oi0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753324AbcGaQ7B (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 31 Jul 2016 12:59:01 -0400
Received: by mail-oi0-f53.google.com with SMTP id l65so165629967oib.1
        for <linux-btrfs@vger.kernel.org>; Sun, 31 Jul 2016 09:59:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <2f672600-c80b-c884-6da3-07b067a1816d@gmail.com>
References: <CAJCQCtQ4CXjBzR6eo0zibDCb9_p0jAiS2q_fCRUkUNVWiM9i6g@mail.gmail.com>
 <2f672600-c80b-c884-6da3-07b067a1816d@gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Sun, 31 Jul 2016 10:58:54 -0600
Message-ID: <CAJCQCtSwBNz0Y-zUiAigvkeiK-iVVid+d8iCrmqbZcR9FJJ1mQ@mail.gmail.com>
Subject: Re: systemd KillUserProcesses=yes and btrfs scrub
To: Gabriel C <nix.or.die@gmail.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Jul 31, 2016 at 4:56 AM, Gabriel C <nix.or.die@gmail.com> wrote:
>
>
> On 30.07.2016 22:02, Chris Murphy wrote:
>> Short version: When systemd-logind login.conf KillUserProcesses=yes,
>> and the user does "sudo btrfs scrub start" in e.g. GNOME Terminal, and
>> then logs out of the shell, the user space operation is killed, and
>> btrfs scrub status reports that the scrub was aborted. [1]
>>
>
> How this is a bug ?

If the privilege escalated operation (kernel threads included) are
clobbered, then it's a bug because there's every reason for a user to
issue this command that could take hours or days, and not have to stay
logged into to their GUI shell session while it runs, for example over
the weekend. Yes of course they could schedule it but saying they
could do it another way doesn't fix the use case of doing it manually.

If the operation continues, and just the user space command is killed
off, it's a bug because the statistics and status of the scrub are
lost to future status checks; that is, "interrupted" is sufficiently
misleading that it's false. The operation did continue, we've just
lost the conclusion.

Balance and replace, while user process is killed, kernel process
continues, and it's still possible for a user to get current (and
correct) status information for both.

Further it's arguably a regression compared to equivalent mdadm and
LVM RAID behaviors.


>
> Is excatly what 'KillUserProcesses=yes' is extected to do..
>

No, it basically breaks scrub initiated within a user's GUI session
and that is in no way intended by anyone, it's a side effect. The
question is how to fix it, not debate whether it's a bug, that's
ridiculous.

-- 
Chris Murphy
