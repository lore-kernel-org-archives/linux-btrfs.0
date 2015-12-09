Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailout91.mail01.mtsvc.net ([216.70.64.178]:34329 "EHLO
	n56.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751973AbbLIVlW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 9 Dec 2015 16:41:22 -0500
Received: from pool-68-134-226-101.bltmmd.fios.verizon.net ([68.134.226.101]:42715 helo=hampton-pc.dhampton.net)
	by n56.mail01.mtsvc.net with esmtpsa (UNKNOWN:AES128-GCM-SHA256:128)
	(Exim 4.72)
	(envelope-from <mailinglists@dhampton.net>)
	id 1a6mUE-0000KX-3Z
	for linux-btrfs@vger.kernel.org; Wed, 09 Dec 2015 16:41:22 -0500
Message-ID: <1449697281.13820.8.camel@dhampton.net>
Subject: Re: Missing half of available space (resend)
From: David Hampton <mailinglists@dhampton.net>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Date: Wed, 09 Dec 2015 16:41:21 -0500
In-Reply-To: <CAJCQCtR3OSZ5ncdz5-56yCRO-i0nsGtp3S6jzBPGmwFD3dN9Xg@mail.gmail.com>
References: <1449637341.20669.0.camel@love2code.net>
	 <CAJCQCtQrfRxrvmGT2ZA4WM6YLN5oy-+_k+NmDpv475SAtCoVNw@mail.gmail.com>
	 <1449642609.20669.7.camel@love2code.net>
	 <pan$2b447$368e596$ba3d70ae$2f6cd5d4@cox.net>
	 <1449682081.7150.0.camel@dhampton.net>
	 <CAJCQCtSuEQRVsrLim9AD3di7Rxv2xA9FOd872pNXs-CRiFZpcw@mail.gmail.com>
	 <CA+WRLO_aGZvfkCYEtHsesRGQt9+L=LRwcgBx7oU-NB-doEvuvQ@mail.gmail.com>
	 <CAJCQCtR3OSZ5ncdz5-56yCRO-i0nsGtp3S6jzBPGmwFD3dN9Xg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Ubuntu 14.04 actually ships with the 3.13 kernel.  I had already
upgraded it to 3.19 from the Ubuntu 15.04 release.

I'm pretty sure I created the btrfs partition, not the MythBuntu
installer.  I don't remember if that was even an option.

David


On Wed, 2015-12-09 at 14:28 -0700, Chris Murphy wrote:
> On Wed, Dec 9, 2015 at 12:56 PM, Gareth Pye <gareth@cerberos.id.au> wrote:
> > I wouldn't blame Ubuntu too much, 14.10 went out of support months ago
> 
> OP reported 3.19.0-32-generic #37~14.04.1-Ubuntu. And 14.04 is LTS
> supported until 2019. I think it should have something newer for both
> kernel and progs, if it's going to offer btrfs as an install time
> option. It's really easy to just have the LTS installer not offer
> Btrfs, and not install btrfs-progs.
> 
> 
> 


