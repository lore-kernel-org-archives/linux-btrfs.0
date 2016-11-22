Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:55697 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1755807AbcKVT7r (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 22 Nov 2016 14:59:47 -0500
Subject: Re: [PATCH] Btrfs: adjust len of writes if following a preallocated
 extent
To: Liu Bo <bo.li.liu@oracle.com>, <linux-btrfs@vger.kernel.org>
References: <1478287254-5458-1-git-send-email-bo.li.liu@oracle.com>
CC: David Sterba <dsterba@suse.cz>
From: Chris Mason <clm@fb.com>
Message-ID: <f50c3464-bf8e-9dd9-658c-7f6b9652017b@fb.com>
Date: Tue, 22 Nov 2016 14:59:35 -0500
MIME-Version: 1.0
In-Reply-To: <1478287254-5458-1-git-send-email-bo.li.liu@oracle.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 11/04/2016 03:20 PM, Liu Bo wrote:
> If we have
>
> |0--hole--4095||4096--preallocate--12287|
>
> instead of using preallocated space, a 8K direct write will just
> create a new 8K extent and it'll end up with
>
> |0--new extent--8191||8192--preallocate--12287|
>
> It's because we find a hole em and then go to create a new 8K
> extent directly without adjusting @len.
>
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>

Reviewed-by: Chris Mason <clm@fb.com>

-chris
