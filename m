Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37377 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753199AbcE0LS5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 27 May 2016 07:18:57 -0400
Date: Fri, 27 May 2016 13:18:22 +0200
From: David Sterba <dsterba@suse.cz>
To: Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PULL] Btrfs for 4.7, part 2
Message-ID: <20160527111822.GV29147@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1464254502.git.dsterba@suse.com>
 <20160527001414.opeu5ffezblckpd4@floor.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160527001414.opeu5ffezblckpd4@floor.thefacebook.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 26, 2016 at 08:14:14PM -0400, Chris Mason wrote:
> On Thu, May 26, 2016 at 11:27:06AM +0200, David Sterba wrote:
> > Hi,
> > 
> > please pull a few more patches that did not go to pull #1 for 4.7, minor
> > cleanups and fixes. Thanks.
> 
> Thanks Dave!  Trying to figure out why we're failing btrfs/011, but I
> don't see how it could be related to this bunch.  I'll nail it down.

011 passes here, there are some unrelated soft-failures (mismatching
output with new progs). I'm now testing a branch without "btrfs: scrub:
Set bbio to NULL before calling btrfs_map_block", that seems to be the
only likely offender.
