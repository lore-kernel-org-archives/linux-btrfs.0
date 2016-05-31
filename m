Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:30721 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753676AbcEaNah (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 31 May 2016 09:30:37 -0400
Subject: Re: [PATCH 2/2] Btrfs: fix race between device replace and read
 repair
To: <fdmanana@kernel.org>, <linux-btrfs@vger.kernel.org>
References: <1464621576-20234-1-git-send-email-fdmanana@kernel.org>
 <1464621576-20234-2-git-send-email-fdmanana@kernel.org>
CC: Filipe Manana <fdmanana@suse.com>
From: Josef Bacik <jbacik@fb.com>
Message-ID: <6ddbd753-66df-859d-b7c8-472388d39554@fb.com>
Date: Tue, 31 May 2016 09:30:21 -0400
MIME-Version: 1.0
In-Reply-To: <1464621576-20234-2-git-send-email-fdmanana@kernel.org>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 05/30/2016 11:19 AM, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
>
> While we are finishing a device replace operation we can have a concurrent
> task trying to do a read repair operation, in which case it will call
> btrfs_map_block() to get a struct btrfs_bio which can have a stripe that
> points to the source device of the device replace operation. This allows
> for the read repair task to dereference the stripe's device pointer after
> the device replace operation has freed the source device, resulting in
> an invalid memory access. This is similar to the problem solved by my
> previous patch in the same series and named "Btrfs: fix race between
> device replace and discard".
>
> So fix this by surrounding the call to btrfs_map_block() and the code
> that uses the returned struct btrfs_bio with calls to
> btrfs_bio_counter_inc_blocked() and btrfs_bio_counter_dec(), giving the
> proper serialization with the finishing phase of the device replace
> operation.
>
> Signed-off-by: Filipe Manana <fdmanana@suse.com>
> ---

Reviewed-by: Josef Bacik <jbacik@fb.com>

Thanks,

Josef

