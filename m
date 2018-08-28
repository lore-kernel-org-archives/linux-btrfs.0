Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f52.google.com ([209.85.213.52]:35934 "EHLO
        mail-vk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725724AbeH1Eiq (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 28 Aug 2018 00:38:46 -0400
Received: by mail-vk0-f52.google.com with SMTP id v62-v6so448302vkd.3
        for <linux-btrfs@vger.kernel.org>; Mon, 27 Aug 2018 17:49:43 -0700 (PDT)
MIME-Version: 1.0
References: <CAN4oSBdfDVGmG8L2vS9h9McEs5aSuP5RfTGREB2ZhGwmAg4JhA@mail.gmail.com>
 <CAJCQCtSq5K90gpfGQN8JhqQddBg62m8EG_bFuWN5XyzdNStDfw@mail.gmail.com>
 <CAN4oSBeHwnsm5Ecz1hAQLk6s6utHfn5XeR8xMhnZpmT-sb-_iw@mail.gmail.com>
 <CAJCQCtQ=CiB5cY8RL4tzps21d=umjzNM=BKjdUBCc7WiP0QF9A@mail.gmail.com> <CAJCQCtSGV1gz66X9BJAJosuhMTvd2=Me-X2tVDwJ0Eg9PA7BPA@mail.gmail.com>
In-Reply-To: <CAJCQCtSGV1gz66X9BJAJosuhMTvd2=Me-X2tVDwJ0Eg9PA7BPA@mail.gmail.com>
From: Cerem Cem ASLAN <ceremcem@ceremcem.net>
Date: Tue, 28 Aug 2018 03:49:31 +0300
Message-ID: <CAN4oSBfAS75x7+D2Ms93NGB5H5MG-AOR5mHg2czGCECg6api3Q@mail.gmail.com>
Subject: Re: DRDY errors are not consistent with scrub results
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thanks for your guidance, I'll get the device replaced first thing in
the morning.

Here is balance results which I think resulted not too bad:

sudo btrfs balance start /mnt/peynir/
WARNING:

        Full balance without filters requested. This operation is very
        intense and takes potentially very long. It is recommended to
        use the balance filters to narrow down the balanced data.
        Use 'btrfs balance start --full-balance' option to skip this
        warning. The operation will start in 10 seconds.
        Use Ctrl-C to stop it.
10 9 8 7 6 5 4 3 2 1
Starting balance without any filters.
Done, had to relocate 18 out of 18 chunks

I suppose this means I've not lost any data, but I'm very prone to due
to previous `smartctl ...` results.

Chris Murphy <lists@colorremedies.com>, 28 Ağu 2018 Sal, 03:39
tarihinde şunu yazdı:
>
> On Mon, Aug 27, 2018 at 6:38 PM, Chris Murphy <lists@colorremedies.com> wrote:
>
> >> Metadata,single: Size:8.00MiB, Used:0.00B
> >>    /dev/mapper/master-root         8.00MiB
> >>
> >> Metadata,DUP: Size:2.00GiB, Used:562.08MiB
> >>    /dev/mapper/master-root         4.00GiB
> >>
> >> System,single: Size:4.00MiB, Used:0.00B
> >>    /dev/mapper/master-root         4.00MiB
> >>
> >> System,DUP: Size:32.00MiB, Used:16.00KiB
> >>    /dev/mapper/master-root        64.00MiB
> >>
> >> Unallocated:
> >>    /dev/mapper/master-root       915.24GiB
> >
> >
> > OK this looks like it maybe was created a while ago, it has these
> > empty single chunk items that was common a while back. There is a low
> > risk to clean it up, but I still advise backup first:
> >
> > 'btrfs balance start -mconvert=dup <mountpoint>'
>
> You can skip this advise now, it really doesn't matter. But future
> Btrfs shouldn't have both single and DUP chunks like this one is
> showing, if you're using relatively recent btrfs-progs to create the
> file system.
>
>
> --
> Chris Murphy
