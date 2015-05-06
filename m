Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:60818 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752094AbbEFRtg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 May 2015 13:49:36 -0400
Date: Wed, 6 May 2015 10:49:16 -0700
From: Marc MERLIN <marc@merlins.org>
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: 3.19.6: __btrfs_free_extent:5987: errno=-2 No such entry, did btrfs check --repair break it?
Message-ID: <20150506174916.GB32029@merlins.org>
References: <20140824000720.GN3875@merlins.org> <20140926214821.GX13219@merlins.org> <20150502141102.GB1809@merlins.org> <20150501210013.GH13624@merlins.org> <20150429232130.GA23814@merlins.org> <20150502163010.GK13624@merlins.org> <20150505063215.GA28387@merlins.org> <20150505195610.GE23216@merlins.org> <20150505210209.GG23216@merlins.org> <pan$a2a67$3e7e2090$a73a1a0d$778571d0@cox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <pan$a2a67$3e7e2090$a73a1a0d$778571d0@cox.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 06, 2015 at 11:04:41AM +0000, Duncan wrote:
> Long story short, nothing I tried (mounting with recovery, the new 
> integrated btrfs rescue zero-log, btrfs check --repair...) seemed to fix 
> it.  =:^(  So I got to use the new btrfs-progs v4.0 metadata-restoration 
> option in btrfs restore, updating my previous btrfs restore experience 
> from nearly a year ago. =:^)

My filesystem is still mounting ok. I just did recovery,ro, but I'm pretty
sure it would work read/write for a while.

I'll probably destroy and re-create it tonight unless I hear from a dev who
wants me to try something first.

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
