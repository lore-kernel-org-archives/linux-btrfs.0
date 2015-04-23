Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:50430 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756718AbbDWExh (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 23 Apr 2015 00:53:37 -0400
Date: Wed, 22 Apr 2015 21:53:11 -0700
From: Marc MERLIN <marc@merlins.org>
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs@vger.kernel.org
Message-ID: <20150423045311.GB20088@merlins.org>
References: <201504221808.30242.thomas@koch.ro>
 <pan$5278$86c57e90$b5f9efb5$e578b832@cox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <pan$5278$86c57e90$b5f9efb5$e578b832@cox.net>
Subject: Re: btrfs subvolume diff
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Apr 23, 2015 at 03:43:35AM +0000, Duncan wrote:
> Thomas Koch posted on Wed, 22 Apr 2015 18:08:30 +0200 as excerpted:
> 
> > for incremental backups it would be useful to know the files that
> > changed between two snapshots. I found a paper about such a tool[1] that
> > adds the "btrfs subvolue diff" command, but it's not yet implemented in
> > btrfs-tools in Debian Jessie.
> > 
> > Is it in Git? Or somewhere else?
> > 
> > [1] https://www.kernel.org/doc/ols/2014/ols2014-pimpale.pdf
> 
> [Note that I'm just a btrfs user and list regular, not a dev, and that my 
> own use-case doesn't involve subvolumes, tho I played with them a bit 
> when I first got into btrfs, so my practical subvolume management 
> knowledge is limited.  But based on current git's manpages...]

Not a great answer but better than nothing:
http://marc.merlins.org/perso/btrfs/2014-05.html#Btrfs-diff-Between-Snapshots

(based on find-new)

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
