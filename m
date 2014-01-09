Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:54367 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751137AbaAIR3q (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 9 Jan 2014 12:29:46 -0500
Received: from c-50-183-15-223.hsd1.co.comcast.net ([50.183.15.223]:50116 helo=[192.168.1.145])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.82)
	(envelope-from <lists@colorremedies.com>)
	id 1W1JQN-003604-NC
	for linux-btrfs@vger.kernel.org; Thu, 09 Jan 2014 10:29:43 -0700
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: How does btrfs handle bad blocks in raid1?
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <CAPpBBdNNHB3igMK67j5FpZxg7f6tmxGZk8x1OSwKd8GhTqsj=w@mail.gmail.com>
Date: Thu, 9 Jan 2014 10:29:44 -0700
Message-Id: <1A23203F-CC51-4D39-B868-0C4188357F08@colorremedies.com>
References: <CAFvQSYRWBqMdAm-9yWhv4SS1YW-LB71iOZvgkNPc9BG3Wh7erw@mail.gmail.com> <20140109104247.GH15634@carfax.org.uk> <pan$ab233$2067aff9$a13049e6$e769dc55@cox.net> <52CE9B9C.2040006@gmail.com> <pan$5a8b0$23680cbf$a1bd97e9$1743c66f@cox.net> <CAPpBBdNNHB3igMK67j5FpZxg7f6tmxGZk8x1OSwKd8GhTqsj=w@mail.gmail.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Jan 9, 2014, at 9:49 AM, George Eleftheriou <eleftg@gmail.com> wrote:
> 
> I'm really looking forward to the day that typing:
> 
> mkfs.btrfs -d raid10 -m raid10  /dev/sd[abcd]
> 
> will do exactly what is expected to do. A true RAID10 resilient in 2
> disks' failure. Simple and beautiful.


How is a resilient 2 disk failure possible with four disk raid10?

Chris Murphy

