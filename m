Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:18788 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751166AbcFWSdA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 23 Jun 2016 14:33:00 -0400
Subject: Re: [PULL] Btrfs updates for 4.7-rc5
To: David Sterba <dsterba@suse.com>
References: <cover.1466678869.git.dsterba@suse.com>
CC: <linux-btrfs@vger.kernel.org>
From: Chris Mason <clm@fb.com>
Message-ID: <6fdb096c-d3f8-dc85-3a17-f8cf63506c4b@fb.com>
Date: Thu, 23 Jun 2016 14:32:11 -0400
MIME-Version: 1.0
In-Reply-To: <cover.1466678869.git.dsterba@suse.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 06/23/2016 06:56 AM, David Sterba wrote:
> Hi,
>
> this is hopefully the last pull for 4.7 from me. There are two fixes that
> should finalize the changes introduced in this dev cycle, plus some minor
> independent fixes.
>
> The following changes since commit 33688abb2802ff3a230bd2441f765477b94cc89e:
>
>   Linux 4.7-rc4 (2016-06-19 21:30:02 -0700)
>
> are available in the git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-chris
>
> for you to fetch changes up to 917b187d467d87ed8d75b3d2084d906845ed126a:
>
>   Btrfs: Force stripesize to the value of sectorsize (2016-06-23 12:16:01 +0200)
>
> ----------------------------------------------------------------
> Chandan Rajendra (1):
>       Btrfs: Force stripesize to the value of sectorsize
>
> Liu Bo (1):
>       Btrfs: fix error handling in map_private_extent_buffer
>
> Omar Sandoval (1):
>       Btrfs: fix ->iterate_shared() by upgrading i_rwsem for delayed nodes

Thanks Dave, I do have these integrated but I had to update Omar's patch 
to re-enable the iterate_shared call.  Since Al reverted the btrfs usage 
of iterate_shared, Omar's code was giving the vfs layer an inode without 
the write lock held.

-chris
