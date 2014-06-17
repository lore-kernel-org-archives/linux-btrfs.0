Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:36030 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755372AbaFQSzu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 Jun 2014 14:55:50 -0400
Date: Tue, 17 Jun 2014 11:55:49 -0700
From: Marc MERLIN <marc@merlins.org>
To: Josef Bacik <jbacik@fb.com>
Cc: linux-btrfs@vger.kernel.org, Chris Mason <clm@fb.com>,
        takeuchi_satoru@jp.fujitsu.com
Subject: Re: btrfs balance crash BUG ON fs/btrfs/relocation.c:1062 or RIP build_backref_tree+0x9fc/0xcc4
Message-ID: <20140617185549.GP19071@merlins.org>
References: <20140609234007.GD19071@merlins.org> <53A08925.8020700@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <53A08925.8020700@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jun 17, 2014 at 11:29:57AM -0700, Josef Bacik wrote:
> >I'm sure that filesystem is damaged in some way, but the kernel of course
> >should not crash.
> >
> 
> I don't have this mail client setup right to send patches, can you just 
> go into relocation.c in build_backref_tree and remove the need_check = 
> false; statement and see if that fixes it.  Thanks,

Sure, I'll try that tomorrow when I have access to that machine.

Just to be clear
1) You mean this one, right?
				if (!upper->checked && need_check) {
					need_check = false;   <-- delete this
					list_add_tail(&edge->list[UPPER],
						      &list);
				} else

2) is your guess that the BUG_ON I'm getting shouldn't be triggered
and your proposed patch could fix that, or that I do have an FS problem 
but that we're just going to make the kernel more lenient and not crash on it?

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
