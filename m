Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f181.google.com ([209.85.214.181]:36674 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932269AbcF2TIc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 29 Jun 2016 15:08:32 -0400
Received: by mail-ob0-f181.google.com with SMTP id mu6so39474559obc.3
        for <linux-btrfs@vger.kernel.org>; Wed, 29 Jun 2016 12:08:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160629210217.0e4e4d1c@system>
References: <20160627233612.662d2a9a@system> <CAJCQCtT_vbOzbvMOuV6wgvz4iMHcpQmAhX-y1-dkOi6F323KRg@mail.gmail.com>
 <20160628002602.022258bf@system> <CAJCQCtR3FQ-Pe40dOcKGgd+8paraHuCoNCw5Kk+2G7bOOJF1rw@mail.gmail.com>
 <CAJCQCtRm3=7fkBcTA4o4r10cLqC-bzcsKunb5k+uA-siyZmMnQ@mail.gmail.com>
 <20160628010618.58e235fa@system> <CAJCQCtRoPcYQyHmkXT6yBQ31YTXLWeC+097=x0SVp+FeQ8M04w@mail.gmail.com>
 <20160628024940.3b323b26@system> <CAJCQCtRSu0GwLRqgvzj9pv80gqoqb6vnjVMLwMmnWF-rvR0tcg@mail.gmail.com>
 <20160629005208.5e9addcf@system> <CAJCQCtQnNfpu6xoFy2W_hfikphhp_AbUDVmm4Lr2Rsncrx_EsA@mail.gmail.com>
 <20160629115055.29018e6a@system> <CAJCQCtS=kd31tOe_YCX96W1K85sH2_qTAsxggyyP5kWzZrauoQ@mail.gmail.com>
 <20160629201208.275b37ad@system> <16e65a07-03b6-2540-fc96-3538c5bc5c99@gmail.com>
 <20160629210217.0e4e4d1c@system>
From: Chris Murphy <lists@colorremedies.com>
Date: Wed, 29 Jun 2016 13:08:30 -0600
Message-ID: <CAJCQCtRyPyXA+4+D-J8940xiOMcEwQHgsk6uSpnPeLUduAJd2Q@mail.gmail.com>
Subject: Re: Kernel bug during RAID1 replace
To: Saint Germain <saintger@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 29, 2016 at 1:02 PM, Saint Germain <saintger@gmail.com> wrote:
>
> On Wed, 29 Jun 2016 14:19:23 -0400, "Austin S. Hemmelgarn"
> <ahferroin7@gmail.com> wrote :
>
>> >>> Already got a backup. I just really want to try to repair it (in
>> >>> order to test BTRFS).
>> >>
>> >> I don't know that this is a good test because I think the file
>> >> system has already been sufficient corrupted that it can't be
>> >> fixed. Part of the problem is that Btrfs isn't aware of faulty
>> >> drives like mdadm or lvm yet, so it looks like it'll try to write
>> >> to all devices and it's possible for significant confusion to
>> >> happen if they're each getting different generation writes.
>> >> Significant as in, currently beyond repair.
>> >>
>> >>>>> On the other hand it seems interesting to repair instead of just
>> >>>>> giving up. It gives a good look at BTRFS resiliency/reliability.
>> >>>>
>> >>>> On the one hand Btrfs shouldn't become inconsistent in the first
>> >>>> place, that's the design goal. On the other hand, I'm finding
>> >>>> from the problems reported on the list that Btrfs increasingly
>> >>>> mounts at least read only and allows getting data off, even when
>> >>>> the file system isn't fully functional or repairable.
>> >>>>
>> >>>> In your case, once there are metadata problems even with raid 1,
>> >>>> it's difficult at best. But once you have the backup you could
>> >>>> try some other things once it's certain the hardware isn't
>> >>>> adding to the problems, which I'm still not yet certain of.
>> >>>>
>> >>>
>> >>> I'm ready to try anything. Let's experiment.
>> >>
>> >> I kinda think it's a waste of time. Someone else maybe has a better
>> >> idea?
>> >>
>> >> I think your time is better spent finding out when and why the
>> >> device with all of these write errors happened. It must have gone
>> >> missing for a while, and you need to find out why that happened
>> >> and prevent it; OR you have to be really vigilent at every mount
>> >> time to make sure both devices have the same transid (generation).
>> >> In my case when I tried to sabotage this, being of by a generation
>> >> of 1 wasn't a problem for Btrfs to automatically fix up but I
>> >> suspect it was only a generation mismatch in the superblock.
>> >>
>> >
>> > Ok I will follow your advice and start over with a fresh BTRFS
>> > volume. As explained on another email, rsync doesn't support
>> > reflink, so do you think it is worth trying with BTRFS send
>> > instead ? Is it safe to copy this way or rsync is more reliable in
>> > case of faulty BTRFS volume ?
>> >
>> If you have the space, btrfs restore would probably be the best
>> option. It's not likely, but using send has a risk of contaminating
>> the new filesystem as well.
>>
>
> I have to copy through the network (I am running out of disks...) so
> btrfs restore is unfortunately not an option.
> I didn't know that btrfs send could contaminate the target disk as
> well ?
> Ok rsync it is then.

restore will let you extract files despite csum errors. I don't think
send will, and using cp or rsync Btrfs definitely won't hand over the
file.


-- 
Chris Murphy
