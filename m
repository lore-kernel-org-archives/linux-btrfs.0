Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:56008 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965618Ab3DPXRQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 16 Apr 2013 19:17:16 -0400
Date: Tue, 16 Apr 2013 16:17:15 -0700
From: Mark Fasheh <mfasheh@suse.de>
To: Marek Otahal <markotahal@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/4] [RFC] btrfs: offline dedupe
Message-ID: <20130416231715.GI24720@wotan.suse.de>
Reply-To: Mark Fasheh <mfasheh@suse.de>
References: <1366150535-18750-1-git-send-email-mfasheh@suse.de> <2164102.vSxPIH87oQ@beruska>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <2164102.vSxPIH87oQ@beruska>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Apr 17, 2013 at 12:50:04AM +0200, Marek Otahal wrote: could you
> compare (appart from online/offline) your implementation to LiuBo's work?,
> appeared on ML a while ago:
> http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg23656.html

Well that's the primary difference. Liu Bo's patch requires a format change
also since it's done online. My patch requires no format change. So they're
complimentary approaches in my opinion.

There's also the possibility that some other file systems could pick up the
ioctl. Ocfs2 in particular should be able to.


> It would be interesting if the two approaches could share some code, and
> also confirmation that using one technique does not disregard using the
> other in future.

Both features can exist together and probably should, I can see great uses
for both cases.

I haven't looked at the patches but with respect to code sharing I'll take a
look. My patches don't actually add any custom code for the actual "let's
de-dupe this extent" as I re-use the code from btrfs_ioctl_clone().
	--Mark

--
Mark Fasheh
