Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:62178 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750868Ab3FIUJo convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 9 Jun 2013 16:09:44 -0400
Content-Type: text/plain; charset=iso-8859-1
Mime-Version: 1.0 (Mac OS X Mail 6.3 \(1503\))
Subject: Re: Moved partition via dd
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <51B45C87.2040308@delorus.de>
Date: Sun, 9 Jun 2013 16:09:41 -0400
Message-Id: <13DFA679-F509-4BD9-8393-F984D66CE70B@colorremedies.com>
References: <51B327C4.3000304@delorus.de> <E3D849EC-DDAC-4E05-9571-303B869F7A8D@colorremedies.com> <51B3B339.4030108@delorus.de> <8E5CABA3-602A-4D2F-AAEF-74F007F3C2FF@colorremedies.com> <51B45C87.2040308@delorus.de>
To: =?iso-8859-1?Q?Andr=E9_Schlichting?= <andre@delorus.de>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Jun 9, 2013, at 6:44 AM, André Schlichting <andre@delorus.de> wrote:
> 
> /dev/sdc2 at this moment was already the new partition with boundaries 33024 to 732566640 with the old partition inside. Therefore I used skip=old start - new start, which inside of sdc2 points to the start of the old partition. I didn't worry about the count, because the partition was at the end of the disk.

The end points are different according to information provided:
>> The old partition had the sector boundaries: 245547520 - 732566527
>> I deleted this one and created a new one with boundaries: 33024 - 732566640

But also, the containing LUKS volume hasn't been grown yet. I wonder if it's a problem for the LUKS container to be on a much larger partition, not yet resized, and yet made active.

It seems the LUKS volume was found and opened, which means all of its metadata is intact, but the resulting mounted (decrypted) block device is corrupt, although even though the LUKS device hasn't been resized I'd think you should still be able to mount the existing file system, but the resize wouldn't have been possible without first resizing the LUKS device.

> 
> Maybe first, the principal question: Can one just move a btrfs-partition to the left by
> * delete partition
> * create partition moved
> * dd data from old to new partition
> Or does one have to adjust some references inside the btrfs filesystem?

I just did this without LUKS and it did work.


Chris Murphy