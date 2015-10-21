Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39212 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753367AbbJUJ2E (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 21 Oct 2015 05:28:04 -0400
Date: Wed, 21 Oct 2015 11:26:43 +0200
From: David Sterba <dsterba@suse.cz>
To: Eryu Guan <guaneryu@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 02/10] btrfs-progs: save error number correctly in
 check_chunks_and_extents
Message-ID: <20151021092643.GA13624@suse.cz>
Reply-To: dsterba@suse.cz
References: <1445254680-11102-1-git-send-email-guaneryu@gmail.com>
 <1445254680-11102-3-git-send-email-guaneryu@gmail.com>
 <20151019134104.GW27761@twin.jikos.cz>
 <20151020082451.GA3606@dhcp-13-216.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20151020082451.GA3606@dhcp-13-216.nay.redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Oct 20, 2015 at 06:28:00PM +0800, Eryu Guan wrote:
> On Mon, Oct 19, 2015 at 03:41:04PM +0200, David Sterba wrote:
> > On Mon, Oct 19, 2015 at 07:37:52PM +0800, Eryu Guan wrote:
> > > Coverity reports assigning value from "err" to "ret", but that stored
> > > value is overwritten by check_extent_refs() before it can be used.
> > 
> > If you fix a coverity issue, please add a tag and the id, like
> > 
> > Resolves-coverity-id: 1234
> 
> I was looking hard for CID but without luck.. I will ask around and see
> where I can find the CIDs.

Ok never mind then, I'll pick the patch as-is.
