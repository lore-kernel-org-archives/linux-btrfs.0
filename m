Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailout61.mail01.mtsvc.net ([216.70.64.9]:51302 "EHLO
	mailout61.mail01.mtsvc.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752923AbbLITNP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 9 Dec 2015 14:13:15 -0500
Received: from mailout91.mail01.mtsvc.net ([216.70.64.178] helo=n56.mail01.mtsvc.net)
	by mailout61.mail01.mtsvc.net with esmtps (UNKNOWN:AES256-GCM-SHA384:256)
	(Exim 4.72)
	(envelope-from <mailinglists@dhampton.net>)
	id 1a6iXH-000319-BT
	for linux-btrfs@vger.kernel.org; Wed, 09 Dec 2015 12:28:15 -0500
Received: from pool-68-134-226-101.bltmmd.fios.verizon.net ([68.134.226.101]:37699 helo=hampton-pc.dhampton.net)
	by n56.mail01.mtsvc.net with esmtpsa (UNKNOWN:AES128-GCM-SHA256:128)
	(Exim 4.72)
	(envelope-from <mailinglists@dhampton.net>)
	id 1a6iXF-0003Qi-AZ
	for linux-btrfs@vger.kernel.org; Wed, 09 Dec 2015 12:28:13 -0500
Message-ID: <1449682081.7150.0.camel@dhampton.net>
Subject: Re: Missing half of available space (resend)
From: David Hampton <mailinglists@dhampton.net>
To: linux-btrfs@vger.kernel.org
Date: Wed, 09 Dec 2015 12:28:01 -0500
In-Reply-To: <pan$2b447$368e596$ba3d70ae$2f6cd5d4@cox.net>
References: <1449637341.20669.0.camel@love2code.net>
	 <CAJCQCtQrfRxrvmGT2ZA4WM6YLN5oy-+_k+NmDpv475SAtCoVNw@mail.gmail.com>
	 <1449642609.20669.7.camel@love2code.net>
	 <pan$2b447$368e596$ba3d70ae$2f6cd5d4@cox.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 2015-12-09 at 16:48 +0000, Duncan wrote:
> David Hampton posted on Wed, 09 Dec 2015 01:30:09 -0500 as excerpted:
> 
> > Seems I need to upgrade my tools.  That command was added in 3.18 and I
> > only have the 3.12 tools.
> 
> Definitely so, especially because you're running raid6, which wasn't 
> stable until 4.1 for both kernel and userspace.  3.12?  I guess it did 
> have the very basic raid56 support, but it's definitely nothing I'd 
> trust, at that old not for btrfs in general, but FOR SURE not raid56.

I've upgraded to the 4.2.0 kernel and the 4.0 btrfs-tools package.
These are the latest that Ubuntu has packaged for 15.10, and I've pulled
them into my 14.10 based release.  Is this recent enough, or do I need
to try the 4.3 kernel/tools build from the active development tree (that
will eventually become 16.04)?

David



