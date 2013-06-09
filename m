Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from v1167.vcdns.de ([88.80.200.92]:60042 "EHLO delorus.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750853Ab3FIKoZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 9 Jun 2013 06:44:25 -0400
Message-ID: <51B45C87.2040308@delorus.de>
Date: Sun, 09 Jun 2013 12:44:23 +0200
From: =?ISO-8859-1?Q?Andr=E9_Schlichting?= <andre@delorus.de>
MIME-Version: 1.0
To: Chris Murphy <lists@colorremedies.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: Moved partition via dd
References: <51B327C4.3000304@delorus.de> <E3D849EC-DDAC-4E05-9571-303B869F7A8D@colorremedies.com> <51B3B339.4030108@delorus.de> <8E5CABA3-602A-4D2F-AAEF-74F007F3C2FF@colorremedies.com>
In-Reply-To: <8E5CABA3-602A-4D2F-AAEF-74F007F3C2FF@colorremedies.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am 09.06.2013 00:57, schrieb Chris Murphy:
> The next issue:
>
>>> if=/dev/sdc2 skip=$((245547520-33024)) seek=0 of=/dev/sdc2
>
> You have a skip (skip n block from input) value well inside of sdc2. It seems you should have skipped from sdc not sdc2, and should have used the old start value for sdc2 which was just 245547520, and you needed to specify a count value in order to get the correct number of blocks, which would have been 732566527-245547520. Then write those blocks to sdc2 (which makes seek= unnecessary).
>
>
> Chris Murphy
>

/dev/sdc2 at this moment was already the new partition with boundaries 
33024 to 732566640 with the old partition inside. Therefore I used 
skip=old start - new start, which inside of sdc2 points to the start of 
the old partition. I didn't worry about the count, because the partition 
was at the end of the disk.

I actually think that the move of the partition was no problem. I guess 
that btrfs has some absolute references which have to be adjusted and 
now has some problems with sectors not at the right place. The following 
error from btrfsck
 > Check tree block failed, want=959572647936, have=13587293097915834379
suggests that 959572647936 is a way off...

Maybe first, the principal question: Can one just move a btrfs-partition 
to the left by
* delete partition
* create partition moved
* dd data from old to new partition
Or does one have to adjust some references inside the btrfs filesystem?
