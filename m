From: Leonidas Spyropoulos <artafinde@gmail.com>
Subject: Re: synchronous removal?
Date: Mon, 2 Aug 2010 12:35:08 +0100
Message-ID: <AANLkTin=o404zv6qtgfzdbV2KoHkDxTaHEifk26XWnCY@mail.gmail.com>
References: <4C55E2F3.3030202@noir.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
To: "K. Richard Pixley" <rich@noir.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4C55E2F3.3030202@noir.com>
List-ID: <linux-btrfs.vger.kernel.org>

I think a cron job checking the output of df could do that.
The shell script will check if there is enough space to create a snapsh=
ot
otherwise remove a snapshot.

How about that?

On Sun, Aug 1, 2010 at 10:11 PM, K. Richard Pixley <rich@noir.com> wrot=
e:
> =A0I have an application where I want to snapshot, then do something,=
 and
> based on the result, snapshot either the result or the previous state=
 and
> then repeat.
>
> So far, so good. =A0But eventually my disk fills and I want to remove=
 the
> oldest snapshots, as many as I need to in order to make room enough f=
or the
> next cycle.
>
> I notice that when I remove old snapshots and delete old directories,=
 the
> free space on my disk, (according to df), doesn't rise immediately. =A0=
But
> instead, I see an active btrfs_cleaner for a while and my free space =
rises
> while it runs. =A0I'm presuming that the removed files and snapshots =
aren't
> fully reclaimed immediately but rather wait for something akin to a g=
arbage
> collection much the way modern berkeley file systems do.
>
> How can I either:
>
> a) wait for the cleaner to digest the free space
> b) determine that the cleaner has digested all available free space f=
or now,
> (if not I can sleep for a while)
> c) synchronously force the cleaner to digest available free space
> d) something else I haven't thought of yet
>
> Basically, I want to check to see if there's enough space available. =
=A0If
> not, I want to remove some things, (including at least one snapshot),=
 wait
> for the cleaner to digest, and then start over with the checking to s=
ee if
> there's enough space available and loop until I've removed enough thi=
ngs
> that there is enough space available. =A0How can I do that on a btrfs=
 file
> system?
>
> --rich
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs=
" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>



--=20
Caution: breathing may be hazardous to your health.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
