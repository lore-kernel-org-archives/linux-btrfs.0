Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:3107 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755299Ab3HXQzh convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 24 Aug 2013 12:55:37 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.5 \(1508\))
Subject: Re: default mount options 3.10
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <pan$348ab$94e882cf$7b189911$f0786ffb@cox.net>
Date: Sat, 24 Aug 2013 10:55:35 -0600
Cc: linux-btrfs@vger.kernel.org
Message-Id: <CDCFD65D-3D63-458E-8A64-7DCDA3D50B03@colorremedies.com>
References: <52172DB0.1000701@gmail.com> <20130823122942.18548b21@ xavier-ThinkPad-T60p.lan> <4901822.EYC3h3vBSD@merkaba> <pan$348ab$94e882cf$7b189911$f0786ffb@cox.net>
To: Duncan <1i5t5.duncan@cox.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Aug 24, 2013, at 6:23 AM, Duncan <1i5t5.duncan@cox.net> wrote:

> I recommend autodefrag for general use, as well, but you'll want to have 
> it enabled when you first start copying data to the filesystem, and some 
> distros don't enable it by default and setup a system on btrfs, which 
> means there's fragmentation to begin with, and performance will probably 
> be bad for awhile (even on newly setup systems!) when the option is first 
> enabled as a result.  You can readup on defrag on the wiki for a defrag 
> command that should fix the problem, but unfortunately the command isn't 
> as straightforward as one might expect.

At least Fedora's installer developers have made it pretty clear they don't intend to use non-default mount options like this. So if autodefrag is really that important for general use, it needs to be part of the default mount options. And quite honestly, with as many changes that happen with btrfs, I think it's better if btrfs developers are making the decisions to add/remove what they think should be current default mount options for general purpose, rather than installer developers or users. Especially when the command isn't straightforward.


Chris Murphy

