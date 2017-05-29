Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59480 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751000AbdE2PAE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 29 May 2017 11:00:04 -0400
Date: Mon, 29 May 2017 16:59:03 +0200
From: David Sterba <dsterba@suse.cz>
To: dsterba@suse.cz, Liu Bo <bo.li.liu@oracle.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 06/10] btrfs: scrub: use bool for flush_all_writes
Message-ID: <20170529145903.GK14523@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1494954480.git.dsterba@suse.com>
 <0d4dcd2dd113cdff9141336e583ab5afacfeee6f.1494954480.git.dsterba@suse.com>
 <20170519004224.GK23822@lim.localdomain>
 <20170519130822.GU4065@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170519130822.GU4065@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 19, 2017 at 03:08:22PM +0200, David Sterba wrote:
> On Thu, May 18, 2017 at 05:42:24PM -0700, Liu Bo wrote:
> > On Tue, May 16, 2017 at 07:10:38PM +0200, David Sterba wrote:
> > > flush_all_writes is an atomic but does not use the semantics at all,
> > > it's just on/off indicator, we can use bool.
> > > 
> > 
> > It might use atomic to avoid reordering, but I'm not sure if
> > reordering could really happen here.
> 
> Ok, I'll have a look. It does not seem to rely on atomics/ordering though.

The semantics of atomic_t to not lose concurrent increment/decrement is
not used here. The variable is always used within the following patterns:

	set to 1
	submit writes
	wait for completion
	set to 0

or

	if set: submit writes

The potential ordering issues, eg. when the worker thread that just
reads the value will not see the value 1 from other thread would need to
keep the state out of sync overal several mutex lock/unlock calls, that
imply a barrier anyway.
