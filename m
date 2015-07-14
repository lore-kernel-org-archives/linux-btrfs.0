Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:9955 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751767AbbGNA6R (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 13 Jul 2015 20:58:17 -0400
Date: Mon, 13 Jul 2015 20:58:10 -0400
From: Chris Mason <clm@fb.com>
To: <fdmanana@kernel.org>
CC: <linux-btrfs@vger.kernel.org>, Filipe Manana <fdmanana@suse.com>
Subject: Re: [GIT PULL] More btrfs bug fixes
Message-ID: <20150714005810.GF17513@ret.masoncoding.com>
References: <1436665847-31883-1-git-send-email-fdmanana@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1436665847-31883-1-git-send-email-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Jul 12, 2015 at 02:50:47AM +0100, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> Hi Chris,
> 
> Please consider the following changes for the kernel 4.2 release. All
> these patches have been available in the mailing list for some time.
> 
> One of the patches is a fix for a regression in the delayed references
> code that landed in 4.2-rc1. Two of them are for issues reported by users
> on the list and IRC recently (which I've cc'ed for stable) and the final
> one is just a missing update of an inode's on disk size after truncating
> a file if the no_holes feature is enabled, which I found some time ago.
> 
> I have rebased them on top of your current integration-4.2 branch,
> re-tested them and incorporated any tags people have added through the
> mailing list (Reviewed-by, Acked-by).
> 

Thanks Filipe, I've pulled these in along with a few more.  I'll test
overnight and push out in the morning.

-chris
