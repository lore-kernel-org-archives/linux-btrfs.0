Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:41543 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753781AbbFBO50 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 2 Jun 2015 10:57:26 -0400
Date: Tue, 2 Jun 2015 16:57:24 +0200
From: David Sterba <dsterba@suse.cz>
To: sam tygier <samtygier@yahoo.co.uk>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] btrfs-progs: check metadata redundancy
Message-ID: <20150602145724.GG6761@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <mkcivp$l8b$1@ger.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <mkcivp$l8b$1@ger.gmane.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, May 30, 2015 at 03:54:48PM +0100, sam tygier wrote:
> Currently BTRFS allows you to make bad choices of data and 
> metadata levels. For example -d raid1 -m raid0 means you can
> only use half your total disk space, but will loose everything
> if 1 disk fails. It should give a warning in these cases.
> 
> When making a filesystem check that metadata mode is at least
> as redundant as the data mode. For example give warning when:
> 	-d raid1 -m raid0
> 
> V1 -> V2 Downgrade from error to warning as requested by David
> Sterba.
> 
> Signed-off-by: Sam Tygier <samtygier@yahoo.co.uk>

Applied, thanks.
