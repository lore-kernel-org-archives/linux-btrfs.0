Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f176.google.com ([209.85.213.176]:35325 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934058AbcAZMXP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Jan 2016 07:23:15 -0500
Received: by mail-ig0-f176.google.com with SMTP id t15so57370302igr.0
        for <linux-btrfs@vger.kernel.org>; Tue, 26 Jan 2016 04:23:14 -0800 (PST)
Subject: Re: suspected BTRFS errors resulting in file system becoming
 unrecovable
To: Chris Murphy <lists@colorremedies.com>
References: <525D830B-C5A6-40DC-932C-B283A7FB8932@me.com>
 <56A650AC.6050901@gmail.com>
 <CAJCQCtSBNpaMFDpRQOEAVV2d_okrWVv_OgW=J10uMaRiRThe3g@mail.gmail.com>
Cc: WillIam Thorne <will.thorne@me.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <56A764FE.5040603@gmail.com>
Date: Tue, 26 Jan 2016 07:22:22 -0500
MIME-Version: 1.0
In-Reply-To: <CAJCQCtSBNpaMFDpRQOEAVV2d_okrWVv_OgW=J10uMaRiRThe3g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-01-25 16:12, Chris Murphy wrote:
> On Mon, Jan 25, 2016 at 9:43 AM, Austin S. Hemmelgarn
> <ahferroin7@gmail.com> wrote:
>> Now, just a general caution: Avoid using USB storage for persistent online
>> storage, there's just to many things that can go wrong, and quite a few USB
>> storage controllers are absolute crap.
>
> Yes. Lately, USB 3 stuff is better in that the speeds are approaching
> rocket science, so if the manufacturer doesn't get it right, things
> rapidly implode. But as far as getting useful error messages and such,
> it's almost like the state of networking 20 years ago. You just had to
> follow the rules and swap stuff out if it wasn't working. Error codes
> might mean something to a developer but they're useless for mortal
> users.
Yeah, with storage devices at least it's a bit easier, they just speak a 
form of SCSI over the USB interface (even the older mass storage ones), 
so if you have some understanding of SCSI, it's not too hard to 
translate.  Part of the issue though is that USB was designed originally 
for input devices, and that has had a significant impact on how it got 
designed.  Add to that that most USB devices other than input devices 
aren't standards compliant in some way (usually it's incomplete 
descriptors or not properly negotiating power usage), and it starts to 
become rather impressive that things actually work to the degree they do.
>
> I really think USB hubs help fix a lot of USB related problems, even
> when it's not a power related problem. Currently I'm using internal
> SATA in a NUC for the primary storage, but use send/receive to two
> separate raid1 volumes that are USB drives. I can balance/scrub, and
> read/write to any and all drives with no problems since getting a
> dyconn "industrial" (probably a design term, it's aluminum not
> plastic) hub. Before that, one drive or another would just
> intermittently reset, usually to no ill effect, but once it wigged
> out, vanished, and reappeared as a completely different /dev/sdx
> device. The enclosures are crap, the manufacturer (ASMedia Technology
> Inc.) didn't bother to fully populate all of the USB descriptors and
> it doesn't pass through physical sector size properly, or report max
> power correctly, etc.
That's interesting, I've usually had really good results with ASMedia's 
USB devices (for reference, they're the semiconductor division of the 
same company that ASUS and ASRock are owned by); as far as not passing 
through physical sector size properly though, that's normal on almost 
all external IDE/SATA adapters (both enclosures and regular adapters), 
as is not properly handling commands other than the basic ones needed 
for disk access (such as SCT stuff and SMART related commands).  That 
said, the USB issues on the NUC don't surprise me too much, Intel's USB 
controller chips have been known to have hardware bugs (especially their 
original XHCI implementation), and I've seen stuff similar to what 
you're talking about before with other Intel systems.  Now, for other 
systems, you have to keep in mind that most of them have hubs internal 
to the system, and the external USB ports don't go directly to the USB 
controllers, but quite often these hubs are not particularly high 
quality, so they often make things worse.

