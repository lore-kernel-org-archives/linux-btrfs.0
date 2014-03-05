Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:49296 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755007AbaCEEIt convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 4 Mar 2014 23:08:49 -0500
Received: from c-50-183-15-223.hsd1.co.comcast.net ([50.183.15.223]:60891 helo=[192.168.1.145])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.82)
	(envelope-from <lists@colorremedies.com>)
	id 1WL38S-001CD4-UB
	for linux-btrfs@vger.kernel.org; Tue, 04 Mar 2014 21:08:49 -0700
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: ENOSPC errors during raid1 rebalance
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <DF16C10AFF7F394A8C8A09C9405478890BCC2C99@EXHOST.stardatecomputer.com>
Date: Tue, 4 Mar 2014 21:08:48 -0700
Message-Id: <87D857EF-FB03-468E-A0FD-4F5898B9581B@colorremedies.com>
References: <DF16C10AFF7F394A8C8A09C9405478890BCBE534@EXHOST.stardatecomputer.com>,<20140303183911.GL13899@carfax.org.uk> <DF16C10AFF7F394A8C8A09C9405478890BCC2C99@EXHOST.stardatecomputer.com>
To: Btrfs <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Mar 4, 2014, at 5:27 PM, Mike Russo <mike@PaperSolve.com> wrote:

> I'm sure this is due to the ext4 conversion, but that means the utility is making a btrfs filesystem that later can't be converted to another profile for some reason. 

https://btrfs.wiki.kernel.org/index.php/Conversion_from_Ext3

"But still, the new filesystem inherits the block placement and file data fragmentation. It is highly recommended to do full defragmentation and full rebalance before first use. It's not required, but will have impact on performance."

Did you do a defrag and balance after ext4>btrfs conversion, but before data/metadata profile conversion?


Chris Murphy

