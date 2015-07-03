Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:38330 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754595AbbGCJbQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 3 Jul 2015 05:31:16 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1ZAxJR-0006Gu-Qk
	for linux-btrfs@vger.kernel.org; Fri, 03 Jul 2015 11:31:13 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 03 Jul 2015 11:31:13 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 03 Jul 2015 11:31:13 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Any hope of pool recovery?
Date: Fri, 3 Jul 2015 09:31:03 +0000 (UTC)
Message-ID: <pan$d53e4$45e2ddf7$2a88de7f$b02d251@cox.net>
References: <CAC=t97D=Dmq3cu-z2PNjREQn5690+R9NBQsjr5KZ4grYnYr4WA@mail.gmail.com>
	<CAJCQCtSjxs2ZZUgUfrp9q5y+x0fFA7fSnQPgeEXTjsLKZ6DPKw@mail.gmail.com>
	<CAC=t97BiPjTf7yjWoSaoTgjvPZFgyEHdEJzFCG1Mu+nnJGoNoA@mail.gmail.com>
	<CAC=t97Bg3STrTn86HBNYJJm-FT7aiR6tc51tjVnPiArpPgd9XQ@mail.gmail.com>
	<CAC=t97CS5As+3SqZy-sHM4U2JZ0bi_AEq=34bNXu0yBmh8QRjg@mail.gmail.com>
	<CAC=t97AQaDTRinVg9crdAG8zaoj_--L_PLDY3M4_HKHZotnVVg@mail.gmail.com>
	<CAJCQCtRpRg=XdMtAerHfxCWXO74s34=b9LLuk9mvfRhKz8hjFQ@mail.gmail.com>
	<CAC=t97AERgJ06P_Q8vbz=-yC=H3ODUkTt7ZD1Zpimr_jft+S6g@mail.gmail.com>
	<CAJCQCtSB+29V-UdL5JZAHu3Zv3-XH0SyL8E5MwHgyeoVQ46Wvg@mail.gmail.com>
	<CAC=t97BOYQJAanPc_EFzxwwakFrY4ALd0sX-n9w_e9JHodU27Q@mail.gmail.com>
	<CAJCQCtTE2QKQij5ziq_wWM=M0bhVKcxAbWVGOPD=R_1ZkvqWPA@mail.gmail.com>
	<CAC=t97A4JtSzXpn9Yr3vhe6Z5JCfKEFB1GfwSLsfYPOWhZ+Zrw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Donald Pearson posted on Thu, 02 Jul 2015 13:19:41 -0500 as excerpted:

> btrfs restore complains that every device is missing except the one that
> you specify on executing the command.  Multiple devices as a parameter
> isn't an option.  Specifcy /dev/disk/by-uuid/<uuid> claims that all
> devices are missing.

That sounds like the kernel lost track of what devices correspond with 
the filesystem.  Try issuing the btrfs device scan command before 
restore, and see if that changes things.  (If it doesn't, try btrfs 
device scan --all-devices, just in case.)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

