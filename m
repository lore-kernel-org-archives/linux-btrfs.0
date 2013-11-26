Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:31060 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752003Ab3KZSnH convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Nov 2013 13:43:07 -0500
Received: from c-50-183-15-223.hsd1.co.comcast.net ([50.183.15.223]:49207 helo=[192.168.1.120])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.82)
	(envelope-from <lists@colorremedies.com>)
	id 1VlNbD-004E9k-NE
	for linux-btrfs@vger.kernel.org; Tue, 26 Nov 2013 11:43:04 -0700
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: missing /sbin/fsck.btrfs
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <pan$8f316$eba9671d$d7cae9b2$d1c7e678@cox.net>
Date: Tue, 26 Nov 2013 11:43:02 -0700
Message-Id: <A1C7FA8D-A87E-40CD-A887-84C147CA5C08@colorremedies.com>
References: <13F547BC-D81C-45FB-9DC8-9C076B8605EF@colorremedies.com> <pan$8f316$eba9671d$d7cae9b2$d1c7e678@cox.net>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Nov 26, 2013, at 12:18 AM, Duncan <1i5t5.duncan@cox.net> wrote:
>> 
> 
> Just symlink/copy fsck.btrfs to (/bin/)true.

 I'm not doing this every time I install an OS, most users won't either, and nor will most distributions. So in effect, this suggestion places the burden of implementation on the btrfs-progs package to create it at install time.

> 
> https://btrfs.wiki.kernel.org/index.php/FAQ#What.27s_the_difference_between_btrfsck_and_fsck.btrfs
> 
> Or just do the /etc/fstab fs_passno = 0 thing, which is what I did with
> reiserfs, so no change in that regard here when I switched to btrfs
> for most partitions.

And that's fine, it places the burden on the distribution installer to create a correct /etc/fstab.


Chris Murphy