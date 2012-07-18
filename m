Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:52491 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753413Ab2GRUhw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 18 Jul 2012 16:37:52 -0400
Date: Wed, 18 Jul 2012 13:37:49 -0700
From: Marc MERLIN <marc@merlins.org>
To: "Fajar A. Nugraha" <list@fajar.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: brtfs on top of dmcrypt with SSD -> Trim or no Trim
Message-ID: <20120718203749.GZ3888@merlins.org>
References: <20120202152722.GI12429@merlins.org> <20120201175624.GE16796@shiny> <20120218160702.GB32373@merlins.org> <20120215165540.GC4763@merlins.org> <20120213001400.GD31989@merlins.org> <20120212223242.GA31989@merlins.org> <20120202032345.GB31903@merlins.org> <20120130003754.GD4380@merlins.org> <20120718181316.GD16899@merlins.org> <CAG1y0seiFAWfcc0onUuK8K6+2sXkB-AAhe_okRDWaB9um97abA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAG1y0seiFAWfcc0onUuK8K6+2sXkB-AAhe_okRDWaB9um97abA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 19, 2012 at 03:04:29AM +0700, Fajar A. Nugraha wrote:
> > On the Crucial RealSSD C300 256GB, and from talking to their tech support
> > and other folks who happened to have gotten that 'drive' at work and also
> > got weird unexplained failures, I'm convinced that even its latest 007
> > firmware (the firmware it shipped with would just hang the system for a few
> > seconds every so often so I did upgrade to 007 early on), the drive does
> > very poorly without TRIM when it's getting close to full.
> 
> If you're going to edit the wiki, I'd suggest you say "SOME SSDs might
> need to use TRIM with dmcrypt". That's because some SSD controllers
> (e.g. sandforce) performs just fine without TRIM, and in my case TRIM
> made performance worse.

Right. I'm definitely planning on writing that it is controller dependent.

By the way, I read that SF performs worse with dmcrypt because:
http://superuser.com/questions/250626/sandforce-ssd-encryption-security-and-support
'Using software full-disk-encryption on an SSD seriously impacts the
performance of the drive - up to a point where it can be slower than a
regular hard disk.'
http://c089.wordpress.com/2011/02/28/encrypting-solid-state-disks/
http://www.madshrimps.be/articles/article/965#axzz1FGfzD15q

So, really, it seems that one should not buy a drive with a sandforce
controller if you plan to use dmcrypt.
I haven't found clear data to say which controllers other than sandforce
have the same problem.

https://docs.google.com/a/google.com/viewer?a=v&q=cache:eyoe3gL10qcJ:www.samsung.com/global/business/semiconductor/file/product/ssd/SamsungSSD_Encryption_Benchmarks_201011.pdf+&hl=en&gl=us&pid=bl&srcid=ADGEEShHEj1jkxdwa7JREmubW6iAyc2RGqQt8MoGxMgQrRNDifoGqTYWjYdaUypnaRtkjKrjiOt1JCr4dDt4ycD2rjWO51PtAo67JvnZGe6Gx1s-9yjkRVYZWsUHZApkjm7dWVzkdQg6&sig=AHIEtbRaViqG4cYC_RYajAW04JRjNhQq6g
seems to imply that software encryption on samsung drives (which is what I
just got as a replacement for my crucial), does not have the same penalty
than you have with the SF controller.

But back to the point about "yes, it depends".

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
