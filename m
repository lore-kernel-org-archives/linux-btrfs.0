Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33288 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751115AbcAORkL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 15 Jan 2016 12:40:11 -0500
Date: Fri, 15 Jan 2016 18:40:07 +0100
From: David Sterba <dsterba@suse.cz>
To: Christian Rohmann <crohmann@netcologne.de>
Cc: linux-btrfs@vger.kernel.org, gabriel@system.is
Subject: Re: [PATCH 2/3] btrfs: add balance filter for stripes
Message-ID: <20160115174007.GG4227@suse.cz>
Reply-To: dsterba@suse.cz
References: <cover.1445360598.git.dsterba@suse.com>
 <aa6771ad37b6cd5370bccebfe525bd654f0d8a30.1445360598.git.dsterba@suse.com>
 <5697C69B.1000308@netcologne.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5697C69B.1000308@netcologne.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jan 14, 2016 at 05:02:35PM +0100, Christian Rohmann wrote:
> 
> 
> On 10/20/2015 07:13 PM, David Sterba wrote:
> > Balance block groups which have the given number of stripes, defined by
> > a range min..max. This is useful to selectively rebalance only chunks
> > that do not span enough devices, applies to RAID0/10/5/6.
> 
> This sounds like an awesome improvement to re-balance a filesystem with
> newly added devices which don't have any data chunks yet. So in theory
> for RAID6 I would simple need to execute
> 
>  btrfs balance start -dstripes=0..$devicecount-1 /filesystem
> 
> 
> to have btrfs balance those chunks which are not spread across all
> devices yet?

Exactly.
