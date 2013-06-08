Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:61242 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752887Ab3FHW5z convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 8 Jun 2013 18:57:55 -0400
Content-Type: text/plain; charset=iso-8859-1
Mime-Version: 1.0 (Mac OS X Mail 6.3 \(1503\))
Subject: Re: Moved partition via dd
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <51B3B339.4030108@delorus.de>
Date: Sat, 8 Jun 2013 18:57:50 -0400
Cc: linux-btrfs@vger.kernel.org
Message-Id: <8E5CABA3-602A-4D2F-AAEF-74F007F3C2FF@colorremedies.com>
References: <51B327C4.3000304@delorus.de> <E3D849EC-DDAC-4E05-9571-303B869F7A8D@colorremedies.com> <51B3B339.4030108@delorus.de>
To: =?iso-8859-1?Q?Andr=E9_Schlichting?= <andre@delorus.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Jun 8, 2013, at 6:42 PM, André Schlichting <andre@delorus.de> wrote:

> 
> I'm not sure, but this external disk has a GPT with sector size 4096 and as I wrote the dm-crypted LUKS container can be opened without complains.
> > fdisk -l /dev/sdc
> WARNING: fdisk GPT support is currently new, and therefore in an experimental phase. Use at your own discretion.
> 
> Disk /dev/sdc: 3000.6 GB, 3000592982016 bytes, 732566646 sectors
> Units = Sektoren of 1 * 4096 = 4096 bytes
> Sector size (logical/physical): 4096 bytes / 4096 bytes

Ahh, one of the new 4kN drives, interesting. So in that case bs=4096 is OK.

The next issue:

>> if=/dev/sdc2 skip=$((245547520-33024)) seek=0 of=/dev/sdc2

You have a skip (skip n block from input) value well inside of sdc2. It seems you should have skipped from sdc not sdc2, and should have used the old start value for sdc2 which was just 245547520, and you needed to specify a count value in order to get the correct number of blocks, which would have been 732566527-245547520. Then write those blocks to sdc2 (which makes seek= unnecessary).


Chris Murphy