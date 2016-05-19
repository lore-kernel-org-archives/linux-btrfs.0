Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52996 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754019AbcESOvm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 19 May 2016 10:51:42 -0400
Date: Thu, 19 May 2016 16:51:12 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: Josef Bacik <jbacik@fb.com>, linux-btrfs@vger.kernel.org, dsterba@suse.cz,
        Lu Fengqi <lufq.fnst@cn.fujitsu.com>
Subject: Re: [RFC PATCH v2.1 16/16] btrfs-progs: fsck: Introduce low memory
 mode
Message-ID: <20160519145112.GF29147@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1463477930-3925-1-git-send-email-quwenruo@cn.fujitsu.com>
 <1463477930-3925-17-git-send-email-quwenruo@cn.fujitsu.com>
 <fa6160a4-64d2-9ce6-1c0d-eaf6069ca2c5@fb.com>
 <827a9e93-f525-4a8b-edb1-a0ac90175716@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <827a9e93-f525-4a8b-edb1-a0ac90175716@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 18, 2016 at 08:58:57AM +0800, Qu Wenruo wrote:
> Josef Bacik wrote on 2016/05/17 11:29 -0400:
> > On 05/17/2016 05:38 AM, Qu Wenruo wrote:
> >
> Thanks for the review.
> 
> I'll add it to github branch to avoid unneeded mail bombing.

Thanks.  I did one more pass and fixed the error messages and some minor
formatting. Branch merged in devel, any fixups, please send as separate
patches. I'd like to give enough time for testing, so ETA for 4.6 will
be the end of the next week.
