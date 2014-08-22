Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:56621 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S932159AbaHVQve convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 Aug 2014 12:51:34 -0400
Received: from c-75-70-18-61.hsd1.co.comcast.net ([75.70.18.61]:51044 helo=ming.hsd1.co.comcast.net)
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.82)
	(envelope-from <lists@colorremedies.com>)
	id 1XKs3p-002j9U-K2
	for linux-btrfs@vger.kernel.org; Fri, 22 Aug 2014 10:51:33 -0600
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: Distro vs latest kernel for BTRFS?
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <CAH-HCWVMO+NO0B5i0o0gCHBy9dLjc08gcqxT7oEV5WkO2BHvMA@mail.gmail.com>
Date: Fri, 22 Aug 2014 10:51:33 -0600
Message-Id: <F39D0877-994E-4A4C-BA61-2F7B532D359D@colorremedies.com>
References: <CAH-HCWVMO+NO0B5i0o0gCHBy9dLjc08gcqxT7oEV5WkO2BHvMA@mail.gmail.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Aug 22, 2014, at 5:59 AM, Shriramana Sharma <samjnaa@gmail.com> wrote:

> Hello. I've seen repeated advices to use the latest kernel. While
> hearing of the recent compression bug affecting recent kernels does
> somewhat warn one off the previous advice, I would like to know what
> people who are running regular distros do to get the latest kernel.
> 
> Personally I'm on Kubuntu, which provides mainline kernels till a
> particular point but not beyond that.
> 
> Do people here always compile the latest kernel themselves just to get
> the latest BTRFS stability fixes (and  improvements, though as a
> second priority)?

It's highly variable on this list. I'm lazy so I'm mostly using Fedora kernels from updates repo. But for Btrfs specific testing I use mainline kernels built almost daily from Fedora's koji build system, which don't even make it to the updates-testing repo.

http://koji.fedoraproject.org/koji/packageinfo?packageID=8

I only compile kernels if I'm testing a particular patch. Although I did build a kernel based on the original git pull for 3.17 just because it was a big pile of stuff and figured it was worth testing some old bugs against. So it really depends on your setup, workload, if you're testing patches, etc. The problems with 3.15 and 3.16 were unusual.


Chris Murphy

