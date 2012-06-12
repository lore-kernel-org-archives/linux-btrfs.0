Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:49475 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752870Ab2FLWTf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Jun 2012 18:19:35 -0400
Date: Tue, 12 Jun 2012 18:19:31 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: Chris Mason <chris.mason@fusionio.com>,
        "kreijack@inwind.it" <kreijack@inwind.it>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Liu Bo <liubo2009@cn.fujitsu.com>
Subject: Re: Btrfs and data nocow per inode basis
Message-ID: <20120612221931.GA31585@thunk.org>
References: <4FD442F1.7040008@inwind.it>
 <4FD77F45.3060000@libero.it>
 <20120612183209.GC1803@thunk.org>
 <20120612191527.GA11966@thunk.org>
 <20120612204423.GA27777@shiny>
 <20120612211043.GH12161@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20120612211043.GH12161@thunk.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

... and e2fsprogs 1.42.4 has been released, with the No_COW lsattr and
chattr support.  It's in all of the usual places:

ftp://ftp.kernel.org/pub/linux/kernel/people/tytso/e2fsprogs/v1.42.4

and

http://prdownloads.sourceforge.net/e2fsprogs/e2fsprogs-1.42.4.tar.gz

... and I've uploaded a release to debian unstable, which will
hopefully make it into testing before the upcoming stable release
(Wheezy) freeze.

You can look through the release notes at:

http://e2fsprogs.sourceforge.net/e2fsprogs-release.html#1.42.4

Regards,

						- Ted
