Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:40373 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1761226AbcINH1g (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 14 Sep 2016 03:27:36 -0400
From: Anand Jain <anand.jain@oracle.com>
Subject: Re: [PATCH 02/13] btrfs: Do per-chunk check for mount time check
To: Hugo Mills <hugo@carfax.org.uk>, linux-btrfs@vger.kernel.org,
        dsterba@suse.cz, yauhen.kharuzhy@zavadatar.com,
        Qu Wenruo <quwenruo@cn.fujitsu.com>
References: <1462889372-5274-1-git-send-email-anand.jain@oracle.com>
 <1462889372-5274-4-git-send-email-anand.jain@oracle.com>
 <20160912214940.GG7138@carfax.org.uk>
Message-ID: <433fe3cb-8f7d-3d71-a8c3-e25e3a6af11d@oracle.com>
Date: Wed, 14 Sep 2016 15:29:04 +0800
MIME-Version: 1.0
In-Reply-To: <20160912214940.GG7138@carfax.org.uk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 09/13/2016 05:49 AM, Hugo Mills wrote:
>    What happened to these patches? (Particularly the per-chunk
> degraded checks).

   Per-chunk degraded-check patch helps to workaround the issue.
   Which is needed to test hotspare support.
   The final fix for the same is..
     [RFC] btrfs: create degraded-RAID1 chunks
   which needs more review.

Thanks, Anand

> We've just had someone on IRC who could have used
> the capability...
>
>    Hugo.


