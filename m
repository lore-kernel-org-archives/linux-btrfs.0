Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from SD88.btc-net.bg ([212.39.90.88]:48258 "HELO sd88.btc-net.bg"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751589AbaDYFFG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Apr 2014 01:05:06 -0400
From: =?utf-8?B?0J/Qu9Cw0LzQtdC9INCf0LXRgtGA0L7Qsg==?=
	<plamen@petrovi.no-ip.info>
To: "'Chris Mason'" <clm@fb.com>, "'Chris Murphy'" <lists@colorremedies.com>,
        "'Marc MERLIN'" <marc@merlins.org>
Cc: <linux-btrfs@vger.kernel.org>
References: <000001cf5f19$ac92b2b0$05b81810$@petrovi.no-ip.info> <20140423185413.GF26949@merlins.org> <001401cf5f27$17cae590$4760b0b0$@petrovi.no-ip.info> <20140423191546.GG26949@merlins.org> <000501cf5fe1$55198590$ff4c90b0$@petrovi.no-ip.info> <20140424173317.GI7884@merlins.org> <002301cf5fee$346fefc0$9d4fcf40$@petrovi.no-ip.info> <8953EAE6-E8DD-40DC-B485-128BE7CB4BA1@colorremedies.com> <000c01cf600b$b01f6cf0$105e46d0$@petrovi.no-ip.info> <20140424230704.GK7884@merlins.org> <F6EDB160-FCC5-4D1C-A5A8-AAADE5C803F6@colorremedies.com> <5359A77C.70209@fb.com>
In-Reply-To: <5359A77C.70209@fb.com>
Subject: RE: Can anyone boot a system using btrfs root with linux 3.14 or newer?
Date: Fri, 25 Apr 2014 08:04:46 +0300
Message-ID: <001401cf6043$e07038c0$a150aa40$@petrovi.no-ip.info>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> -----Original Message-----
> From: Chris Mason [mailto:clm@fb.com]
> Sent: Friday, April 25, 2014 3:08 AM
> To: Chris Murphy; Marc MERLIN
> Cc: Пламен Петров; linux-btrfs@vger.kernel.org
> Subject: Re: Can anyone boot a system using btrfs root with linux 3.14 or
> newer?
> 
> 
> 
> On 04/24/2014 08:04 PM, Chris Murphy wrote:
> >
> > On Apr 24, 2014, at 5:07 PM, Marc MERLIN <marc@merlins.org> wrote:
> >>
> >>
> >> In 3.14 the device shows up before btrfs is loaded:
> >> sd 2:0:0:0: [sda] Cache data unavailable sd 2:0:0:0: [sda] Assuming
> >> drive cache: write through sd 2:0:0:0: [sda] Attached SCSI disk
> >> (...)
> >> Btrfs loaded
> >
> > Same for me though, and I can boot.
> >
> > [    0.693215] ata1.00: ATA-6: VBOX HARDDISK, 1.0, max UDMA/133
> > [    0.693799] ata1.00: 167772160 sectors, multi 128: LBA48 NCQ (depth 31/32)
> > [    0.694153] ata1.00: configured for UDMA/133
> > [    0.695475] scsi 0:0:0:0: Direct-Access     ATA      VBOX HARDDISK    1.0  PQ: 0
> ANSI: 5
> > [    0.699386] sd 0:0:0:0: [sda] 167772160 512-byte logical blocks: (85.8
> GB/80.0 GiB)
> > [    0.699443] sd 0:0:0:0: Attached scsi generic sg0 type 0
> > [    0.700604] sd 0:0:0:0: [sda] Write Protect is off
> > [    0.701151] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
> > [    0.701187] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,
> doesn't support DPO or FUA
> > [    0.707841]  sda: sda1 sda2 sda3
> > [    0.709846] sd 0:0:0:0: [sda] Attached SCSI disk
> > (…)
> > [    2.380090] bio: create slab <bio-1> at 1
> > [    2.384645] Btrfs loaded
> >
> > So I don't think the order is it. The biggest difference I'm seeing between
> the 3.13.11 and 3.14.1 dmesg's provided:
> >
> > 3.13.11:
> > [    1.861740] bio: create slab <bio-1> at 1
> > [    1.863389] Btrfs loaded
> >
> > 3.14.1:
> > [    3.949312] bio: create slab <bio-1> at 1
> > [    3.950942] Btrfs loaded
> >
> > It's happening much later, and it's right at this point VFS complains:
> > [    4.182603] VFS: Cannot open root device "sda2" or unknown-block(8,2):
> error -38
> >
> > The 8,2 message is consistent with the kernel not knowing what file system
> sda2 is. Seems like it's saying "I see sda2, I know you want to use it as root,
> but I don't know what's there - *poof*" and it panics.
> >
> > If rootwait alone doesn't work, I wonder if root=uuid=2ba08fbc-4b95-46cc-
> b638-299f16462620 instead of root=/dev/sda2 will work along with rootwait.
> It should then wait for that fs uuid to become available, rather than waiting
> for sda2 to become available.
> >
> > I vaguely recall there recently being btrfs boot problems with the
> > module compiled in…
> >
> 
> Yes, it was with the crc code.  I noticed he has compression on and I'm
> wondering if we're hitting a similar ordering problem with the zlib init.
> 
> The best way to know for sure is to please try with an initrd. 

This will have to wait, though. Busy right now.

> If that does
> work we'll know it's an init ordering problem and we can track it down from
> there.
> 


Thanks, guys!
--------------------------------
Plamen Petrov

