Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f175.google.com ([209.85.220.175]:46445 "EHLO
        mail-qk0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933636AbeAIQJo (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 9 Jan 2018 11:09:44 -0500
Received: by mail-qk0-f175.google.com with SMTP id l12so18792817qke.13
        for <linux-btrfs@vger.kernel.org>; Tue, 09 Jan 2018 08:09:44 -0800 (PST)
Date: Tue, 9 Jan 2018 11:09:42 -0500
From: Josef Bacik <josef@toxicpanda.com>
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-btrfs@vger.kernel.org, quwenruo.btrfs@gmx.com, dsterba@suse.cz
Subject: Re: [RFC PATCH] btrfs: Fix slight df misreporting when listing mixed
 block groups fs
Message-ID: <20180109160941.d7hcuodg5n4aqkk5@destiny>
References: <1515513845-3749-1-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1515513845-3749-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jan 09, 2018 at 06:04:05PM +0200, Nikolay Borisov wrote:
> Currently when df (resp. statfs) is executed on a btrfs instance the
> free space is calculated as the freespace of the block groups +
> any unallocated space on the devices, constituting this filesystem.
> There is a catch, however, in that the unallocated space from the
> devices has 1 mb subtracted from each device to closely follow btrfs'
> allocator behavior. This is all good except that when we have a file
> system and the system chunk's allocation profile is single (as is the
> default in mixed mode) it occupies the range 0..4mb and thus implicitly
> prevents allocation starting in the range 0..1mb. In those cases
> additionally subtracting 1mb during statfs makes us misreport the
> actual free space and this causes generic/015 to fail.
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>

This is fine by me,

Reviewed-by: Josef Bacik <jbacik@fb.com>

Thanks,

Josef
