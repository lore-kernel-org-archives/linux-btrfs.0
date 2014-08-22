Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:53832 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932132AbaHVOKG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 Aug 2014 10:10:06 -0400
Date: Fri, 22 Aug 2014 07:10:02 -0700
From: Marc MERLIN <marc@merlins.org>
To: Shriramana Sharma <samjnaa@gmail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Distro vs latest kernel for BTRFS?
Message-ID: <20140822141002.GO3875@merlins.org>
References: <CAH-HCWVMO+NO0B5i0o0gCHBy9dLjc08gcqxT7oEV5WkO2BHvMA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAH-HCWVMO+NO0B5i0o0gCHBy9dLjc08gcqxT7oEV5WkO2BHvMA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 22, 2014 at 05:29:29PM +0530, Shriramana Sharma wrote:
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

First, yeah you want to stay with 3.14 for now until the last bug that's
been found and is integrated in a stable 3.16.

Yes, I compile my own kernels, but that's mostly because that's what one
did in 1993, and that's what I still do now :)

If you're not comfortable compiling your own kernel (mostly getting the
.config options you want/need), you can
1) use a recent enough vendor kernel 
2) use their .config (or /proc/config.gz) as a way to build a new
kernel.

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
