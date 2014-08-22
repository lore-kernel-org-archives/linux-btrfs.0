Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:36796 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932487AbaHVRjC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 Aug 2014 13:39:02 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: Shriramana Sharma <samjnaa@gmail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Distro vs latest kernel for BTRFS?
Date: Fri, 22 Aug 2014 19:38:59 +0200
Message-ID: <5464164.8Uxj5nlT6d@merkaba>
In-Reply-To: <CAH-HCWVMO+NO0B5i0o0gCHBy9dLjc08gcqxT7oEV5WkO2BHvMA@mail.gmail.com>
References: <CAH-HCWVMO+NO0B5i0o0gCHBy9dLjc08gcqxT7oEV5WkO2BHvMA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Freitag, 22. August 2014, 17:29:29 schrieb Shriramana Sharma:
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

I compile own kernel on my main laptop cause I want to follow kernel 
development closely for my Linux Performance analysis and tuning trainings and 
also help a bit with testing things.

I don´t compile kernels on any other machines anymore. Instead I use what 
Debian Sid gives me. On the server VM I use 3.14 Debian Wheezy Backports 
kernel, an will continue to do so, until I know a 3.16 package with BTRFS fixes 
hits the backports repo.

I recommend against SLES 11 SP 3 stable kernel. Their 3.0 had serious free 
space issues in one VM after *just* installing OpenLDAP and have snapper 
continue with the snapshotting. It was still 2GB free, but I was not able to 
delete files or delete snapshots anymore. I think I also try rebalancing the 
FS. After a while I gave up and reverted to a previous VM snapshot.

I know this is supported officially, but I don´t think this is anywhere near 
production ready. SLES 12 should be much better as its using a newer kernel.

On any account long time enterprise Linux kernels may easily become outdated. 
I know they are backporting things, but I think for BTRFS its better to follow 
new kernels as is more timely.

With the distros that release all 6 months or so, I think you get recent 
enough kernel easily. With Debian you can use backport kernels. Some distros 
have additionally kernel repos for more recent kernels. And I in the end I 
think you can even install newer kernel packages on enterprise distros, but… 
you loose support this way.

For Kubuntu / Ubuntu I think there even is a daily kernel PPA. I think 
Phoronix uses it for their daily performance regression testing (and making 
big noise of regressions even in RC kernels).

Ciao,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
