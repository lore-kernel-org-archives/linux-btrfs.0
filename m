Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:26834 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932833AbaCQOe4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 17 Mar 2014 10:34:56 -0400
Message-ID: <532707FB.3010000@fb.com>
Date: Mon, 17 Mar 2014 10:34:35 -0400
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: Rich Freeman <r-btrfs@thefreemanclan.net>
CC: Zach Brown <zab@redhat.com>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: fix deadlock with nested trans handles
References: <1394150467-5990-1-git-send-email-jbacik@fb.com>	<20140307002549.GC16439@lenny.home.zabbo.net>	<CAGfcS_nPkVR3Z8JHi=g1QFdvqqYBeVSATjyi+4qfyWTs_5_tDQ@mail.gmail.com>	<53207C4B.6020000@fb.com>	<CAGfcS_ktoasT-esMTcLbF+o_-4KTirZghtJ5+o4goZDTY4DW0A@mail.gmail.com> <CAGfcS_=AZLFtnQfKaoDtnJB9n_PrKsNkhcQFM+g--SCwV+43Fg@mail.gmail.com>
In-Reply-To: <CAGfcS_=AZLFtnQfKaoDtnJB9n_PrKsNkhcQFM+g--SCwV+43Fg@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 03/14/2014 06:40 PM, Rich Freeman wrote:
> On Wed, Mar 12, 2014 at 12:34 PM, Rich Freeman
> <r-btrfs@thefreemanclan.net> wrote:
>> On Wed, Mar 12, 2014 at 11:24 AM, Josef Bacik <jbacik@fb.com> wrote:
>>> On 03/12/2014 08:56 AM, Rich Freeman wrote:
>>>>
>>>>   After a number of reboots the system became stable, presumably
>>>> whatever race condition btrfs was hitting followed a favorable
>>>> path.
>>>>
>>>> I do have a 2GB btrfs-image pre-dating my application of this
>>>> patch that was causing the issue last week.
>>>>
>>>
>>> Uhm wow that's pretty epic.  I will talk to chris and figure out how
>>> we want to deal with that and send you a patch shortly.  Thanks,
>>
>> A tiny bit more background.
>
> And some more background.  I had more reboots over the next two days
> at the same time each day, just after my crontab successfully
> completed.  One of the last thing it does is runs the snapper cleanups
> which delete a bunch of snapshots.  During a reboot I checked and
> there were a bunch of deleted snapshots, which disappeared over the
> next 30-60 seconds before the panic, and then they would re-appear on
> the next reboot.
>
> I disabled the snapper cron job and this morning had no issues at all.
>   One day isn't much to establish a trend, but I suspect that this is
> the cause.  Obviously getting rid of snapshots would be desirable at
> some point, but I can wait for a patch.  Snapper would be deleting
> about 48 snapshots at the same time, since I create them hourly and
> the cleanup occurs daily on two different subvolumes on the same
> filesystem.

Ok that's helpful, I'm no longer positive I know what's causing this, 
I'll try to reproduce once I've nailed down these backref problems and 
balance corruption.  Thanks,

Josef

