Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f169.google.com ([209.85.192.169]:54510 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751714Ab3FBIFr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 2 Jun 2013 04:05:47 -0400
Received: by mail-pd0-f169.google.com with SMTP id y11so4272346pdj.28
        for <linux-btrfs@vger.kernel.org>; Sun, 02 Jun 2013 01:05:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20130601212337.GF20133@carfax.org.uk>
References: <CAN05THTWG_jYHti7aUcz_WH97OvoVfCoz7Wuc8Hh2katqm2JmQ@mail.gmail.com>
	<20130601212337.GF20133@carfax.org.uk>
Date: Sun, 2 Jun 2013 10:05:46 +0200
Message-ID: <CAFTPBcLx=scSVFh-qYP0=fH6H1dMvw6ChGSMLtRJDBw8Z=Y8aw@mail.gmail.com>
Subject: Re: RADI6 questions
From: Felix Blanke <felixblanke@gmail.com>
To: ronnie sahlberg <ronniesahlberg@gmail.com>, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

fyi: Raid5/6 hit mainline in 3.9, with 3.8 you will not be able to use
those raid levels.

Regards,
Felix

On Sat, Jun 1, 2013 at 11:23 PM, Hugo Mills <hugo@carfax.org.uk> wrote:
> On Sat, Jun 01, 2013 at 02:07:53PM -0700, ronnie sahlberg wrote:
>> Hi List,
>>
>> I have a filesystem that is spanning about 10 devices.
>> It is currently using RAID1 for both data and metadata.
>>
>> In order to get higher availability and be able to handle multi device failures
>> I would like to change from RAID1 to RAID6.
>>
>>
>> Is it possible/stable/supported/recommended to change data from RAID1 to RAID6 ?
>> (I assume "btrfs fi balance ..."  is used for this?)
>
>    Yes.
>
>> Metadata is currently RAID1, is it supported to put metadata as RAID6 too?
>> It would be "odd" to have lesser protection for metadata than data.
>> Optimally I would like a mode where metadata is mirrored onto all the
>> spindles in the filesystem, not just 2 in RAID1 or n in RAID6.
>
>    Yes, that should be supported.
>
>> Im running a 3.8.0 kernel.
>
>    The btrfs RAID-5 and RAID-6 implementations aren't really ready for
> production use, so right now I wouldn't recommend using them for
> anything other than for testing purposes with data that's replacable.
>
>    Hugo.
>
> --
> === Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
>   PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
>               --- w.w.w.  : England's batting scorecard ---
