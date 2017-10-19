Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from azure.uno.uk.net ([95.172.254.11]:33588 "EHLO azure.uno.uk.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751611AbdJSSkY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 19 Oct 2017 14:40:24 -0400
Received: from ty.sabi.co.uk ([95.172.230.208]:53212)
        by azure.uno.uk.net with esmtpsa (TLSv1.2:DHE-RSA-AES128-SHA:128)
        (Exim 4.89)
        (envelope-from <postmaster@root.t00.sabi.co.uk>)
        id 1e5Fjy-0000DM-HF
        for linux-btrfs@vger.kernel.org; Thu, 19 Oct 2017 19:40:22 +0100
Received: from from [127.0.0.1] (helo=tree.ty.sabi.co.uk)
        by ty.sabi.co.UK with esmtps(Cipher TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128)(Exim 4.82 3)
        id 1e5Fjb-0003BZ-5v
        for <linux-btrfs@vger.kernel.org>; Thu, 19 Oct 2017 19:39:59 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <23016.61820.793653.502993@tree.ty.sabi.co.uk>
Date: Thu, 19 Oct 2017 19:39:56 +0100
To: Linux fs Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Is it safe to use btrfs on top of different types of devices?
In-Reply-To: <4d61bf1d-3c22-9b64-9710-0616fe4bb54a@gmail.com>
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
From: pg@btrfs.list.sabi.co.UK (Peter Grandi)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

[ ... ]
>>> Oh please, please a bit less silliness would be welcome here.
>>> In a previous comment on this tedious thread I had written:

>>>>> If the block device abstraction layer and lower layers work
>>>>> correctly, Btrfs does not have problems of that sort when
>>>>> adding new devices; conversely if the block device layer and
>>>>> lower layers do not work correctly, no mainline Linux
>>>>> filesystem I know can cope with that.

>>>>> Note: "work correctly" does not mean "work error-free".

>>> The last line is very important and I added it advisedly.
[ ... ]
>> Filesystems run on top of *block-devices* with a definite
>> interface and a definite state machine, and filesystems in
>> general assume that the block-device works *correctly*.

> They do run on top of USB or SATA devices, otherwise a
> significant majority of systems running Linux and/or BSD
> should not be operating right now.

That would be big news to any Linux/UNIX filesystem developer,
who would have to rush to add SATA and USB protocol and state
machine handling to their implementations, which currently only
support the block-device protocol and state machine.
Please send patches :-)

  Note to some readers: there are filesystems designed to work
  on top not of block devices, like on top the MTD abstraction
  layer, for example.

> Yes, they don't directly access them, but the block layer
> isn't much more than command translation, scheduling, and
> accounting, so this distinction is meaningless and largely
> irrelevant.

More tedious silliness and grossly ignorant too, because the
protocol and state machine of the block-device layer is
completely different from that of both SATA and USB, and the
mapping of the SATA or USB protocols and state machines onto the
block-device ones is actually a very complex, difficult, and
error prone task, involving mountains of very hairy code. In
particular since the block-device protocol and state machine are
rather simplistic, a lot is lost in translation.

  Note: the SATA handling firmware in disk device often involves
  *dozens of thousands* of lines of code, and "all it does" is
  "just" reading the device and passing the content over the IO
  bus.

Filesystems are designed to that very simplistic protocol and
state machine for good reasons, and sometimes they are designed
to even just a subset; for example most filesystem designs
assume that block-device writes never fail (that is, bad sector
sparing is done by a lower layer), and only some handle
gracefully block-device read failures.

> [ ... ] to refer to a block-device connected via interface 'X'
> as an 'X device' or an 'X storage device'.

More tedious silliness as this is a grossly misleading shorthand
when the point of the discussion is the error recovery protocol
and state machine assumed by filesystem designers. To me it see
that if people use that shorthand in that context, as if it was
not a shorthand, they don't know what they are talking about, or
they are trying to mislead the discussion.

> [ ... ] For an end user, it generally doesn't matter whether a
> given layer reported the error or passed it on (or generated
> it), it matters whether it was corrected or not. [ ... ]

You seem unable or unwilling to appreciate how detected and
undetected errors are fundamentally different, and how layering
of greatly different protocols is a complicated issue highly
relevant to error recovery, so you seem to assume that other end
users are likewise unable or unwilling.

But I am not so dismissive of "end users", and I assume that
there are end users that can eventually understand that Btrfs in
the main is not designed to handle devices that "lie" because
Btrfs actually is designed to use the block-device layer which
is assumed to "work correctly" (except for checksums).
