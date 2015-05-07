Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:60556 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750806AbbEGQXd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 7 May 2015 12:23:33 -0400
Date: Thu, 7 May 2015 18:23:31 +0200
From: David Sterba <dsterba@suse.cz>
To: Christian <cdysthe@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Kernel 3.19 and btrfs
Message-ID: <20150507162331.GG23255@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <mig2nl$mrr$1@ger.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <mig2nl$mrr$1@ger.gmane.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 07, 2015 at 12:09:23PM -0400, Christian wrote:
> I am relying on btrfs on a couple of work laptops now and things seems 
> to work. I'm on Ubuntu 15.04. However, I've seen some horror stories 
> about problems with btrfs on this kernel version. Since Ubuntu 15.04 
> comes with 3.19 I'm a bit worried I am going to get in trouble at some 
> point. I'm not technical enough to understand what the threat level is.

The bug has been fixed in 3.19.5. The 3.19(.0) release itself is not
affected either.
