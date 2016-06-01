Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:56783 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754672AbcFANk1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 1 Jun 2016 09:40:27 -0400
Date: Wed, 1 Jun 2016 09:40:20 -0400
From: Chris Mason <clm@fb.com>
To: <fdmanana@kernel.org>
CC: <linux-btrfs@vger.kernel.org>, Filipe Manana <fdmanana@suse.com>
Subject: Re: [GIT PULL] Device replace fixes
Message-ID: <20160601134020.tpzolop7pglkyjuf@floor.thefacebook.com>
References: <1464781453-13536-1-git-send-email-fdmanana@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1464781453-13536-1-git-send-email-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 01, 2016 at 12:44:13PM +0100, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> Hi Chris,
> 
> Please consider the following device replace related fixes for inclusion
> in a future 4.7 release candidate kernel. These were all previously sent
> to the mailing list and reviewed by Josef (and I recently rebased them
> against your for-linus-4.7 branch). They mostly fix crashes, invalid
> memory accesses and data/metadata loss (some extents, or entire block
> groups, end up not being copied from the source device into the target
> device).
> 
> Thanks.

Thanks Filipe, I had most of these queued up, but I'll just pull instead
and retest.

-chris
