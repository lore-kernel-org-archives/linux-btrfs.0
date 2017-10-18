Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f49.google.com ([209.85.214.49]:49268 "EHLO
        mail-it0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751783AbdJROac (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 18 Oct 2017 10:30:32 -0400
Received: by mail-it0-f49.google.com with SMTP id y15so6460330ita.4
        for <linux-btrfs@vger.kernel.org>; Wed, 18 Oct 2017 07:30:32 -0700 (PDT)
Received: from [191.9.206.254] (rrcs-70-62-41-24.central.biz.rr.com. [70.62.41.24])
        by smtp.gmail.com with ESMTPSA id y136sm5904844iof.56.2017.10.18.07.30.29
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 18 Oct 2017 07:30:30 -0700 (PDT)
Subject: Re: Is it safe to use btrfs on top of different types of devices?
To: Linux fs Btrfs <linux-btrfs@vger.kernel.org>
References: <CAGtRCvfkDnUBxqWNgEOXz+Gam0dPubatROQgqxE2D_uCAZhihQ@mail.gmail.com>
 <CAGtRCvfqUP_79cKC_Rzs6MD_uZiVbjt9QW0_BeOpACN_c3ev5w@mail.gmail.com>
 <d27ec863-d4fb-3ffd-78a4-c12789054bd9@gmail.com>
 <CAA-GF5vs_Mw9bW20ykXAr7Fr4DK_1bDM6qk0k54-oi5g-veK2g@mail.gmail.com>
 <d15a82aa-7d6e-ba36-76cc-8771e0359379@gmail.com>
 <20171017011443.bupcsskm7joc73wb@angband.pl>
 <e8497dd4-7341-a708-7828-282001738a95@gmail.com>
 <CAA-GF5sO78HjdWHRZKfENRwgGPF91Vz-Odm7PphiiEMVEENykg@mail.gmail.com>
 <23015.23766.971947.937708@tree.ty.sabi.co.uk>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <cc34039f-9e84-c280-c793-1e381cbb2001@gmail.com>
Date: Wed, 18 Oct 2017 10:30:25 -0400
MIME-Version: 1.0
In-Reply-To: <23015.23766.971947.937708@tree.ty.sabi.co.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-10-18 09:53, Peter Grandi wrote:
>>> I forget sometimes that people insist on storing large
>>> volumes of data on unreliable storage...
> 
> Here obviously "unreliable" is used on the sense of storage that
> can work incorrectly, not in the sense of storage that can fail.
Um, in what world is a device randomly dropping off the bus (this is the 
primary issue with USB for storage) not a failure?  Yes, it's not a 
catastrophic failure (for BTRFS at least), and it's transient (the 
kernel will re-enumerate the device when it resets the bus), but that 
doesn't change the fact that the service that is supposed to be provided 
by the device failed.

To clarify more concretely, when I say 'unreliable' in reference to 
computers technology (and for that matter, almost anything else), I mean 
something that encounters non-trivial error states, either correctable 
or uncorrectable, at a frequency above that which is deemed reasonable 
for the designed function of the device.
> 
>> In my opinion the unreliability of the storage is the exact
>> reason for wanting to use raid1. And I think any problem one
>> encounters with an unreliable disk can likely happen with more
>> reliable ones as well, only less frequently, so if I don't
>> feel comfortable using raid1 on an unreliable medium then I
>> wouldn't trust it on a more reliable one either.
> 
> Oh please, please a bit less silliness would be welcome here.
> In a previous comment on this tedious thread I had written:
> 
>    > If the block device abstraction layer and lower layers work
>    > correctly, Btrfs does not have problems of that sort when
>    > adding new devices; conversely if the block device layer and
>    > lower layers do not work correctly, no mainline Linux
>    > filesystem I know can cope with that.
> 
>    > Note: "work correctly" does not mean "work error-free".
> 
> The last line is very important and I added it advisedly.
> 
> You seem to be using "unreliable" in two completely different
> meanings, without realizing it, as both "working incorrectly"
> and "reporting a failure". They are really very different.
And you seem to be using the term 'failure' to only mean 'catastrophic 
failure'.  Strictly speaking, even that is 'working incorrectly', albeit 
in a much more specific and permanent manner than just returning errors.

Even looking at things that way though, Zoltan's assessment that 
reliability is essentially a measure of error rate is correct.  Internal 
SATA devices absolutely can randomly drop off the bus just like many USB 
storage devices do, but it almost never happens (it's a statistical 
impossibility if there are no hardware or firmware issues), so they are 
more reliable in that respect.
> 
> The "working incorrectly" general case is the so called
> "bizantine generals problem" and (depending on assumptions) it
> is insoluble.
> 
> Btrfs has some limited ability to detect (and sometimes recover
> from) "working incorrectly" storage layers, but don't expect too
> much from that.
