Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:52082 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751119Ab3KYWrI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 Nov 2013 17:47:08 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Vl4vq-0005Uz-Hk
	for linux-btrfs@vger.kernel.org; Mon, 25 Nov 2013 23:47:06 +0100
Received: from cpc21-stap10-2-0-cust974.12-2.cable.virginm.net ([86.0.163.207])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 25 Nov 2013 23:47:06 +0100
Received: from m_btrfs by cpc21-stap10-2-0-cust974.12-2.cable.virginm.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 25 Nov 2013 23:47:06 +0100
To: linux-btrfs@vger.kernel.org
From: Martin <m_btrfs@ml1.co.uk>
Subject: Re: btrfs-progs tagged as v3.12
Date: Mon, 25 Nov 2013 22:46:56 +0000
Message-ID: <l70k0l$pf$1@ger.gmane.org>
References: <20131125214534.8160.40797@ret.masoncoding.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
In-Reply-To: <20131125214534.8160.40797@ret.masoncoding.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I'm humbly totally unqualified to comment but that sounds like an
excellent idea. Thanks.

I can't say for others but I was put off by the 0.19 forever eternal
version which pushed me to investigate GIT... I'm sure that has been
putting off many people including distro assemblers.


Just for some positive comment: Good progress, thanks.

Regards,
Martin

(OK, that's the last of the positives for the Christmas present. Back to
bugging! ;-) )



On 25/11/13 21:45, Chris Mason wrote:
> Hi everyone,
> 
> I've tagged the current btrfs-progs repo as v3.12.  The new idea is that
> instead of making the poor distros pull from git, I'll be creating
> tagged releases at roughly the same pace as Linus cuts kernels.
> 
> Given the volume of btrfs-progs patches, we should have enough new code
> and fixes to justify releases at least as often as the kernel.  Of
> course, if there are issues that need immediate attention, I'll tag a .y
> release (v3.12.1 for example).
> 
> If the progs changes slow down, we might skip a version.  But tracking
> kernel version numbers makes it easier for me to line up bug reports,
> mostly because I already devote a fair number of brain cells to
> remembering how old each kernel is.
> 
> Just let me know if there are any questions.
> 
> -chris



