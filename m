Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lj1-f178.google.com ([209.85.208.178]:38368 "EHLO
        mail-lj1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725767AbeH1E5h (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 28 Aug 2018 00:57:37 -0400
Received: by mail-lj1-f178.google.com with SMTP id p6-v6so700428ljc.5
        for <linux-btrfs@vger.kernel.org>; Mon, 27 Aug 2018 18:08:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAN4oSBfAS75x7+D2Ms93NGB5H5MG-AOR5mHg2czGCECg6api3Q@mail.gmail.com>
References: <CAN4oSBdfDVGmG8L2vS9h9McEs5aSuP5RfTGREB2ZhGwmAg4JhA@mail.gmail.com>
 <CAJCQCtSq5K90gpfGQN8JhqQddBg62m8EG_bFuWN5XyzdNStDfw@mail.gmail.com>
 <CAN4oSBeHwnsm5Ecz1hAQLk6s6utHfn5XeR8xMhnZpmT-sb-_iw@mail.gmail.com>
 <CAJCQCtQ=CiB5cY8RL4tzps21d=umjzNM=BKjdUBCc7WiP0QF9A@mail.gmail.com>
 <CAJCQCtSGV1gz66X9BJAJosuhMTvd2=Me-X2tVDwJ0Eg9PA7BPA@mail.gmail.com> <CAN4oSBfAS75x7+D2Ms93NGB5H5MG-AOR5mHg2czGCECg6api3Q@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Mon, 27 Aug 2018 19:08:28 -0600
Message-ID: <CAJCQCtT3PrcFwFq3oAyPyQTNBRdSjevFEE7V5_AoKD6hEDgvyA@mail.gmail.com>
Subject: Re: DRDY errors are not consistent with scrub results
To: Cerem Cem ASLAN <ceremcem@ceremcem.net>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Aug 27, 2018 at 6:49 PM, Cerem Cem ASLAN <ceremcem@ceremcem.net> wrote:
> Thanks for your guidance, I'll get the device replaced first thing in
> the morning.
>
> Here is balance results which I think resulted not too bad:
>
> sudo btrfs balance start /mnt/peynir/
> WARNING:
>
>         Full balance without filters requested. This operation is very
>         intense and takes potentially very long. It is recommended to
>         use the balance filters to narrow down the balanced data.
>         Use 'btrfs balance start --full-balance' option to skip this
>         warning. The operation will start in 10 seconds.
>         Use Ctrl-C to stop it.
> 10 9 8 7 6 5 4 3 2 1
> Starting balance without any filters.
> Done, had to relocate 18 out of 18 chunks
>
> I suppose this means I've not lost any data, but I'm very prone to due
> to previous `smartctl ...` results.


OK so nothing fatal anyway. We'd have to see any kernel messages that
appeared during the balance to see if there were read or write errors,
but presumably any failure means the balance fails so... might get you
by for a while actually.







-- 
Chris Murphy
