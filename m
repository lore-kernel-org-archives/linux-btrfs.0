Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:38810 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756339Ab3EHUsC (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 8 May 2013 16:48:02 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 4934F7C0690
	for <linux-btrfs@vger.kernel.org>; Wed,  8 May 2013 14:48:01 -0600 (MDT)
Date: Wed, 8 May 2013 16:47:58 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Alexander Skwar <a@skwar.me>
CC: Josef Bacik <JBacik@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: WARNING: at fs/btrfs/free-space-cache.c:921
 __btrfs_write_out_cache+0x6b9/0x9a0 [btrfs]()
Message-ID: <20130508204758.GU12414@localhost.localdomain>
References: <CVrGRAreCXB@helmut.hullen.de>
 <20130430094131.GA8274@carfax.org.uk>
 <loom.20130430T133556-803@post.gmane.org>
 <20130430135816.GD2580@localhost.localdomain>
 <CADn-QaMFct-5XgMbqiWMG_pa-AzgOQOZLUc-CNTrAPpG7633Aw@mail.gmail.com>
 <20130430175351.GF2580@localhost.localdomain>
 <CADn-QaO_YqroR=EnrD1+tfRNRvLiLkhAMMAUxrbA_4s5-b5rxQ@mail.gmail.com>
 <20130501185701.GA12414@localhost.localdomain>
 <CADn-QaNeo2pnu1a94HEWWjaXtdRb2C38JJXrUMy6xBmp+MpCVw@mail.gmail.com>
 <CADn-QaPh9EZjnbr9HoRKTMi8OUgnvfRdD7riEDZ0hpkcNRN93Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <CADn-QaPh9EZjnbr9HoRKTMi8OUgnvfRdD7riEDZ0hpkcNRN93Q@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 08, 2013 at 11:34:40AM -0600, Alexander Skwar wrote:
> Hello Josef
> 
> Did you have a chance to look at that image? Did you find anything?
> 
> Or should I simply create a new filesystem and forget about the issue?
> 

So the file system isn't corrupt, you just got a giant block group for some
reason.  I've sent a patch to remove the WARN_ON() so that won't bother you
anymore.  You should probably rebalance to try and trim that block group down to
a reasonable size, but other than that your fs is a-ok.  Thanks,

Josef
