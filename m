Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f182.google.com ([209.85.223.182]:54425 "EHLO
        mail-io0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752649AbdJTLxn (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 20 Oct 2017 07:53:43 -0400
Received: by mail-io0-f182.google.com with SMTP id e89so12936640ioi.11
        for <linux-btrfs@vger.kernel.org>; Fri, 20 Oct 2017 04:53:43 -0700 (PDT)
Received: from [191.9.206.254] (rrcs-70-62-41-24.central.biz.rr.com. [70.62.41.24])
        by smtp.gmail.com with ESMTPSA id h66sm436872itg.17.2017.10.20.04.53.41
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 20 Oct 2017 04:53:41 -0700 (PDT)
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
 <cc34039f-9e84-c280-c793-1e381cbb2001@gmail.com>
 <23016.34313.523398.532675@tree.ty.sabi.co.uk>
 <4d61bf1d-3c22-9b64-9710-0616fe4bb54a@gmail.com>
 <23016.61820.793653.502993@tree.ty.sabi.co.uk>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <89545c53-0aba-667e-f169-cbf994b122ab@gmail.com>
Date: Fri, 20 Oct 2017 07:53:41 -0400
MIME-Version: 1.0
In-Reply-To: <23016.61820.793653.502993@tree.ty.sabi.co.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-10-19 14:39, Peter Grandi wrote:
> [ ... ]
>>>> Oh please, please a bit less silliness would be welcome here.
>>>> In a previous comment on this tedious thread I had written:
> 
>>>>>> If the block device abstraction layer and lower layers work
>>>>>> correctly, Btrfs does not have problems of that sort when
>>>>>> adding new devices; conversely if the block device layer and
>>>>>> lower layers do not work correctly, no mainline Linux
>>>>>> filesystem I know can cope with that.
> 
>>>>>> Note: "work correctly" does not mean "work error-free".
> 
>>>> The last line is very important and I added it advisedly.
> [ ... ]
>>> Filesystems run on top of *block-devices* with a definite
>>> interface and a definite state machine, and filesystems in
>>> general assume that the block-device works *correctly*.
> 
>> They do run on top of USB or SATA devices, otherwise a
>> significant majority of systems running Linux and/or BSD
>> should not be operating right now.
> 
> That would be big news to any Linux/UNIX filesystem developer,
> who would have to rush to add SATA and USB protocol and state
> machine handling to their implementations, which currently only
> support the block-device protocol and state machine.
> Please send patches :-)
In casual conversation, the concept of something being on top of 
something else is usually a transitive property, higher layers are still 
built on top of lower layers, irrespective of what layers are in between 
them (though this does not preclude lower layers from being 
interchangeable).  Filesystems run on top of SATA or USB devices because 
they run on top of the block layer, which in turn runs on top of SATA 
and USB devices.  This is no different than how SSH runs on top of IP 
because it runs on TCP or SCTP, which in turn run on top of IP.
> 
>    Note to some readers: there are filesystems designed to work
>    on top not of block devices, like on top the MTD abstraction
>    layer, for example.
> 
>> Yes, they don't directly access them, but the block layer
>> isn't much more than command translation, scheduling, and
>> accounting, so this distinction is meaningless and largely
>> irrelevant.
> 
> More tedious silliness and grossly ignorant too, because the
> protocol and state machine of the block-device layer is
> completely different from that of both SATA and USB, and the
> mapping of the SATA or USB protocols and state machines onto the
> block-device ones is actually a very complex, difficult, and
> error prone task, involving mountains of very hairy code. In
> particular since the block-device protocol and state machine are
> rather simplistic, a lot is lost in translation.
> 
>    Note: the SATA handling firmware in disk device often involves
>    *dozens of thousands* of lines of code, and "all it does" is
>    "just" reading the device and passing the content over the IO
>    bus.
> 
> Filesystems are designed to that very simplistic protocol and
> state machine for good reasons, and sometimes they are designed
> to even just a subset; for example most filesystem designs
> assume that block-device writes never fail (that is, bad sector
> sparing is done by a lower layer), and only some handle
> gracefully block-device read failures.
Yes, and the block layer is still largely a protocol translator and 
scheduler.  There may be a great deal of _internal_ complexity 
(especially with SATA and USB, since they both get routed through the 
SCSI layer below the block layer), but that's not really all that 
relevant to the discussion since we can reasonably assume that it is 
functionally perfectly reliable (and it largely is).

At the point at which it's statistically impossible for a given layer to 
be the source of an error and that layer passes errors from lower layers 
up to higher ones (possibly with some translation) without handling them 
itself, then that layer becomes irrelevant for practical discussions of 
error handling, until you can prove that it was the source of the error 
being discussed.
> 
>> [ ... ] to refer to a block-device connected via interface 'X'
>> as an 'X device' or an 'X storage device'.
> 
> More tedious silliness as this is a grossly misleading shorthand
> when the point of the discussion is the error recovery protocol
> and state machine assumed by filesystem designers. To me it see
> that if people use that shorthand in that context, as if it was
> not a shorthand, they don't know what they are talking about, or
> they are trying to mislead the discussion.
You mean like your whole tirade about my terminology being fundamentally 
wrong?  Everyone else in the thread appears to have understood what I 
meant perfectly, except you.
>  >> [ ... ] For an end user, it generally doesn't matter whether a
>> given layer reported the error or passed it on (or generated
>> it), it matters whether it was corrected or not. [ ... ]
> 
> You seem unable or unwilling to appreciate how detected and
> undetected errors are fundamentally different, and how layering
> of greatly different protocols is a complicated issue highly
> relevant to error recovery, so you seem to assume that other end
> users are likewise unable or unwilling.
No, I'm saying that a majority of end users generally are unwilling to 
even care about how it works, let alone take the time to learn about it. 
  Most end users are not technically savvy, and don't really care how 
something works, as long as it works.  A few days working tech support 
makes this fact painfully obvious.  There are exceptions, but even in 
the IT industry, most people don't care about how it works below the 
level of userspace, provided it works and presents the required 
functionality.  Even when they do want some explanation of why to do 
something some specific way, it usually suffices to say something 
simple, instead of having to explain how everything works.

One of the best recent examples of this is explaining the need for an 
update on Linux and Android systems in light of the KRACK attack on 
WPA/WPA2.  Among the hundred plus people I've explained this to, only 
about half a dozen other than me have wanted explanation beyond 'without 
the update, it effectively provides no security', and of those, I'm the 
only one who cares beyond the fact that a successful attack will cause a 
key with an exactly known value to be used (and the only reason I care 
is so I can audit that the patches for wpa_supplicant and hostapd are 
correct prior to updating my systems).
> 
> But I am not so dismissive of "end users", and I assume that
> there are end users that can eventually understand that Btrfs in
> the main is not designed to handle devices that "lie" because
> Btrfs actually is designed to use the block-device layer which
> is assumed to "work correctly" (except for checksums).
No filesystem is designed to handle devices that lie, because there's no 
sane way to handle them.  That's a fundamental property of a working 
storage system that happens to be pretty easy to explain once they 
understand that undetected errors are possible.  It absolutely doesn't 
require going into some complicated explanation of how the block layer 
works (or that it even exists for that matter).
