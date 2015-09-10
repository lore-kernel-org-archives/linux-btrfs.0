Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:7027 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751835AbbIJNBM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 10 Sep 2015 09:01:12 -0400
Date: Thu, 10 Sep 2015 09:01:05 -0400
From: Chris Mason <clm@fb.com>
To: <fdmanana@kernel.org>
CC: <linux-btrfs@vger.kernel.org>, Filipe Manana <fdmanana@suse.com>
Subject: Re: [PATCH] Btrfs: remove unnecessary locking of cleaner_mutex to
 avoid deadlock
Message-ID: <20150910130105.GI9511@ret.masoncoding.com>
References: <1441881041-10992-1-git-send-email-fdmanana@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1441881041-10992-1-git-send-email-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Sep 10, 2015 at 11:30:41AM +0100, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> This issue was discussed (in the mailing list) during the review of
> the patch titled "btrfs: explictly delete unused block groups in
> close_ctree and ro-remount" and it was agreed that acquiring the
> cleaner mutex had to be dropped after the patch titled
> "Btrfs: fix race between balance and unused block group deletion"
> got merged (both patches were submitted at about the same time, but
> one landed in kernel 4.2 and the other in the 4.3 merge window).

Thanks Filipe, hit the lockdep warning and was going to dig this out.

-chris
