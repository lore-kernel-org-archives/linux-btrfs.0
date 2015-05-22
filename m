Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f49.google.com ([74.125.82.49]:36559 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161013AbbEVWxd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 May 2015 18:53:33 -0400
Received: by wgbgq6 with SMTP id gq6so29754757wgb.3
        for <linux-btrfs@vger.kernel.org>; Fri, 22 May 2015 15:53:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20150522222216.GH25778@carfax.org.uk>
References: <CAOQP4cGzX6knmXjaYcO=JB=VycidG7LS0GWA+N2x+f680ATGnA@mail.gmail.com>
	<20150522222216.GH25778@carfax.org.uk>
Date: Sat, 23 May 2015 00:53:32 +0200
Message-ID: <CAOQP4cGDRQ9nndO9TtAUXq-QRv3n7vkkzykbG0QbooQmekdasg@mail.gmail.com>
Subject: Re: Removing a device from a metadata raid1 - data raid0
From: Arnaud Kapp <kapp.arno@gmail.com>
To: Arnaud Kapp <kapp.arno@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

Yes the conversion from raid0 to single went fine.

>   For the metadata, one approach is to convert to single, delete the
> device, then convert to DUP. That at least will work, if be a little
> risky.

This worked great, thank you !


On Sat, May 23, 2015 at 12:22 AM, Hugo Mills <hugo@carfax.org.uk> wrote:
> On Sat, May 23, 2015 at 12:15:13AM +0200, Arnaud Kapp wrote:
>> Hello,
>>
>> I've setup a filesystem with 2 devices. The metadata are in raid1.
>> Data is in raid0.
>>
>> I wish to remove one of this device from the filesystem (to use for an
>> unrelated purpose) but I am not able to do so.
>> It *seems* that attempting to balance metadata to dup is not allowed
>> (btrfs -mconvert=dup) because they currently are raid1.
>> The metadata in raid1 prevents me from removing the device because the
>> filesystem can't go below one device in raid1.
>>
>> Could someone please advise me about my options here?
>
>    The RAID-0 data is also going to be a problem here. You'll have to
> convert that to single, because RAID-0 requires a minimum of two
> devices.
>
>    For the metadata, one approach is to convert to single, delete the
> device, then convert to DUP. That at least will work, if be a little
> risky.
>
>    IMO, we should definitely support conversion to DUP, and prevent
> the automatic "upgrade" to RAID-1, but I think we don't at the moment.
>
>    Hugo.
>
> --
> Hugo Mills             | Two things came out of Berkeley in the 1960s: LSD
> hugo@... carfax.org.uk | and Unix. This is not a coincidence.
> http://carfax.org.uk/  |
> PGP: E2AB1DE4          |



-- 
Kapp Arnaud - Xaqq
