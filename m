Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:49789 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932804AbbELPEa (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 May 2015 11:04:30 -0400
Date: Tue, 12 May 2015 17:04:26 +0200
From: David Sterba <dsterba@suse.cz>
To: Paul Jones <paul@pauljones.id.au>
Cc: sam tygier <samtygier@yahoo.co.uk>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs-progs: check metadata redundancy
Message-ID: <20150512150426.GA23255@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <mi2sgj$urs$1@ger.gmane.org>
 <20150505145432.GG5099@twin.jikos.cz>
 <mibc2f$a9$1@ger.gmane.org>
 <B7F2379062E32745A8651FBDB20F645954A286B3@Server.waterlogic.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <B7F2379062E32745A8651FBDB20F645954A286B3@Server.waterlogic.com.au>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 06, 2015 at 03:40:12AM +0000, Paul Jones wrote:
> I would appreciate being able to use the DUP profile for data on a
> single disk - at the moment I just resort to partitioning the disk in
> two and creating a raid1.

As you can read elsewhere, it's possible with the mixed profiles and
AFAICT this will be the only way for the forseeable future.
