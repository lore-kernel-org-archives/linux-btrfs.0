Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:39671 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752921Ab3BAR65 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 1 Feb 2013 12:58:57 -0500
Date: Fri, 1 Feb 2013 18:58:55 +0100
From: David Sterba <dsterba@suse.cz>
To: Martin Steigerwald <Martin@lichtvoll.de>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: Integration branch of btrfs-progs 2013-01-30
Message-ID: <20130201175855.GD23239@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20130130002427.GD30535@twin.jikos.cz>
 <201301312017.13704.Martin@lichtvoll.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <201301312017.13704.Martin@lichtvoll.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jan 31, 2013 at 08:17:13PM +0100, Martin Steigerwald wrote:
> Hope the extended free space information stuff by Goffredo comes next :)

The code needs some work, and I'm not sure where the dicusssions about
the visual appearance of the output ended. I don't remember whether we
had a generally accepted version.

I've pulled and rebased the patches from Goffredo's repo, based on some
recent snapshot of integration branch, see foreign/fi-df-merge2 .


david
