Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f48.google.com ([74.125.82.48]:35588 "EHLO
	mail-wm0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750859AbcGGMYu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 7 Jul 2016 08:24:50 -0400
Received: by mail-wm0-f48.google.com with SMTP id z126so146470169wme.0
        for <linux-btrfs@vger.kernel.org>; Thu, 07 Jul 2016 05:24:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtT82qFxsehXAmSwerPmV1KnVM5LBS=WA1iE8SiVbUtFRg@mail.gmail.com>
References: <CAFDLS-CtnVDtD8d=Wtp0tVokKJ6pjptpX7MR862dThBJvSPC5g@mail.gmail.com>
 <CAFDLS-AA6nYJy6BBRPhqAL-7PpA-TTEUqpjLR2+cZ05A+5kx7A@mail.gmail.com> <CAJCQCtT82qFxsehXAmSwerPmV1KnVM5LBS=WA1iE8SiVbUtFRg@mail.gmail.com>
From: Gonzalo Gomez-Arrue Azpiazu <ggomarr@gmail.com>
Date: Thu, 7 Jul 2016 15:24:29 +0300
Message-ID: <CAFDLS-A+ZK8D_66euCN7_BJWihdmUHOkjQnPC50oFL1vGyz=MQ@mail.gmail.com>
Subject: Re: Unable to mount degraded RAID5
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thanks a lot, your will to help out someone you do not know (and who
is obviously way over his depth) is inspiring.

This is what it says:

btrfs rescue super-recover -v /dev/sdc1
All Devices:
Device: id = 3, name = /dev/sdd1
Device: id = 1, name = /dev/sdc1

Before Recovering:
[All good supers]:
device name = /dev/sdd1
superblock bytenr = 65536

device name = /dev/sdd1
superblock bytenr = 67108864

device name = /dev/sdd1
superblock bytenr = 274877906944

device name = /dev/sdc1
superblock bytenr = 65536

device name = /dev/sdc1
superblock bytenr = 67108864

device name = /dev/sdc1
superblock bytenr = 274877906944

[All bad supers]:

All supers are valid, no need to recover

Any suggestion on what to do next?

(again, really appreciated - I hope to be able to give back the
support I am receiving at some point!)

On Wed, Jul 6, 2016 at 9:19 PM, Chris Murphy <lists@colorremedies.com> wrote:
> On Wed, Jul 6, 2016 at 11:12 AM, Gonzalo Gomez-Arrue Azpiazu
> <ggomarr@gmail.com> wrote:
>> Hello,
>>
>> I had a RAID5 with 3 disks and one failed; now the filesystem cannot be mounted.
>>
>> None of the recommendations that I found seem to work. The situation
>> seems to be similar to this one:
>> http://www.spinics.net/lists/linux-btrfs/msg56825.html
>>
>> Any suggestion on what to try next?
>
> Basically if you are degraded *and* it runs into additional errors,
> then it's broken because raid5 only protects against one device error.
> The main problem is if it can't read the chunk root it's hard for any
> tool to recover data because the chunk tree mapping is vital to
> finding data.
>
> What do you get for:
> btrfs rescue super-recover -v /dev/sdc1
>
> It's a problem with the chunk tree because all of your super blocks
> point to the same chunk tree root so there isn't another one to try.
>
>>sudo btrfs-find-root /dev/sdc1
>>warning, device 2 is missing
>>Couldn't read chunk root
>>Open ctree failed
>
> It's bad news. I'm not even sure 'btrfs restore' can help this case.
>
>
> --
> Chris Murphy
