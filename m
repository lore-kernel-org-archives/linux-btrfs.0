Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:53018 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751153AbaAYApI convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 24 Jan 2014 19:45:08 -0500
Received: from c-50-183-15-223.hsd1.co.comcast.net ([50.183.15.223]:59678 helo=[192.168.1.145])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.82)
	(envelope-from <lists@colorremedies.com>)
	id 1W6rMx-001FKp-UX
	for linux-btrfs@vger.kernel.org; Fri, 24 Jan 2014 17:45:08 -0700
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: btrfs and ECC RAM
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <52DD49F3.8050100@chinilu.com>
Date: Fri, 24 Jan 2014 17:45:06 -0700
Message-Id: <75B4E5E0-07FF-401B-BE23-1B3D768AB0EF@colorremedies.com>
References: <AE93F05D-BEE7-4CE6-970E-137EA41D1C7B@aei.mpg.de> <CAPpBBdNfxchPw0DCLxNNoFZc5jGec88Q5j0C-uGy88oae0TDiw@mail.gmail.com> <52DC9453.4000705@gmail.com> <96091903-E1B0-4455-9EDC-EF94EE2E5110@aei.mpg.de> <52DD426A.5020104@shiftmail.org> <52DD49F3.8050100@chinilu.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Jan 20, 2014, at 9:08 AM, George Mitchell <george@chinilu.com> wrote:

> After reading the recent posts on this topic I am beginning to think there is some real confusion between "check sums" and "parity". 

Yes, I often see conventional raid6 assumed to always be capable of detecting and correcting corruption, not merely the ability to rebuild missing data of known location and length in a stripe (known either due to the drive reporting read error along with LBA; or a physical device becoming unavailable or unresponsive).

> But I CAN see how bad RAM could affect parity calculations and resulting data IN THE ABSENCE of protective checksums and cannot help but wonder if THAT is what the original article is describing.

Does Btrfs (and I'd presume ZFS) raid5/6 checksum both data and parity chunks? And in the case of raid6 are the two parities separately checksummed?


Chris Murphy

