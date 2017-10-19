Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f41.google.com ([209.85.214.41]:44258 "EHLO
        mail-it0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751063AbdJSMcM (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 19 Oct 2017 08:32:12 -0400
Received: by mail-it0-f41.google.com with SMTP id n195so10410352itg.1
        for <linux-btrfs@vger.kernel.org>; Thu, 19 Oct 2017 05:32:12 -0700 (PDT)
Received: from [191.9.206.254] (rrcs-70-62-41-24.central.biz.rr.com. [70.62.41.24])
        by smtp.gmail.com with ESMTPSA id t65sm6847412iod.45.2017.10.19.05.32.10
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 19 Oct 2017 05:32:10 -0700 (PDT)
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
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <4d61bf1d-3c22-9b64-9710-0616fe4bb54a@gmail.com>
Date: Thu, 19 Oct 2017 08:32:09 -0400
MIME-Version: 1.0
In-Reply-To: <23016.34313.523398.532675@tree.ty.sabi.co.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-10-19 07:01, Peter Grandi wrote:
> [ ... ]
> 
>>> Oh please, please a bit less silliness would be welcome here.
>>> In a previous comment on this tedious thread I had written:
> 
>>>> If the block device abstraction layer and lower layers work
>>>> correctly, Btrfs does not have problems of that sort when
>>>> adding new devices; conversely if the block device layer and
>>>> lower layers do not work correctly, no mainline Linux
>>>> filesystem I know can cope with that.
>>>
>>>> Note: "work correctly" does not mean "work error-free".
>>>
>>> The last line is very important and I added it advisedly.
> 
>> Even looking at things that way though, Zoltan's assessment
>> that reliability is essentially a measure of error rate is
>> correct.
> 
> It is instead based on a grave confusion between two very
> different kinds of "error rate", confusion also partially based
> on the ridiculous misunderstanding, which I have already pointed
> out, that UNIX filesystems run on top of SATA or USB devices:
> 
>> Internal SATA devices absolutely can randomly drop off the bus
>> just like many USB storage devices do,
> 
> Filesystems run on top of *block devices* with a definite
> interface and a definite state machine, and filesystems in
> general assume that the block device works *correctly*.
They do run on top of USB or SATA devices, otherwise a significant 
majority of systems running Linux and/or BSD should not be operating 
right now.  Yes, they don't directly access them, but the block layer 
isn't much more than command translation, scheduling, and accounting, so 
this distinction is meaningless and largely irrelevant.  It's also 
pretty standard practice among most sane sysadmins who aren't trying to 
be jerks, as well as most kernel developers I've met, is to refer to a 
block device connected via interface 'X' as an 'X device' or an 'X 
storage device'.
> 
>> but it almost never happens (it's a statistical impossibility
>> if there are no hardware or firmware issues), so they are more
>> reliable in that respect.
> 
> What the OP was doing was using "unreliable" both for the case
> where the device "lies" and the case where the device does not
> "lie" but reports a failure. Both of these are malfunctions in a
> wide sense:
> 
>    * The [block] device "lies" as to its status or what it has done.
>    * The [block] device reports truthfully that an action has failed.
> 
> But they are of very different nature and need completely
> different handling. Hint: one is an extensional property and the
> other is a modal one, there is a huge difference between "this
> data is wrong" and "I know that this data is wrong".
> 
> The really important "detail" is that filesystems are, as a rule
> with very few exceptions, designed to work only if the block
> device layer (and those below it) does not "lie" (see "Bizantyne
> failures" below), that is "works correctly": reports the failure
> of every operation that fails and the success of every operation
> that succeeds and never gets into an unexpected state.
> 
> In particular filesystems designs are nearly always based on the
> assumption that there are no undetected errors at the block
> device level or below. Then the expected *frequency* of detected
> errors influences how much redundancy and what kind of recovery
> are desirable, but the frequency of "lies" is assumed to be
> zero.
> 
> The one case where Btrfs does not assume that the storage layer
> works *correctly* is checksumming: it is quite expensive and
> makes sense only if the block device is expected to (sometimes)
> "lie" about having written the data correctly or having read it
> correctly. The role of the checksum is to spot when a block
> device "lies" and turn an undetected read error into a detected
> one (they could be used also to detect correct writes that are
> misreported as having failed).
> 
> The crucial difference that exists between SATA and USB is not
> that USB chips have higher rates of detected failures (even if
> they often do), but that in my experience SATA interfaces from
> reputable suppliers don't "lie" (more realistically have
> negligible "lie" rates), and USB interfaces (both host bus
> adapters and IO bus bridges) "lie" both systematically and
> statistically with non negligible rates, and anyhow the USB mass
> storage protocol is not very good at error reporting and
> handling.
You do realize you just said exactly what I was saying, just in a more 
general and much more verbose manner which involved explaining things 
that are either well known and documented or aren't even entirely 
relevant to the thread in question?

For an end user, it generally doesn't matter whether a given layer 
reported the error or passed it on (or generated it), it matters whether 
it was corrected or not.  If the subset of the storage stack below 
whatever layer is being discussed (in this case the filesystem) causes 
errors at a rate deemed unacceptable for the given application that it 
does not correct, it's unreliable, regardless of whether or not they get 
corrected at this layer or a higher layer.  Even if you're running BTRFS 
on top of it, a SATA connected hard drive that returns bogus data on 1% 
of reads is from a user perspective just as unreliable as one that 
returns read errors 1% of the time, even though BTRFS can handle both 
(provided the user configures it correctly).
