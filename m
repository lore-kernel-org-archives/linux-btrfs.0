Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:51562 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754121AbaHNR1o convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Aug 2014 13:27:44 -0400
Date: Thu, 14 Aug 2014 10:27:43 -0700
From: Marc MERLIN <marc@merlins.org>
To: Austin S Hemmelgarn <ahferroin7@gmail.com>
Cc: linux-btrfs@vger.kernel.org, jbacik@fb.com, clm@fb.com,
        takeuchi_satoru@jp.fujitsu.com
Subject: Re: btrfs-zero-log fails, can't mount FS
Message-ID: <20140814172743.GC27531@merlins.org>
References: <20140814160902.GA25370@merlins.org> <53ECE953.70009@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <53ECE953.70009@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 14, 2014 at 12:52:35PM -0400, Austin S Hemmelgarn wrote:
> I don't think it is likely that the Samsung SSD is to blame, in my
> experience Samsung's SSD's are better than almost every other brand
> except Intel, and I know that they honor write-barriers correctly.
> The likely issue is that the system hung during the process of a commit,
> which is one of the few things that I know of that consistently corrupts
> the filesystem.  There isn't really anything I know of to prevent it,
> except for making your system as stable as possible.
> Interestingly, this type of thing is the only issue I've ever had with
> BTRFS that wasn't traceable to hardware problems.

That was my understanding too, thanks for confirming.

Until this bug gets fixed, I'm perplexed as to why btrfs-zero-log isn't
fixing this.
Can't I unroll the last commits until I get to a stable one?

As luck would have it (again), I'm boarding a plane to Chicago tomorrow to
go speak at linuxcon about btrfs.
I would very much like not to have to spend 12H to restore my SSD from
backup :)

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
