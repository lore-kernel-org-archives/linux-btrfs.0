Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw0-f172.google.com ([209.85.161.172]:34141 "EHLO
        mail-yw0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753944AbcLKXlH (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 11 Dec 2016 18:41:07 -0500
Received: by mail-yw0-f172.google.com with SMTP id t125so52990278ywc.1
        for <linux-btrfs@vger.kernel.org>; Sun, 11 Dec 2016 15:41:07 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CADph71zoOB72o2PoUY_qqMsg_TpvBokugR9UzZHo6kPsNm4PNg@mail.gmail.com>
References: <CADph71xWQyFca34=K9b-1sSNUCChUnBggvcj1O5NKi8hpQjvfA@mail.gmail.com>
 <CAJCQCtTC5T0v6jZpALTPwn=CvWn-kJXZX2vVFAEjjk9xokqoPQ@mail.gmail.com>
 <CADph71wae2AQT-v-hu0YcJdNE+dWxRZ7yQVmMEMLyhzsC-FHqQ@mail.gmail.com>
 <CAJCQCtT5CG4M4nYmmefEfWjapmg3TpMXJSVmTE89r6iPxV6xHw@mail.gmail.com> <CADph71zoOB72o2PoUY_qqMsg_TpvBokugR9UzZHo6kPsNm4PNg@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Sun, 11 Dec 2016 16:41:06 -0700
Message-ID: <CAJCQCtQLRRaAyCa8DBHmcizcLHTajmp_vzGU7MkEvshtO4bbNQ@mail.gmail.com>
Subject: Re: btrfs-find-root duration?
To: Markus Binsteiner <makkus@gmail.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Dec 11, 2016 at 4:30 PM, Markus Binsteiner <makkus@gmail.com> wrote:
>> OK when I do it on a file system with just 14GiB of metadata it's
>> maybe 15 seconds. So a few minutes sounds sorta suspicious to me but,
>> *shrug* I don't have a file system the same size to try it on, maybe
>> it's a memory intensive task and once the system gets low on RAM while
>> traversing the file system it slows done a ton.
>
> Ok, thanks, looks like there is some other issue then as well. The
> process doesn't take up any memory at all, just 100% of one core.
>
> Maybe I'll try to use it with an older version of btrfs-progs, from
> Debian Jessie. Don't think it'll make any difference, but I don't know
> what else to try. At this point I'm more curious than anything else.
> I've got backups for most of my stuff, just a few rogue scripts I'd
> have to re-write. Still, would be nice to get those back.

You might try 'btrfs check' without repairing, using a recent version
of btrfs-progs and see if it finds anything unusual.

Although, are there many snapshots? That would cause the rentention of roots.


-- 
Chris Murphy
