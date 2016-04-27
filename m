Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60342 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752288AbcD0RSv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Apr 2016 13:18:51 -0400
Date: Wed, 27 Apr 2016 19:18:38 +0200
From: David Sterba <dsterba@suse.cz>
To: Josef Bacik <jbacik@fb.com>
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, linux-btrfs@vger.kernel.org,
        dsterba@suse.cz, clm@fb.com, chandan@mykolab.com
Subject: Re: [PATCH V18 00/18] Allow I/O on blocks whose size is less than
 page size
Message-ID: <20160427171838.GM29353@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1461677237-7703-1-git-send-email-chandan@linux.vnet.ibm.com>
 <e8e4fc53-93ee-cd46-474d-02fe935802ea@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <e8e4fc53-93ee-cd46-474d-02fe935802ea@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Apr 26, 2016 at 11:22:14AM -0400, Josef Bacik wrote:
> > TODO:
> > 1. The selftests code needs to be fixed to work in subpage-blocksize
> >    scenario. I have currently disabled self-tests from my kernel
> >    configuration. We can expect an mail from kbuild indicating a
> >    build failure for self-tests code.
> > 2. I am planning to fix Scrub & Compression via a separate patchset.
> >
> 
> The selftests need to pass, I don't want to have to deal with kbuild 
> failures and have to remember it's because selftests don't work right 
> with sub page blocksizes.  Thanks,

Agreed. The deal is that the default case must not be affected by the
patchset.
