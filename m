Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43198 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751465AbcEKEWh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 11 May 2016 00:22:37 -0400
Date: Tue, 10 May 2016 21:22:35 -0700
From: Mark Fasheh <mfasheh@suse.de>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>, btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: About in-band dedupe for v4.7
Message-ID: <20160511042235.GG7633@wotan.suse.de>
Reply-To: Mark Fasheh <mfasheh@suse.de>
References: <aae84f04-cb64-46f3-79ea-f2d84d79a3ba@cn.fujitsu.com>
 <20160511003758.e3hy5v3lwbtethjl@floor.thefacebook.com>
 <a8fdf4f2-4b3c-7c17-1709-55ae61888f94@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <a8fdf4f2-4b3c-7c17-1709-55ae61888f94@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 11, 2016 at 09:40:51AM +0800, Qu Wenruo wrote:
> 
> 
> Chris Mason wrote on 2016/05/10 20:37 -0400:
> >On Tue, May 10, 2016 at 03:19:52PM +0800, Qu Wenruo wrote:
> >>Hi, Chris, Josef and David,
> >>
> >>As merge window for v4.7 is coming, it would be good to hear your ideas
> >>about the inband dedupe.
> >>
> >>We are addressing the ENOSPC problem which Josef pointed out, and we believe
> >>the final fix patch would come out at the beginning of the merge
> >>window.(Next week)
> >>
> >>
> >>If it's fine, would you please consider to merge the in-memory backend
> >>patchset for v4.7 as an experimental feature?
> >>
> >>
> >>Most of the patch won't be changed from v10 patchset, only ENOSPC fix will
> >>be updated, and ioctl patchset will introduce a new Kconfig option of "btrfs
> >>experimental features" for inband dedupe.
> >>(With explain about unstable ioctl/on-disk format for experimental features)
> >>
> >>
> >>If you are all OK to merge inband dedupe in-memory backend, I'll prepare the
> >>new v11 patchset for this merge.
> >
> >We have to balance the part where we really want the features to come
> >in, and we want to lower the load on you to continue porting them.  But,
> >I really do agree that we need strong test suites included with every
> >major feature like this.
> >
> >-chris
> >
> >
> That's fine.
> 
> We're running all generic and btrfs test case with dedupe enabled,
> by modifying xfstest to call "btrfs dedeup enable" just after mount,
> to ensure dedupe won't corrupt any existing test case.

As Satoru mentioned, this is something that everybody needs to be able to
run. I would also like to see some basic analysis done on write-heavy
workloads. I think it's fair to understand what sort of impact this will
have on the write path.
	--Mark

--
Mark Fasheh
