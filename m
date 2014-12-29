Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:56561 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751310AbaL2KSa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 29 Dec 2014 05:18:30 -0500
From: Martin Steigerwald <Martin@lichtvoll.de>
To: Ankur Tank <Ankur.Tank@lnttechservices.com>
Cc: Anand Jain <Anand.Jain@oracle.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs doesn't format eMMC if previous filesystem is ext4
Date: Mon, 29 Dec 2014 11:18:28 +0100
Message-ID: <1638201.NiAcHcsd0T@merkaba>
In-Reply-To: <CFB3B8F56DDE9F45B45EBDEBED372A66442494@POCITMSEXMB05.LntUniverse.com>
References: <CFB3B8F56DDE9F45B45EBDEBED372A6644232D@POCITMSEXMB05.LntUniverse.com> <1749413.JF4i0WjTJs@merkaba> <CFB3B8F56DDE9F45B45EBDEBED372A66442494@POCITMSEXMB05.LntUniverse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Montag, 29. Dezember 2014, 09:55:13 schrieb Ankur Tank:
> Thank you for reply Anand & Matrin,
> 
> Okay I understand the intention now.
> I know it's not the forum to address issues related to mkfs commands
> But I think, options used should be same across the mkfs.XXX commands.
> Another irregularity is
> mkfs.f2fs takes "-l" to apply label, while
> mkfs.ext4 take  "-L" to apply label.
> If one has to write a common script these cases has to be handled separately.
> 
> Anyways thank you for help,

Well, it is *one* of the forums. For that you probably need to CC every
filesystem development mailing list :) or as an alternative the common
fsdevel mailing list.

And yes, mkfs.reiserfs also takes -l. And the mkfs wrapper does *not* convert
the option. So if you use mkfs -t reiserfs -L it doesn´t work. That is why I
always use the mkfs.<FS> manpage and tool directly.

I think all mkfs tools should do the blkid check and not overwrite an
existing filesystem just so.

-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
