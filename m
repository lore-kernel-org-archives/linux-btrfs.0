Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:41728 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752896AbaBXIpG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 24 Feb 2014 03:45:06 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WHr9s-0007t2-0s
	for linux-btrfs@vger.kernel.org; Mon, 24 Feb 2014 09:45:04 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 24 Feb 2014 09:45:04 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 24 Feb 2014 09:45:04 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs userland interface isn't 32/64bit clean (breaks lsattr
 and btrfs send)
Date: Mon, 24 Feb 2014 08:43:44 +0000 (UTC)
Message-ID: <pan$3f644$bd8e6a71$2603a9b4$2382ccea@cox.net>
References: <20140224055103.GA15937@merlins.org>
	<pan$78eb$fa967f30$1d30da9e$2510275d@cox.net>
	<20140224082938.GF23877@carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hugo Mills posted on Mon, 24 Feb 2014 08:29:38 +0000 as excerpted:

> On Mon, Feb 24, 2014 at 06:32:14AM +0000, Duncan wrote:
>> 
>> This is a known issue.  There's patches in the pipeline for 32-bit
>> userspace on a 64-bit kernel, already.
> 
>    If you mean my recent patch, that's only for receive. I've not
> noticed any other issues on my 32/64 system, but I've not done much with
> it either (with btrfs, it's only really used for btrfs receive --
> everything else is ext4).

Thanks.  Yes, I believe that's what I had in mind.  So apparently there's 
more needed.  (I /think/ I might have seen at least one additional patch 
float by for 32/64, but as it's out of my usage domain I'm not paying 
/that/ much attention to it, so perhaps not.)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

