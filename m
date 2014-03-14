Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vc0-f181.google.com ([209.85.220.181]:35677 "EHLO
	mail-vc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755341AbaCNWk0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 14 Mar 2014 18:40:26 -0400
Received: by mail-vc0-f181.google.com with SMTP id id10so3487896vcb.12
        for <linux-btrfs@vger.kernel.org>; Fri, 14 Mar 2014 15:40:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAGfcS_ktoasT-esMTcLbF+o_-4KTirZghtJ5+o4goZDTY4DW0A@mail.gmail.com>
References: <1394150467-5990-1-git-send-email-jbacik@fb.com>
	<20140307002549.GC16439@lenny.home.zabbo.net>
	<CAGfcS_nPkVR3Z8JHi=g1QFdvqqYBeVSATjyi+4qfyWTs_5_tDQ@mail.gmail.com>
	<53207C4B.6020000@fb.com>
	<CAGfcS_ktoasT-esMTcLbF+o_-4KTirZghtJ5+o4goZDTY4DW0A@mail.gmail.com>
Date: Fri, 14 Mar 2014 18:40:25 -0400
Message-ID: <CAGfcS_=AZLFtnQfKaoDtnJB9n_PrKsNkhcQFM+g--SCwV+43Fg@mail.gmail.com>
Subject: Re: [PATCH] Btrfs: fix deadlock with nested trans handles
From: Rich Freeman <r-btrfs@thefreemanclan.net>
To: Josef Bacik <jbacik@fb.com>
Cc: Zach Brown <zab@redhat.com>, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Mar 12, 2014 at 12:34 PM, Rich Freeman
<r-btrfs@thefreemanclan.net> wrote:
> On Wed, Mar 12, 2014 at 11:24 AM, Josef Bacik <jbacik@fb.com> wrote:
>> On 03/12/2014 08:56 AM, Rich Freeman wrote:
>>>
>>>  After a number of reboots the system became stable, presumably
>>> whatever race condition btrfs was hitting followed a favorable
>>> path.
>>>
>>> I do have a 2GB btrfs-image pre-dating my application of this
>>> patch that was causing the issue last week.
>>>
>>
>> Uhm wow that's pretty epic.  I will talk to chris and figure out how
>> we want to deal with that and send you a patch shortly.  Thanks,
>
> A tiny bit more background.

And some more background.  I had more reboots over the next two days
at the same time each day, just after my crontab successfully
completed.  One of the last thing it does is runs the snapper cleanups
which delete a bunch of snapshots.  During a reboot I checked and
there were a bunch of deleted snapshots, which disappeared over the
next 30-60 seconds before the panic, and then they would re-appear on
the next reboot.

I disabled the snapper cron job and this morning had no issues at all.
 One day isn't much to establish a trend, but I suspect that this is
the cause.  Obviously getting rid of snapshots would be desirable at
some point, but I can wait for a patch.  Snapper would be deleting
about 48 snapshots at the same time, since I create them hourly and
the cleanup occurs daily on two different subvolumes on the same
filesystem.

Rich
