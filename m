Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:58850 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S932343AbcKNTcz (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 14 Nov 2016 14:32:55 -0500
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.17/8.16.0.17) with SMTP id uAEJVeYL026895
        for <linux-btrfs@vger.kernel.org>; Mon, 14 Nov 2016 11:32:54 -0800
Received: from maileast.thefacebook.com ([199.201.65.23])
        by m0001303.ppops.net with ESMTP id 26qkgf80d6-1
        (version=TLSv1 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NOT)
        for <linux-btrfs@vger.kernel.org>; Mon, 14 Nov 2016 11:32:54 -0800
Subject: Re: [PATCH 1/2] Btrfs: fix file extent corruption
To: Josef Bacik <jbacik@fb.com>, <linux-btrfs@vger.kernel.org>,
        <kernel-team@fb.com>
References: <1479150382-19273-1-git-send-email-jbacik@fb.com>
From: Chris Mason <clm@fb.com>
Message-ID: <63a3b645-8555-5d9f-545e-c8ff2eeefebb@fb.com>
Date: Mon, 14 Nov 2016 14:32:43 -0500
MIME-Version: 1.0
In-Reply-To: <1479150382-19273-1-git-send-email-jbacik@fb.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 11/14/2016 02:06 PM, Josef Bacik wrote:
> In order to do hole punching we have a block reserve to hold the reservation we
> need to drop the extents in our range.  Since we could end up dropping a lot of
> extents we set rsv->failfast so we can just loop around again and drop the
> remaining of the range.  Unfortunately we unconditionally fill the hole extents
> in and start from the last extent we encountered, which we may or may not have
> dropped.  So this can result in overlapping file extent entries, which can be
> tripped over in a variety of ways, either by hitting BUG_ON(!ret) in
> fill_holes() after the search, or in btrfs_set_item_key_safe() in
> btrfs_drop_extent() at a later time by an unrelated task.  Fix this by only
> setting drop_end to the last extent we did actually drop.  This way our holes
> are filled in properly for the range that we did drop, and the rest of the range
> that remains to be dropped is actually dropped.  Thanks,
>
> Signed-off-by: Josef Bacik <jbacik@fb.com>

Thanks for tracking this down Josef.  We should mark it for stable too.

-chris
