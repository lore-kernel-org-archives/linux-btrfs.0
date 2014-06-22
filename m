Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:47965 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751743AbaFVS4q convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 22 Jun 2014 14:56:46 -0400
Received: from c-75-70-18-61.hsd1.co.comcast.net ([75.70.18.61]:62727 helo=[192.168.1.145])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.82)
	(envelope-from <lists@colorremedies.com>)
	id 1WymwV-002vD5-P3
	for linux-btrfs@vger.kernel.org; Sun, 22 Jun 2014 12:56:44 -0600
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: btrfs on whole disk (no partitions)
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <53A6EC60.3030606@chinilu.com>
Date: Sun, 22 Jun 2014 12:56:42 -0600
Message-Id: <77EEF3DC-14BF-483A-BEB3-6BA4C17C2FA7@colorremedies.com>
References: <CAPLrYESSX+D5tnY_qWcz0B+xUyyT1Ut-ALM=b9TfehACUq82GA@mail.gmail.com>	<2316027.LZEnVG8laK@xev>	<CAPLrYETdzeT_Yia-nnbZBMvGxU3x7tCFiJSv3rNJezMsjce3Zw@mail.gmail.com>	<6CA8020B-EB92-4A44-8AA5-3F69709F81F2@colorremedies.com>	<CAK5rZE6gfmQsZz3W_8t=pkKEk_rzqUn5hQVv0sbt8p7qbdhSdQ@mail.gmail.com>	<53A6DDAD.8070804@chinilu.com> <20140622201140.08e74b7e@natsu> <53A6EC60.3030606@chinilu.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Jun 22, 2014, at 8:46 AM, George Mitchell <george@chinilu.com> wrote:
> 
> http://johannes-bauer.com/linux/wdc/?menuid=3

OK well a post full of hyperbole from an misogynistic jackass doesn't really convince me there's a real problem here. Telling Linux/fdisk/parted that a 4096 byte physical sector drive is 512 byte physical sector doesn't cause any change in behavior regarding alignment. Alignment is done by starting each partition at an LBA that's 8 sector aligned. This has been done for quite a long time on Linux by starting partition 1 at LBA 2048 which is not merely 8 sector aligned but is 1MB aligned. And further by specifying partition sizes in whole MB is both easy and assures alignment for any subsequent partitions. It makes no difference if the drive is 512/512 or 512/4096.

What might matter is if the Linux SCSI layer is optimizing writes to 512/512 drives, where a 4096 byte file system block doesn't need to be completely rewritten, rather only fewer than all 8 sectors. So if the Linux SCSI layer does that on a 4096 byte physical sector drive, it will cause the drive to do RMW. So either someone familiar with the code maybe will speak up how this works, or how to find out indirectly by intercepting commands to the drive.

Chris Murphy

