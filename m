Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f171.google.com ([209.85.214.171]:36088 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751450AbcF3ATy (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 29 Jun 2016 20:19:54 -0400
Received: by mail-ob0-f171.google.com with SMTP id mu6so49308624obc.3
        for <linux-btrfs@vger.kernel.org>; Wed, 29 Jun 2016 17:19:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160629211613.125ce3f0@system>
References: <20160627233612.662d2a9a@system> <CAJCQCtT_vbOzbvMOuV6wgvz4iMHcpQmAhX-y1-dkOi6F323KRg@mail.gmail.com>
 <20160628002602.022258bf@system> <CAJCQCtR3FQ-Pe40dOcKGgd+8paraHuCoNCw5Kk+2G7bOOJF1rw@mail.gmail.com>
 <CAJCQCtRm3=7fkBcTA4o4r10cLqC-bzcsKunb5k+uA-siyZmMnQ@mail.gmail.com>
 <20160628010618.58e235fa@system> <CAJCQCtRoPcYQyHmkXT6yBQ31YTXLWeC+097=x0SVp+FeQ8M04w@mail.gmail.com>
 <20160628024940.3b323b26@system> <CAJCQCtRSu0GwLRqgvzj9pv80gqoqb6vnjVMLwMmnWF-rvR0tcg@mail.gmail.com>
 <20160629005208.5e9addcf@system> <CAJCQCtQnNfpu6xoFy2W_hfikphhp_AbUDVmm4Lr2Rsncrx_EsA@mail.gmail.com>
 <20160629115055.29018e6a@system> <CAJCQCtS=kd31tOe_YCX96W1K85sH2_qTAsxggyyP5kWzZrauoQ@mail.gmail.com>
 <20160629201208.275b37ad@system> <16e65a07-03b6-2540-fc96-3538c5bc5c99@gmail.com>
 <20160629210217.0e4e4d1c@system> <CAJCQCtRyPyXA+4+D-J8940xiOMcEwQHgsk6uSpnPeLUduAJd2Q@mail.gmail.com>
 <20160629211613.125ce3f0@system>
From: Chris Murphy <lists@colorremedies.com>
Date: Wed, 29 Jun 2016 18:19:52 -0600
Message-ID: <CAJCQCtT0GG_FqUoDBKRCQK+O1nryTjaHoJc4LswHZHewQ++fKA@mail.gmail.com>
Subject: Re: Kernel bug during RAID1 replace
To: Saint Germain <saintger@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 29, 2016 at 1:16 PM, Saint Germain <saintger@gmail.com> wrote:
> On Wed, 29 Jun 2016 13:08:30 -0600, Chris Murphy
> <lists@colorremedies.com> wrote :
>
>> >> > Ok I will follow your advice and start over with a fresh BTRFS
>> >> > volume. As explained on another email, rsync doesn't support
>> >> > reflink, so do you think it is worth trying with BTRFS send
>> >> > instead ? Is it safe to copy this way or rsync is more reliable
>> >> > in case of faulty BTRFS volume ?
>> >> >
>> >> If you have the space, btrfs restore would probably be the best
>> >> option. It's not likely, but using send has a risk of contaminating
>> >> the new filesystem as well.
>> >>
>> >
>> > I have to copy through the network (I am running out of disks...) so
>> > btrfs restore is unfortunately not an option.
>> > I didn't know that btrfs send could contaminate the target disk as
>> > well ?
>> > Ok rsync it is then.
>>
>> restore will let you extract files despite csum errors. I don't think
>> send will, and using cp or rsync Btrfs definitely won't hand over the
>> file.
>>
>
> That's Ok I'd prefer to avoid copying files with csum errors anyway (I
> can restore them from backups).
> However will btrfs send abort the whole operation as soon as it finds a
> csum error ?

By default yes, but it's the receive side that aborts. So you use
--max-errors 0 to let it tolerate unlimited errors, and use -v for
both send and receive to track what errors there are.

> And will I have the risk to "contaminate" the target BTRFS volume by
> using BTRFS send ?

No.

-- 
Chris Murphy
