Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:40286 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753581AbbA0Pt0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 27 Jan 2015 10:49:26 -0500
Date: Tue, 27 Jan 2015 16:49:25 +0100
From: David Sterba <dsterba@suse.cz>
To: Hugo Mills <hugo@carfax.org.uk>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH 1/2] btrfs-progs: Make option parsing more robust to code
 modifications
Message-ID: <20150127154925.GB3641@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1422371153-17355-1-git-send-email-hugo@carfax.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1422371153-17355-1-git-send-email-hugo@carfax.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jan 27, 2015 at 03:05:52PM +0000, Hugo Mills wrote:
> The current approach to option parsing, where long-only options are
> selected on the basis of their position in the long_options array is
> fragile and painful to modify if options are to be inserted into the
> list, rather than appended.
> 
> Instead, use the last field of struct option to return a value which
> cannot be a char (and hence a short option), and simply switch on those
> within the case statement.
> 
> Signed-off-by: Hugo Mills <hugo@carfax.org.uk>

Both applied, thanks.
