Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:27203 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751442Ab3LKEH1 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 10 Dec 2013 23:07:27 -0500
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: Feature Req: "mkfs.btrfs -d dup" option on single device
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <CAK5rZE6G0WDf6rxjS7o9Cggq-CehASG1ge4bLnJm=SmHA40new@mail.gmail.com>
Date: Tue, 10 Dec 2013 21:07:21 -0700
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-Id: <6FD125A9-7975-4C34-88C7-95B11A39D054@colorremedies.com>
References: <CAK5rZE5KokaDhqCCzpAPipqYbf--qr5s2DLQgULtQVr3wMcOrQ@mail.gmail.com> <01BDC0F3-CD4E-4BF1-898C-92AD50B66B41@colorremedies.com> <CAK5rZE7bdfhD0FOe04+YoDRBfFWOy0rNfeamgDtP-=hv=SLFrw@mail.gmail.com> <F3B190DB-922A-412F-853D-71260549EF7F@colorremedies.com> <CAK5rZE6DVC5kYAU68oCjjzGPS4B=nRhOzATGM-5=m1_bW4GG6g@mail.gmail.com> <B4C47427-3A7F-4ED8-85AA-FA8E17C39EF9@colorremedies.com> <CAK5rZE6G0WDf6rxjS7o9Cggq-CehASG1ge4bLnJm=SmHA40new@mail.gmail.com>
To: Imran Geriskovan <imran.geriskovan@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Dec 10, 2013, at 8:19 PM, Imran Geriskovan <imran.geriskovan@gmail.com> wrote:
> 
> Now the question is, is it a good practice to use "-M" for large filesystems?
> Pros, Cons? What is the performance impact? Or any other possible impact?

Uncertain. man mkfs.btrfs says "Mix data and metadata chunks together for more efficient space utilization.  This feature incurs a performance penalty in larger filesystems.  It is recommended for use with filesystems of 1 GiB or smaller."

I haven't benchmarked to quantify the penalty.

> I guess you are talking about SSD's. Even if you write duplicates
> on distinct erase blocks, they may end up in same block after
> firmware's relocation, defragmentation, migration, remapping,
> god knows what ...ation operations. So practically, block
> address does not point any fixed physical location on SSDs.

Yes SSDs, although it seems that any flash media could behave this way as it's up to the manufacturer's firmware how it ends up behaving.

> Luckly we have hard drives with still sensible block addressing.
> Even with bad block relocation.

Seagate has said they've already shipped 1 million shingled magnetic recording (SMR) hard drives. I don't know what sort of "FTL-like" behavior they implement, but it stands to reason that since the file system doesn't know what LBAs translate into physical sectors that are part of a layered band, and what LBA's are suited for random IO, that the drive might be capable of figuring this out. Random IO LBA's go to physical sectors suited for this, and sequential writes go to bands.

> i.e. The new Advanced format drives may employ 4K blocks
> but present 512B logical blocks which may be another reencarnation
> of the SSD problem above. However, I guess linux kernel does not
> access such drives using logical addressing.

It does, absolutely. All drives are access by LBA these days. And Linux does fine with both varieties of AF disks: 512e, and 4Kn.

Off hand I think the only issue is that pretty much no BIOS firmware will boot from a drive with 4K logical/physical sectors, so called 4Kn drives that do not present 512byte sectors. And since UEFI bugs are all over the place, I'd kinda expect booting to work with some firmware and not others. I haven't tested it, but I'm pretty sure I've read GRUB2 and the kernel are able to boot from 4Kn drives so long as the firmware can handle it.


Chris Murphy