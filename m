Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:13319 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751772AbcDZPzk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Apr 2016 11:55:40 -0400
Subject: Re: [PATCH v2 1/2] Btrfs: don't wait for unrelated IO to finish
 before relocation
To: <fdmanana@kernel.org>, <linux-btrfs@vger.kernel.org>
References: <1461685179-3957-1-git-send-email-fdmanana@kernel.org>
 <1461685179-3957-2-git-send-email-fdmanana@kernel.org>
From: Josef Bacik <jbacik@fb.com>
Message-ID: <6fbfc2d4-b0b9-bd63-cb29-b9eee635f16f@fb.com>
Date: Tue, 26 Apr 2016 11:55:20 -0400
MIME-Version: 1.0
In-Reply-To: <1461685179-3957-2-git-send-email-fdmanana@kernel.org>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 04/26/2016 11:39 AM, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
>
> Before the relocation process of a block group starts, it sets the block
> group to readonly mode, then flushes all delalloc writes and then finally
> it waits for all ordered extents to complete. This last step includes
> waiting for ordered extents destinated at extents allocated in other block
> groups, making us waste unecessary time.
>
> So improve this by waiting only for ordered extents that fall into the
> block group's range.
>
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Reviewed-by: Josef Bacik <jbacik@fb.com>

Thanks,

Josef
