Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:59578 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752274AbaAIRbk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 9 Jan 2014 12:31:40 -0500
Received: from c-50-183-15-223.hsd1.co.comcast.net ([50.183.15.223]:50117 helo=[192.168.1.145])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.82)
	(envelope-from <lists@colorremedies.com>)
	id 1W1JSD-0036yO-9P
	for linux-btrfs@vger.kernel.org; Thu, 09 Jan 2014 10:31:38 -0700
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: How does btrfs handle bad blocks in raid1?
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <52CE9B9C.2040006@gmail.com>
Date: Thu, 9 Jan 2014 10:31:38 -0700
Message-Id: <DA8C6B1F-100C-46D0-8DF5-F77C85FB9A50@colorremedies.com>
References: <CAFvQSYRWBqMdAm-9yWhv4SS1YW-LB71iOZvgkNPc9BG3Wh7erw@mail.gmail.com>	<20140109104247.GH15634@carfax.org.uk> <pan$ab233$2067aff9$a13049e6$e769dc55@cox.net> <52CE9B9C.2040006@gmail.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Jan 9, 2014, at 5:52 AM, Austin S Hemmelgarn <ahferroin7@gmail.com> wrote:
> Just a thought, you might consider running btrfs on top of LVM in the
> interim, it isn't quite as efficient as btrfs by itself, but it does
> allow N-way mirroring (and the efficiency is much better now that they
> have switched to RAID1 as the default mirroring backend)

The problem that in case of mismatches, it's ambiguous which are correct.


Chris Murphy

