Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:59047 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753778AbdDZSH1 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 26 Apr 2017 14:07:27 -0400
Subject: Re: [GIT PULL] Btrfs bug fixes for 4.12
To: <fdmanana@kernel.org>, <linux-btrfs@vger.kernel.org>
References: <20170426175241.32703-1-fdmanana@kernel.org>
CC: Filipe Manana <fdmanana@suse.com>
From: Chris Mason <clm@fb.com>
Message-ID: <295c0bef-7975-da30-d47b-e5dd9e2bddc0@fb.com>
Date: Wed, 26 Apr 2017 14:07:14 -0400
MIME-Version: 1.0
In-Reply-To: <20170426175241.32703-1-fdmanana@kernel.org>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 04/26/2017 01:52 PM, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
>
> Hi Chris,
>
> Please consider the following changes for the 4.12 merge window.
> These are all bug fixes and nothing particularly outstanding compared to
> changes for past merge windows.
>
> Thanks.
>
> The following changes since commit a967efb30b3afa3d858edd6a17f544f9e9e46eea:
>
>   Btrfs: fix potential use-after-free for cloned bio (2017-04-11 18:49:56 +0200)
>
> are available in the git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/fdmanana/linux.git for-chris-4.12
>
> for you to fetch changes up to a7e3b975a0f9296162b72ac6ab7fad9631a07630:
>
>   Btrfs: fix reported number of inode blocks (2017-04-26 16:27:26 +0100)
>
> ----------------------------------------------------------------
> Filipe Manana (5):
>       Btrfs: fix invalid attempt to free reserved space on failure to cow range
>       Btrfs: fix incorrect space accounting after failure to insert inline extent
>       Btrfs: fix extent map leak during fallocate error path
>       Btrfs: send, fix file hole not being preserved due to inline extent
>       Btrfs: fix reported number of inode blocks
>
> Qu Wenruo (2):
>       btrfs: Fix metadata underflow caused by btrfs_reloc_clone_csum error
>       btrfs: Handle delalloc error correctly to avoid ordered extent hang

Thanks Filipe, pulling this in.

-chris

