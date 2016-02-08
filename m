Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f173.google.com ([209.85.223.173]:34285 "EHLO
	mail-io0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753011AbcBHCCX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 7 Feb 2016 21:02:23 -0500
Received: by mail-io0-f173.google.com with SMTP id 9so182245059iom.1
        for <linux-btrfs@vger.kernel.org>; Sun, 07 Feb 2016 18:02:23 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <56A764FE.5040603@gmail.com>
References: <525D830B-C5A6-40DC-932C-B283A7FB8932@me.com>
	<56A650AC.6050901@gmail.com>
	<CAJCQCtSBNpaMFDpRQOEAVV2d_okrWVv_OgW=J10uMaRiRThe3g@mail.gmail.com>
	<56A764FE.5040603@gmail.com>
Date: Sun, 7 Feb 2016 19:02:22 -0700
Message-ID: <CAJCQCtRYbrhoArEbRZOE3e2kjfigEBrWnwmB73wR9ZN=Jdqbog@mail.gmail.com>
Subject: Re: suspected BTRFS errors resulting in file system becoming unrecovable
From: Chris Murphy <lists@colorremedies.com>
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        WillIam Thorne <will.thorne@me.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jan 26, 2016 at 5:22 AM, Austin S. Hemmelgarn
<ahferroin7@gmail.com> wrote:
> On 2016-01-25 16:12, Chris Murphy wrote:

>> I really think USB hubs help fix a lot of USB related problems, even
>> when it's not a power related problem. Currently I'm using internal
>> SATA in a NUC for the primary storage, but use send/receive to two
>> separate raid1 volumes that are USB drives. I can balance/scrub, and
>> read/write to any and all drives with no problems since getting a
>> dyconn "industrial" (probably a design term, it's aluminum not
>> plastic) hub. Before that, one drive or another would just
>> intermittently reset, usually to no ill effect, but once it wigged
>> out, vanished, and reappeared as a completely different /dev/sdx
>> device. The enclosures are crap, the manufacturer (ASMedia Technology
>> Inc.) didn't bother to fully populate all of the USB descriptors and
>> it doesn't pass through physical sector size properly, or report max
>> power correctly, etc.
>
> That's interesting, I've usually had really good results with ASMedia's USB
> devices (for reference, they're the semiconductor division of the same
> company that ASUS and ASRock are owned by); as far as not passing through
> physical sector size properly though, that's normal on almost all external
> IDE/SATA adapters (both enclosures and regular adapters), as is not properly
> handling commands other than the basic ones needed for disk access (such as
> SCT stuff and SMART related commands).  That said, the USB issues on the NUC
> don't surprise me too much, Intel's USB controller chips have been known to
> have hardware bugs (especially their original XHCI implementation), and I've
> seen stuff similar to what you're talking about before with other Intel
> systems.  Now, for other systems, you have to keep in mind that most of them
> have hubs internal to the system, and the external USB ports don't go
> directly to the USB controllers, but quite often these hubs are not
> particularly high quality, so they often make things worse.
>

Fair enough, it may just be some weirdness between Intel and ASMedia.
But the external hub in between them has solved the intermittant
"reset" messages I'd get, and so far I haven't had any drive vanish,
only to come back as a different /dev/sdX letter, as I had a couple
times before the hub was present.

Curiously, the NUC has a high powered port. No enclosure complains
when on that high powered port. All drives are rated in the 1A range,
but that's just for spin up, they aren't pulling that current once
spun up, even with heavy read/write. So a regular 900mA port should be
plenty adequate. But those are the ports I have the problem on...
UNLESS there's a powered external hub being used on that same 900mA
port. And then I can have 4 drives (on the hub) doing simultaneous
balance or scrubs and not a peep of an error. So I don't actually
think this is a power problem. I think it's something to do with the
internal hub you're referring to.

Also, the normal 900mA ports provide no power when the NUC is powered
off. The orange 1.5A high powered port does provide power, despite the
NUC being off.


-- 
Chris Murphy
