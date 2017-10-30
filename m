Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f43.google.com ([74.125.82.43]:56501 "EHLO
        mail-wm0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751332AbdJ3DcT (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 29 Oct 2017 23:32:19 -0400
Received: by mail-wm0-f43.google.com with SMTP id z3so13528491wme.5
        for <linux-btrfs@vger.kernel.org>; Sun, 29 Oct 2017 20:32:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJyZh6RxKuMukM-vCd=_u_8y38MJO_oUG1nYFpaxBroeK8xpAQ@mail.gmail.com>
References: <CAJyZh6S4f=6W+oA6DT1zu2FRuCgO7w8TfRzC96rPWNzUszvRmg@mail.gmail.com>
 <9871a669-141b-ac64-9da6-9050bcad7640@cn.fujitsu.com> <f6428a81-6fc8-1a73-0151-d13dd550c277@rqc.ru>
 <bb12a331-1fec-448a-cbf8-881b434766e7@cn.fujitsu.com> <CAJyZh6RxKuMukM-vCd=_u_8y38MJO_oUG1nYFpaxBroeK8xpAQ@mail.gmail.com>
From: Dave <davestechshop@gmail.com>
Date: Sun, 29 Oct 2017 23:31:57 -0400
Message-ID: <CAH=dxU4OV6tQ0hCy_0Ug7eqkOM7HTUWTKjAr4qg+uO2gVxk2Jw@mail.gmail.com>
Subject: Re: Problem with file system
To: Linux fs Btrfs <linux-btrfs@vger.kernel.org>
Cc: Fred Van Andel <vanandel@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a very helpful thread. I want to share an interesting related story.

We have a machine with 4 btrfs volumes and 4 Snapper configs. I
recently discovered that Snapper timeline cleanup been turned off for
3 of those volumes. In the Snapper configs I found this setting:

TIMELINE_CLEANUP="no"

Normally that would be set to "yes". So I corrected the issue and set
it to "yes" for the 3 volumes where it had not been set correctly.

I suppose it was turned off temporarily and then somebody forgot to
turn it back on.

What I did not know, and what I did not realize was a critical piece
of information, was how long timeline cleanup had been turned off and
how many snapshots had accumulated on each volume in that time.

I naively re-enabled Snapper timeline cleanup. The instant I started
the  snapper-cleanup.service  the system was hosed. The ssh session
became unresponsive, no other ssh sessions could be established and it
was impossible to log into the system at the console.

My subsequent investigation showed that the root filesystem volume
accumulated more than 3000 btrfs snapshots. The two other affected
volumes also had very large numbers of snapshots.

Deleting a single snapshot in that situation would likely require
hours. (I set up a test, but I ran out of patience before I was able
to delete even a single snapshot.) My guess is that if we had been
patient enough to wait for all the snapshots to be deleted, the
process would have finished in some number of months (or maybe a
year).

We did not know most of this at the time, so we did what we usually do
when a system becomes totally unresponsive -- we did a hard reset. Of
course, we could never get the system to boot up again.

Since we had backups, the easiest option became to replace that system
-- not unlike what the OP decided to do. In our case, the hardware was
not old, so we simply reformatted the drives and reinstalled Linux.

That's a drastic consequence of changing TIMELINE_CLEANUP="no" to
TIMELINE_CLEANUP="yes" in the snapper config.

It's all part of the process of gaining critical experience with
BTRFS. Whether or not BTRFS is ready for production use is (it seems
to me) mostly a question of how knowledgeable and experienced are the
people administering it.

In the various online discussions on this topic, all the focus is on
whether or not BTRFS itself is production-ready. At the current
maturity level of BTRFS, I think that's the wrong focus. The right
focus is on how production-ready is the admin person or team (with
respect to their BTRFS knowledge and experience). When a filesystem
has been around for decades, most of the critical admin issues become
fairly common knowledge, fairly widely known and easy to find. When a
filesystem is newer, far fewer people understand the gotchas. Also, in
older or widely used filesystems, when someone hits a gotcha, the
response isn't "that filesystem is not ready for production". Instead
the response is, "you should have known not to do that."

On Wed, Apr 26, 2017 at 12:43 PM, Fred Van Andel <vanandel@gmail.com> wrote:
> Yes I was running qgroups.
> Yes the filesystem is highly fragmented.
> Yes I have way too many snapshots.
>
> I think it's clear that the problem is on my end. I simply placed too
> many demands on the filesystem without fully understanding the
> implications.  Now I have to deal with the consequences.
>
> It was decided today to replace this computer due to its age.  I will
> use the recover command to pull the needed data off this system and
> onto the new one.
>
>
> Thank you everyone for your assistance and the education.
>
> Fred
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
