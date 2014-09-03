Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:57365 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753524AbaICCoI convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 2 Sep 2014 22:44:08 -0400
Received: from c-75-70-18-61.hsd1.co.comcast.net ([75.70.18.61]:49202 helo=ming.hsd1.co.comcast.net)
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.82)
	(envelope-from <lists@colorremedies.com>)
	id 1XP0YJ-000Pa6-LS
	for linux-btrfs@vger.kernel.org; Tue, 02 Sep 2014 20:44:07 -0600
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: kernel 3.17-rc3: task rsync:2524 blocked for more than 120 seconds
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <pan$1b676$93919c37$3c0fae08$71129a93@cox.net>
Date: Tue, 2 Sep 2014 20:44:06 -0600
Message-Id: <C5F63696-2ADD-4CB6-A049-71B71A9D083E@colorremedies.com>
References: <CANg_oxzqyr3Jcx-8ntPPntjVmRjWqheUqaWOWpkhh5Rrw3Ayrw@mail.gmail.com> <540498AF.6030109@fb.com> <CANg_oxwNkjZf1gVfOJE72fUyqJvMpF+hQdN-V0_cPAJ9nxPsjQ@mail.gmail.com> <pan$efe46$daffbd12$cb4477b6$9a3e7f57@cox.net> <CANg_oxz9NGNVnY3rjeYPXqqi0PtcxZkMVyD5marfmXfvCp7VPw@mail.gmail.com> <pan$1b676$93919c37$3c0fae08$71129a93@cox.net>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Sep 2, 2014, at 12:40 AM, Duncan <1i5t5.duncan@cox.net> wrote:
> 
> Mkfs.btrfs used to default to 4 KiB node/leaf sizes; now days it defaults 
> to 16 KiB as that's far better for most usage.  I wonder if USB sticks 
> are an exception…

USB sticks > 1 GB get 16KB nodesize also. At <= 1 GB, mixed-bg is default as is 4KB nodesize. Probably because queue/rotational is 1 for USB sticks, they mount without ssd or ssd_spread which may be unfortunate (I haven't benchmarked it but I suspect ssd_spread would work well for USB sticks).

It was suggested a while ago that maybe mixed-bg should apply to larger volumes, maybe up to 8GB or 16GB?


Chris Murphy

