Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:48619 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750948Ab3HBOKi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 2 Aug 2013 10:10:38 -0400
Date: Fri, 2 Aug 2013 16:10:31 +0200
From: David Sterba <dsterba@suse.cz>
To: Chris Murphy <lists@colorremedies.com>
Cc: Florian Lindner <mailinglists@xgm.de>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Questions about multi-device behavior
Message-ID: <20130802141031.GB5284@suse.cz>
Reply-To: dsterba@suse.cz
References: <1860433.azE0Vf7tMy@horus>
 <20130718173337.GN24343@twin.jikos.cz>
 <CCB92795-C346-467B-B85F-D5CB5C401B77@colorremedies.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CCB92795-C346-467B-B85F-D5CB5C401B77@colorremedies.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 18, 2013 at 02:05:31PM -0600, Chris Murphy wrote:
> 
> On Jul 18, 2013, at 11:33 AM, David Sterba <dsterba@suse.cz> wrote:
> 
> > 
> > The missing data blocks return IO error and the valid data can be read.
> 
> Sounds like if I have a degraded 'single' volume, I can simply cp or
> rsync everything from that volume to another, and I'll end up with a
> successful copy of the surviving data. True?

True.
