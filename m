Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailout2.ltindia.com ([203.199.60.171]:13748 "EHLO
	mailout2.ltindia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751495AbaL3Gx2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 30 Dec 2014 01:53:28 -0500
From: Ankur Tank <Ankur.Tank@LntTechservices.com>
To: Martin Steigerwald <Martin@lichtvoll.de>
CC: Anand Jain <Anand.Jain@oracle.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: RE: btrfs doesn't format eMMC if previous filesystem is ext4
Date: Tue, 30 Dec 2014 06:53:21 +0000
Message-ID: <CFB3B8F56DDE9F45B45EBDEBED372A66442604@POCITMSEXMB05.LntUniverse.com>
References: <CFB3B8F56DDE9F45B45EBDEBED372A6644232D@POCITMSEXMB05.LntUniverse.com>
 <1749413.JF4i0WjTJs@merkaba>
 <CFB3B8F56DDE9F45B45EBDEBED372A66442494@POCITMSEXMB05.LntUniverse.com>
 <1638201.NiAcHcsd0T@merkaba>
In-Reply-To: <1638201.NiAcHcsd0T@merkaba>
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Martin,

I agree as of now it's better to refer mkfs.<FS> manpage and use it appropriately.
I will write separate email to fsdevel mailing list.

Thank you,

Regards,
Ankur
-----Original Message-----
From: Martin Steigerwald [mailto:Martin@lichtvoll.de]
Sent: Monday, December 29, 2014 3:48 PM
To: Ankur Tank
Cc: Anand Jain; linux-btrfs@vger.kernel.org
Subject: Re: btrfs doesn't format eMMC if previous filesystem is ext4

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

Well, it is *one* of the forums. For that you probably need to CC every filesystem development mailing list :) or as an alternative the common fsdevel mailing list.

And yes, mkfs.reiserfs also takes -l. And the mkfs wrapper does *not* convert the option. So if you use mkfs -t reiserfs -L it doesn´t work. That is why I always use the mkfs.<FS> manpage and tool directly.

I think all mkfs tools should do the blkid check and not overwrite an existing filesystem just so.

--
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
L&T Technology Services Ltd

www.LntTechservices.com<http://www.lnttechservices.com/>

This Email may contain confidential or privileged information for the intended recipient (s). If you are not the intended recipient, please do not use or disseminate the information, notify the sender and delete it from your system.
