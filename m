Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:30826 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752773AbbGARZO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 1 Jul 2015 13:25:14 -0400
Date: Wed, 1 Jul 2015 13:24:41 -0400
From: Chris Mason <clm@fb.com>
To: <fdmanana@kernel.org>
CC: <linux-btrfs@vger.kernel.org>, Filipe Manana <fdmanana@suse.com>
Subject: Re: [GIT PULL] Btrfs bug fixes
Message-ID: <20150701172441.GG23627@ret.masoncoding.com>
References: <1435702831-25334-1-git-send-email-fdmanana@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1435702831-25334-1-git-send-email-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jun 30, 2015 at 11:20:31PM +0100, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> Hi Chris,
> 
> Please consider the following changes (or a subset at your will in case
> they are too many or too large) for the kernel 4.2 release. All these
> patches have been available in the mailing list for at least 2 weeks.
> 
> They are all bug fixes and deal with races, crashes, memory corruption,
> hangs and data loss on fsync. No cleanups, refactorings or other cosmetic
> changes that don't affect users, except for a change that updates a
> comment added in a change that was already sent to Linus (but that can
> hardly introduce any regression).

Thanks! These are queued along with a few others I pulled from the list,
Mark's dedup fixes, and the ones Qu mentioned.  Once it passes tests
here I'll push out.

-chris
