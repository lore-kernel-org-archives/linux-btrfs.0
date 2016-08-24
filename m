Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:25613 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1755497AbcHXVPq (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 24 Aug 2016 17:15:46 -0400
Date: Wed, 24 Aug 2016 17:14:20 -0400
From: Chris Mason <clm@fb.com>
To: David Sterba <dsterba@suse.com>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: [PULL] Btrfs fixes, part 3
Message-ID: <20160824211419.GA81111@clm-mbp.thefacebook.com>
References: <cover.1472045668.git.dsterba@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
In-Reply-To: <cover.1472045668.git.dsterba@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Aug 24, 2016 at 03:42:54PM +0200, David Sterba wrote:
>Hi,
>
>this pull request contains part 2 and adds more that arrived in the meantime
>(new fixes or updated versions of patches). Assorted fixes. Please pull,
>thanks.

Thanks Dave, since this patch got turned into a v2:

      Btrfs: handle pending renames with recycled inodes properly

I shuffled things a bit to leave it out.

-chris
