Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:56603 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754595Ab3BUPqG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Feb 2013 10:46:06 -0500
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 335DA7C0684
	for <linux-btrfs@vger.kernel.org>; Thu, 21 Feb 2013 08:46:05 -0700 (MST)
Date: Thu, 21 Feb 2013 10:46:02 -0500
From: Chris Mason <chris.mason@fusionio.com>
To: Filipe Brandenburger <filbranden@google.com>
CC: Josef Bacik <JBacik@fusionio.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: LAST CALL FOR BTRFS-NEXT
Message-ID: <20130221154602.GE12051@shiny.masoncoding.com>
References: <20130220142612.GA2062@localhost.localdomain>
 <CADU+-uBHcLUQQiv526xTheB_csCq5-fXOHgJbXCAZG9t5z2xdQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <CADU+-uBHcLUQQiv526xTheB_csCq5-fXOHgJbXCAZG9t5z2xdQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Feb 21, 2013 at 08:20:37AM -0700, Filipe Brandenburger wrote:
> Hi Josef,
> 
> Please remove the following patch:
> 
> Btrfs: move fs/btrfs/ioctl.h to include/uapi/linux/btrfs.h
> (55e301fd57a6239ec14b91a1cf2e70b3dd135194 in your btrfs-next.git)
> 
> It's not fully cooked and I'm working on a second version of the patch
> that will do a little more rearranging of the header files according
> to the discussion on IRC a while ago.
> 

Please send those as incremental fixes unless something is horribly
broken in the current patch.

-chris
