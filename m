Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:57495 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751522AbcJJVQ2 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 10 Oct 2016 17:16:28 -0400
Subject: Re: [PATCH] btrfs: let btrfs_delete_unused_bgs() to clean relocated
 bgs
To: Naohiro Aota <naohiro.aota@hgst.com>, <linux-btrfs@vger.kernel.org>
References: <1472802392-10851-1-git-send-email-naohiro.aota@hgst.com>
CC: Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>,
        <linux-kernel@vger.kernel.org>
From: Chris Mason <clm@fb.com>
Message-ID: <7ac97eed-6bc1-3b23-38cf-89c5eda49f23@fb.com>
Date: Mon, 10 Oct 2016 17:04:03 -0400
MIME-Version: 1.0
In-Reply-To: <1472802392-10851-1-git-send-email-naohiro.aota@hgst.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 09/02/2016 03:46 AM, Naohiro Aota wrote:
> Currently, btrfs_relocate_chunk() is removing relocated BG by itself. But
> the work can be done by btrfs_delete_unused_bgs() (and it's better since it
> trim the BG). Let's dedupe the code.
>
> While btrfs_delete_unused_bgs() is already hitting the relocated BG, it
> skip the BG since the BG has "ro" flag set (to keep balancing BG intact).
> On the other hand, btrfs cannot drop "ro" flag here to prevent additional
> writes. So this patch make use of "removed" flag.
> btrfs_delete_unused_bgs() now detect the flag to distinguish whether a
> read-only BG is relocating or not.
>
> Signed-off-by: Naohiro Aota <naohiro.aota@hgst.com>

This runs into trouble with btrfs_rm_device(), I've been triggering 
crashes with btrfs/101 here.

The problem is that by the time we get around to running 
btrfs_delete_unused_bgs(), btrfs_rm_device() has long since free'd the 
device.

I thought about calling btrfs_delete_unused_bgs() directly from 
btrfs_rm_device(), but it might bail out without returning an error for 
a number of reasons.

For now, I've reverted this patch from the pull, but we can bring it 
back once the device removal path is covered.

-chris
