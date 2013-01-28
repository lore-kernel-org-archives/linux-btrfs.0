Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:42529 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755553Ab3A1PyR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 28 Jan 2013 10:54:17 -0500
Date: Mon, 28 Jan 2013 16:54:15 +0100
From: David Sterba <dsterba@suse.cz>
To: Gene Czarcinski <gene@czarc.net>
Cc: David Sterba <dsterba@suse.cz>, linux-btrfs@vger.kernel.org
Subject: Re: Integration branch of btrfs-progs 2013-01-26 [not to be pulled]
Message-ID: <20130128155415.GA16977@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20130126005525.GZ28263@twin.jikos.cz>
 <20130126111421.GA16594@twin.jikos.cz>
 <51041E21.8040405@czarc.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <51041E21.8040405@czarc.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Jan 26, 2013 at 01:19:13PM -0500, Gene Czarcinski wrote:
> There are to trivial patches I just submitted to fix some formatting and a
> couple of compiler errors:
> http://article.gmane.org/gmane.comp.file-systems.btrfs/22669

I'll add this one.

> http://article.gmane.org/gmane.comp.file-systems.btrfs/22668

Will comment under the patch.

> BTW, what was wrong with the quiet-build patch?

The patch was ok, but I did not merge it properly after conflicts (eg.
the man/Makefile part was unintentionally ommitted)


david
