Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:55327 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750969AbcIBNgB (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 2 Sep 2016 09:36:01 -0400
Subject: Re: [PATCH] btrfs: let btrfs_delete_unused_bgs() to clean relocated
 bgs
To: Naohiro Aota <naohiro.aota@hgst.com>, <linux-btrfs@vger.kernel.org>
References: <1472802392-10851-1-git-send-email-naohiro.aota@hgst.com>
CC: Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>,
        <linux-kernel@vger.kernel.org>
From: Josef Bacik <jbacik@fb.com>
Message-ID: <b5c2852a-fe0a-834e-0fcd-2b61b5c47088@fb.com>
Date: Fri, 2 Sep 2016 09:35:31 -0400
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

This seems racey to me.  We remove the last part of the block group, it ends up 
on the unused_bgs_list, we process this list, see that removed isn't set and we 
skip it, then later we set removed, but it's too late.  I think the right way is 
to actually do a transaction, set ->removed, manually add it to the 
unused_bgs_list if it's not already, then end the transaction.  This way we are 
guaranteed to have the bg on the list when it is ready to be removed.  This is 
my analysis after looking at it for 10 seconds after being awake for like 30 
minutes so if I'm missing something let me know.  Thanks,

Josef
