Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33233 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752568AbbKZRkg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 26 Nov 2015 12:40:36 -0500
Date: Thu, 26 Nov 2015 18:38:50 +0100
From: David Sterba <dsterba@suse.cz>
To: Austin S Hemmelgarn <ahferroin7@gmail.com>
Cc: Mike Fleetwood <mike.fleetwood@googlemail.com>,
        Anand Jain <anand.jain@oracle.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH v2 1/5] btrfs-progs: introduce framework to check kernel
 supported features
Message-ID: <20151126173850.GV31035@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1448283378-10579-1-git-send-email-anand.jain@oracle.com>
 <1448283378-10579-2-git-send-email-anand.jain@oracle.com>
 <CAMU1PDita6iet1xg97RfCDPWuVUaq=dYBO_eM3ZDQtvLRPcHCw@mail.gmail.com>
 <5654C6BF.8010502@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5654C6BF.8010502@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Nov 24, 2015 at 03:21:19PM -0500, Austin S Hemmelgarn wrote:
> > I think you mean 2.6.37 here.
> > 67377734fd24c3 "Btrfs: add support for mixed data+metadata block groups"
> This brings up a rather important question:
> Should compat-X.Y mean features that were considered usable in that 
> version, or everything that version offered?  I understand wanting 
> consistency with the kernel versions, but we shouldn't be creating 
> filesystems that we know will break on the specified kernel even if it 
> is mountable on it.

IMO compat refers to the compatibility feature bits so it's whether the
filesystem is mountable on a given version. Usability can be subjective.
I assume the kernel versions in wide use match some of the long term
branches. If it's k.org, we can submit the fixes and distros update
their long term branches.

A table of "is the feature usable" would be interesting but I think it's
for wiki.
