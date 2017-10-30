Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f51.google.com ([209.85.218.51]:54037 "EHLO
        mail-oi0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933209AbdJ3Vhp (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 30 Oct 2017 17:37:45 -0400
Received: by mail-oi0-f51.google.com with SMTP id h6so24509648oia.10
        for <linux-btrfs@vger.kernel.org>; Mon, 30 Oct 2017 14:37:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAH=dxU4OV6tQ0hCy_0Ug7eqkOM7HTUWTKjAr4qg+uO2gVxk2Jw@mail.gmail.com>
References: <CAJyZh6S4f=6W+oA6DT1zu2FRuCgO7w8TfRzC96rPWNzUszvRmg@mail.gmail.com>
 <9871a669-141b-ac64-9da6-9050bcad7640@cn.fujitsu.com> <f6428a81-6fc8-1a73-0151-d13dd550c277@rqc.ru>
 <bb12a331-1fec-448a-cbf8-881b434766e7@cn.fujitsu.com> <CAJyZh6RxKuMukM-vCd=_u_8y38MJO_oUG1nYFpaxBroeK8xpAQ@mail.gmail.com>
 <CAH=dxU4OV6tQ0hCy_0Ug7eqkOM7HTUWTKjAr4qg+uO2gVxk2Jw@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Mon, 30 Oct 2017 22:37:43 +0100
Message-ID: <CAJCQCtS9BPZn-hnS+wP7Eu3oHQP_tS8EEM4j4FQDwRmzcFH+_A@mail.gmail.com>
Subject: Re: Problem with file system
To: Dave <davestechshop@gmail.com>
Cc: Linux fs Btrfs <linux-btrfs@vger.kernel.org>,
        Fred Van Andel <vanandel@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Oct 30, 2017 at 4:31 AM, Dave <davestechshop@gmail.com> wrote:
> This is a very helpful thread. I want to share an interesting related story.
>
> We have a machine with 4 btrfs volumes and 4 Snapper configs. I
> recently discovered that Snapper timeline cleanup been turned off for
> 3 of those volumes. In the Snapper configs I found this setting:
>
> TIMELINE_CLEANUP="no"
>
> Normally that would be set to "yes". So I corrected the issue and set
> it to "yes" for the 3 volumes where it had not been set correctly.
>
> I suppose it was turned off temporarily and then somebody forgot to
> turn it back on.
>
> What I did not know, and what I did not realize was a critical piece
> of information, was how long timeline cleanup had been turned off and
> how many snapshots had accumulated on each volume in that time.
>
> I naively re-enabled Snapper timeline cleanup. The instant I started
> the  snapper-cleanup.service  the system was hosed. The ssh session
> became unresponsive, no other ssh sessions could be established and it
> was impossible to log into the system at the console.
>
> My subsequent investigation showed that the root filesystem volume
> accumulated more than 3000 btrfs snapshots. The two other affected
> volumes also had very large numbers of snapshots.
>
> Deleting a single snapshot in that situation would likely require
> hours. (I set up a test, but I ran out of patience before I was able
> to delete even a single snapshot.) My guess is that if we had been
> patient enough to wait for all the snapshots to be deleted, the
> process would have finished in some number of months (or maybe a
> year).
>
> We did not know most of this at the time, so we did what we usually do
> when a system becomes totally unresponsive -- we did a hard reset. Of
> course, we could never get the system to boot up again.
>
> Since we had backups, the easiest option became to replace that system
> -- not unlike what the OP decided to do. In our case, the hardware was
> not old, so we simply reformatted the drives and reinstalled Linux.
>
> That's a drastic consequence of changing TIMELINE_CLEANUP="no" to
> TIMELINE_CLEANUP="yes" in the snapper config.


Without a complete autopsy on the file system, it's unclear whether it
was fixable with available tools, and why it wouldn't mount normally,
or if necessary do its own autorecovery with one of the available
backup roots.

But off hand it sounds like hardware was sabotaging the expected write
ordering. How to test a given hardware setup for that, I think, is
really overdue. It affects literally every file system, and Linux
storage technology.

It kinda sounds like to me something other than supers is being
overwritten too soon, and that's why it's possible for none of the
backup roots to find a valid root tree, because all four possible root
trees either haven't actually been written yet (still) or they've been
overwritten, even though the super is updated. But again, it's
speculation, we don't actually know why your system was no longer
mountable.



>
> It's all part of the process of gaining critical experience with
> BTRFS. Whether or not BTRFS is ready for production use is (it seems
> to me) mostly a question of how knowledgeable and experienced are the
> people administering it.

"Btrfs is a copy on write filesystem for Linux aimed at implementing advanced
features while focusing on fault tolerance, repair and easy administration."

That is the current descriptive text at
Documentation/filesystems/btrfs.txt for some time now.


> In the various online discussions on this topic, all the focus is on
> whether or not BTRFS itself is production-ready. At the current
> maturity level of BTRFS, I think that's the wrong focus. The right
> focus is on how production-ready is the admin person or team (with
> respect to their BTRFS knowledge and experience). When a filesystem
> has been around for decades, most of the critical admin issues become
> fairly common knowledge, fairly widely known and easy to find. When a
> filesystem is newer, far fewer people understand the gotchas. Also, in
> older or widely used filesystems, when someone hits a gotcha, the
> response isn't "that filesystem is not ready for production". Instead
> the response is, "you should have known not to do that."



That is not a general purpose file system. It's a file system for
admins who understand where the bodies are buried.




-- 
Chris Murphy
