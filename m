Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49353 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750716AbcFAMeO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 1 Jun 2016 08:34:14 -0400
Date: Wed, 1 Jun 2016 14:33:34 +0200
From: David Sterba <dsterba@suse.cz>
To: dsterba@suse.cz, Feifei Xu <xufeifei@linux.vnet.ibm.com>,
        linux-btrfs@vger.kernel.org, steve.capper@linaro.org,
        chandan@mykolab.com, jbacik@fb.com, dsterba@suse.com,
        chandan@linux.vnet.ibm.com, feifeixu.sh@gmail.com
Subject: Re: [PATCH V2 5/8] Btrfs: self-tests: Support testing all possible
 sectorsizes and nodesizes
Message-ID: <20160601123334.GW29147@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <201606011120.u51BJXQB005621@mx0a-001b2d01.pphosted.com>
 <201606011120.u51BJVGc003246@mx0a-001b2d01.pphosted.com>
 <20160601122118.GV29147@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160601122118.GV29147@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 01, 2016 at 02:21:18PM +0200, David Sterba wrote:
> >  static int btrfs_run_sanity_tests(void)
> >  {
> > -	int ret;
> > +	int ret, i;
> >  	u32 sectorsize, nodesize;
> > -
> > -	sectorsize = PAGE_SIZE;
> > -	nodesize = PAGE_SIZE;
> 
> This does not seem to apply to any branch I'd expect to be relevant
> (master, for-linus, chandan's main patchset), please clarify.

Aha, sorry, this was in patch 3. BTW, please fix the mail threading so
the patches are replies to the cover letter. I fixed that manually in
mutt but did not add all the patches that arrived later.
