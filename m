Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:48619 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1757987AbdAEQZI (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 5 Jan 2017 11:25:08 -0500
Subject: Re: [PULL] Btrfs fixes for 4.10
To: David Sterba <dsterba@suse.com>
References: <cover.1483629310.git.dsterba@suse.com>
CC: <linux-btrfs@vger.kernel.org>
From: Chris Mason <clm@fb.com>
Message-ID: <f06e8daf-6aaa-1086-e433-c71425f9d7e4@fb.com>
Date: Thu, 5 Jan 2017 11:24:40 -0500
MIME-Version: 1.0
In-Reply-To: <cover.1483629310.git.dsterba@suse.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 01/05/2017 10:22 AM, David Sterba wrote:
> Hi,
>
> a collection of fixes (lockdep, delayed ref locking, dio). The
> btrfs_uuid_tree_iterate return value fix has a visible impact so it's added to
> the mix. Please pull.
>
> The following changes since commit 2939e1a86f758b55cdba73e29397dd3d94df13bc:
>
>   btrfs: limit async_work allocation and worker func duration (2016-12-13 11:01:30 -0800)
>
> are available in the git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-chris-4.10
>
> for you to fetch changes up to 3dda13a8ad787f3d4c4f18c8c05f8eebc7ea135a:
>
>   Merge branch 'misc-4.10' into for-chris-4.10-20170104 (2017-01-04 11:42:16 +0100)

Thanks Dave, testing started here.

-chris
