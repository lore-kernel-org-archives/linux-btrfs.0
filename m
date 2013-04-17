Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:27366 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750948Ab3DQECP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 17 Apr 2013 00:02:15 -0400
Date: Wed, 17 Apr 2013 12:00:48 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Mark Fasheh <mfasheh@suse.de>
Cc: Marek Otahal <markotahal@gmail.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/4] [RFC] btrfs: offline dedupe
Message-ID: <20130417040046.GA28313@liubo.jp.oracle.com>
Reply-To: bo.li.liu@oracle.com
References: <1366150535-18750-1-git-send-email-mfasheh@suse.de>
 <2164102.vSxPIH87oQ@beruska>
 <20130416231715.GI24720@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130416231715.GI24720@wotan.suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Apr 16, 2013 at 04:17:15PM -0700, Mark Fasheh wrote:
> On Wed, Apr 17, 2013 at 12:50:04AM +0200, Marek Otahal wrote: could you
> > compare (appart from online/offline) your implementation to LiuBo's work?,
> > appeared on ML a while ago:
> > http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg23656.html
> 
> Well that's the primary difference. Liu Bo's patch requires a format change
> also since it's done online. My patch requires no format change. So they're
> complimentary approaches in my opinion.
> 
> There's also the possibility that some other file systems could pick up the
> ioctl. Ocfs2 in particular should be able to.
> 
> 
> > It would be interesting if the two approaches could share some code, and
> > also confirmation that using one technique does not disregard using the
> > other in future.
> 
> Both features can exist together and probably should, I can see great uses
> for both cases.
> 
> I haven't looked at the patches but with respect to code sharing I'll take a
> look. My patches don't actually add any custom code for the actual "let's
> de-dupe this extent" as I re-use the code from btrfs_ioctl_clone().

In online dedup, I just make some changes in write path, as we regard dedup as a
special kind of compression, doing dedup as compression way is the goal.

The difference is where hash database is -- offline dedup puts it in userspace
while online dedup in kernel.

Although there might be no code that can be shared here, I agree that both
online and offline one are useful.

Good job.

thanks,
liubo
