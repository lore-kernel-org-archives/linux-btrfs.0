Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f177.google.com ([209.85.217.177]:56392 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753231Ab3CJWHL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 10 Mar 2013 18:07:11 -0400
Received: by mail-lb0-f177.google.com with SMTP id go11so2603371lbb.8
        for <linux-btrfs@vger.kernel.org>; Sun, 10 Mar 2013 15:07:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <513D106C.4000806@gmail.com>
References: <1362861071-12589-1-git-send-email-hugo@carfax.org.uk>
 <201303101223.56805.Martin@lichtvoll.de> <20130310213606.GE30771@carfax.org.uk>
 <CAFWF=amgMRcBaoTXZiFSEQnJkmayf7SPXddktbGuvN0q3qd7UA@mail.gmail.com> <513D106C.4000806@gmail.com>
From: Harald Glatt <mail@hachre.de>
Date: Sun, 10 Mar 2013 23:06:48 +0100
Message-ID: <CAFWF=ann1_Q5qWn9f4nXyLSpxWrbc+7s=xY-6OeptXgCbQZzUQ@mail.gmail.com>
Subject: Re: [PATCH 0/5] [RFC] RAID-level terminology change
To: kreijack@inwind.it
Cc: Hugo Mills <hugo@carfax.org.uk>, Martin Steigerwald <Martin@lichtvoll.de>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I created a btrfs volume on a 4GB drive using the entire drive
(VirtualBox VM). Of this drive btrfs immediately used 400 MB. I then
filled it up with random data, left around 300 MB free and made a
md5sum of said data. Then I umounted the volume and wrote random data
into it the drive with dd at 1GB, 2GB and 3GB offsets. I increased the
amount of data written each time between my tests. Btrfs kept the
entire filesystem in tact (I did have to use btrfs-zero-log though)
and the checksum stayed correct the entire time. I wrote 120 MB of
corrupt data into the drive and that worked, on my next test writing
150 MB of corrupt data resulted in btrfs not being mountable anymore.
150 MB was around 5% of the 3.3 GB which was the size of my test file
how I got to the 5%. The output of btrfs when I couldn't mount anymore
said something about seeing a corruption larger than 145 MB which it
cannot recover from (heavily paraphrased) so I knew that my 150 MB
test was very close to the limit.

On Sun, Mar 10, 2013 at 11:59 PM, Goffredo Baroncelli
<kreijack@gmail.com> wrote:
> On 03/10/2013 10:45 PM, Harald Glatt wrote:
>
>> I've noticed through my own tests that on a single device I can
>> corrupt around 5% of the data completely before btrfs fails. Up to
>> that point both filesystem as well as data integrity stays at 100%.
>> However the default layout for one disk seems to be having the data
>> once, the metadata DUP and the system DUP too.
>
> How make you the corruption ? Does btrfs return wrong data ? How is
> calculated the 5% ?
>
>
>> Having these 5% isn't
>> mentioned anywhere... Is this a value that could maybe be manipulated
>> and could it be introduced into a naming scheme like this? Also where
>> do the 5% redundancy come from?
>
> On a single device, the metadata are DUPlicated but the data have only 1
> copy.
>
> This means that if you corrupt the 1 copy of the metadata, btrfs
> survives using the other copy. Instead if you corrupt the data btrfs
> return an error.
>
>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
>
> --
> gpg @keyserver.linux.it: Goffredo Baroncelli (kreijackATinwind.it>
> Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
