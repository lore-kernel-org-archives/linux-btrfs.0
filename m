Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from azure.uno.uk.net ([95.172.254.11]:56310 "EHLO azure.uno.uk.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752194AbdJSLBm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 19 Oct 2017 07:01:42 -0400
Received: from ty.sabi.co.uk ([95.172.230.208]:47162)
        by azure.uno.uk.net with esmtpsa (TLSv1.2:DHE-RSA-AES128-SHA:128)
        (Exim 4.89)
        (envelope-from <postmaster@root.t00.sabi.co.uk>)
        id 1e58a4-0008P2-LX
        for linux-btrfs@vger.kernel.org; Thu, 19 Oct 2017 12:01:40 +0100
Received: from from [127.0.0.1] (helo=tree.ty.sabi.co.uk)
        by ty.sabi.co.UK with esmtps(Cipher TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128)(Exim 4.82 3)
        id 1e58Zu-0001dt-9J
        for <linux-btrfs@vger.kernel.org>; Thu, 19 Oct 2017 12:01:30 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <23016.34313.523398.532675@tree.ty.sabi.co.uk>
Date: Thu, 19 Oct 2017 12:01:29 +0100
To: Linux fs Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Is it safe to use btrfs on top of different types of devices?
In-Reply-To: <cc34039f-9e84-c280-c793-1e381cbb2001@gmail.com>
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
From: pg@btrfs.list.sabi.co.UK (Peter Grandi)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

[ ... ]

>> Oh please, please a bit less silliness would be welcome here.
>> In a previous comment on this tedious thread I had written:

>> > If the block device abstraction layer and lower layers work
>> > correctly, Btrfs does not have problems of that sort when
>> > adding new devices; conversely if the block device layer and
>> > lower layers do not work correctly, no mainline Linux
>> > filesystem I know can cope with that.
>> 
>> > Note: "work correctly" does not mean "work error-free".
>> 
>> The last line is very important and I added it advisedly.

> Even looking at things that way though, Zoltan's assessment
> that reliability is essentially a measure of error rate is
> correct.

It is instead based on a grave confusion between two very
different kinds of "error rate", confusion also partially based
on the ridiculous misunderstanding, which I have already pointed
out, that UNIX filesystems run on top of SATA or USB devices:

> Internal SATA devices absolutely can randomly drop off the bus
> just like many USB storage devices do,

Filesystems run on top of *block devices* with a definite
interface and a definite state machine, and filesystems in
general assume that the block device works *correctly*.

> but it almost never happens (it's a statistical impossibility
> if there are no hardware or firmware issues), so they are more
> reliable in that respect.

What the OP was doing was using "unreliable" both for the case
where the device "lies" and the case where the device does not
"lie" but reports a failure. Both of these are malfunctions in a
wide sense:

  * The [block] device "lies" as to its status or what it has done.
  * The [block] device reports truthfully that an action has failed.

But they are of very different nature and need completely
different handling. Hint: one is an extensional property and the
other is a modal one, there is a huge difference between "this
data is wrong" and "I know that this data is wrong".

The really important "detail" is that filesystems are, as a rule
with very few exceptions, designed to work only if the block
device layer (and those below it) does not "lie" (see "Bizantyne
failures" below), that is "works correctly": reports the failure
of every operation that fails and the success of every operation
that succeeds and never gets into an unexpected state.

In particular filesystems designs are nearly always based on the
assumption that there are no undetected errors at the block
device level or below. Then the expected *frequency* of detected
errors influences how much redundancy and what kind of recovery
are desirable, but the frequency of "lies" is assumed to be
zero.

The one case where Btrfs does not assume that the storage layer
works *correctly* is checksumming: it is quite expensive and
makes sense only if the block device is expected to (sometimes)
"lie" about having written the data correctly or having read it
correctly. The role of the checksum is to spot when a block
device "lies" and turn an undetected read error into a detected
one (they could be used also to detect correct writes that are
misreported as having failed).

The crucial difference that exists between SATA and USB is not
that USB chips have higher rates of detected failures (even if
they often do), but that in my experience SATA interfaces from
reputable suppliers don't "lie" (more realistically have
negligible "lie" rates), and USB interfaces (both host bus
adapters and IO bus bridges) "lie" both systematically and
statistically with non negligible rates, and anyhow the USB mass
storage protocol is not very good at error reporting and
handling.

>> The "working incorrectly" general case is the so called
>> "bizantine generals problem" [ ... ]

This is compsci for beginners and someone dealing with storage
issues (and not just) should be intimately familiar with the
implications:

  https://en.wikipedia.org/wiki/Byzantine_fault_tolerance

  Byzantine failures are considered the most general and most
  difficult class of failures among the failure modes. The
  so-called fail-stop failure mode occupies the simplest end of
  the spectrum. Whereas fail-stop failure model simply means
  that the only way to fail is a node crash, detected by other
  nodes, Byzantine failures imply no restrictions, which means
  that the failed node can generate arbitrary data, pretending
  to be a correct one, which makes fault tolerance difficult.
