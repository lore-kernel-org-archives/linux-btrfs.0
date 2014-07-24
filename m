Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:54963 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S933790AbaGXRTj convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Jul 2014 13:19:39 -0400
Received: from c-75-70-18-61.hsd1.co.comcast.net ([75.70.18.61]:49993 helo=ming.hsd1.co.comcast.net)
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.82)
	(envelope-from <lists@colorremedies.com>)
	id 1XAMg6-0022nz-5p
	for linux-btrfs@vger.kernel.org; Thu, 24 Jul 2014 11:19:38 -0600
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: 1 week to rebuid 4x 3TB raid10 is a long time!
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <2C76C454-2B09-4E3B-92C2-4EE6A1ED7EA8@colorremedies.com>
Date: Thu, 24 Jul 2014 11:19:36 -0600
Message-Id: <C53139CC-2FC6-49B0-8315-61FB0D534063@colorremedies.com>
References: <loom.20140720T102642-239@post.gmane.org> <53CC1553.1020908@shiftmail.org> <20140721013609.6d99c399@natsu> <37e3a8cf8b7439d5cd2745b5efb9d37f.squirrel@webmail.wanet.net> <pan$7b757$4788e010$b65976c7$4d1c0bad@cox.net> <CAN05THTSG9czwpM7AYEPWg5hpZuJ=vjJrjz8yn5V0rXe5oguxA@mail.gmail.com> <pan$6f72e$34416d71$688a2a2$980c8acd@cox.net> <2C76C454-2B09-4E3B-92C2-4EE6A1ED7EA8@colorremedies.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Jul 22, 2014, at 11:13 AM, Chris Murphy <lists@colorremedies.com> wrote:
> 
> It's been a while since I did a rebuild on HDDs, 

So I did this yesterday and day before with an SSD and HDD in raid1, and made the HDD do the rebuild. 


Baseline for this hard drive:
hdparm -t
35.68 MB/sec

dd if=/dev/zero of=/dev/rdisk2s1 bs=256k
13508091392 bytes transferred in 521.244920 secs (25915056 bytes/sec)

I don't know why hdparm gets such good reads, and dd writes are 75% of that, but the 26MB/s write speed is realistic (this is a Firewire 400 external device) and what I typically get with long sequential writes. It's probable this is interface limited to mode S200, not a drive limitation since on SATA Rev 2 or 3 interface I get 100+MB/s transfers.

During the rebuild, iotop reports actual write averaging in the 24MB/s range, and the total data to restore divided by total time for the replace command comes out to 23MB/s. The source data is a Fedora 21 install with no meaningful user data (cache files and such), so mostly a bunch of libraries, programs, and documentation. Therefore it's not exclusively small files, yet the iotop rate was very stable throughout the 4 minute rebuild.

So I still think 5MB/s for a SATA connected (?) drive is to be unexpected.

 
Chris Murphy