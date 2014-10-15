Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:28542 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751298AbaJOTFO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 15 Oct 2014 15:05:14 -0400
Message-ID: <543EC561.8000200@fb.com>
Date: Wed, 15 Oct 2014 15:05:05 -0400
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: Filipe Manana <fdmanana@gmail.com>, <fstests@vger.kernel.org>
CC: <linux-btrfs@vger.kernel.org>, Filipe Manana <fdmanana@suse.com>
Subject: Re: [PATCH] fstests: btrfs: regression test for ro snapshot creation
References: <1413398276-17365-1-git-send-email-fdmanana@suse.com>
In-Reply-To: <1413398276-17365-1-git-send-email-fdmanana@suse.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 10/15/2014 02:37 PM, Filipe Manana wrote:
> Regression test for a btrfs issue where creation of readonly snapshots caused
> the filesystem to get into an inconsistent state.
>
> This regression was introduced in the 3.17 kernel and fixed by reverting the
> following linux kernel commit:
>
>       Btrfs: race free update of commit root for ro snapshots
>       9c3b306e1c9e6be4be09e99a8fe2227d1005effc
>
> Signed-off-by: Filipe Manana <fdmanana@suse.com>
> ---
>   tests/btrfs/078     | 85 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>   tests/btrfs/078.out |  2 ++
>   tests/btrfs/group   |  1 +
>   3 files changed, 88 insertions(+)
>   create mode 100755 tests/btrfs/078
>   create mode 100644 tests/btrfs/078.out
>

Reviewed-by: Josef Bacik <jbacik@fb.com>

Thanks,

Josef

