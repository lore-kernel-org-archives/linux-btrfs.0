Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp2.provo.novell.com ([137.65.250.81]:39362 "EHLO
        smtp2.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756059AbcI1CTh (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Tue, 27 Sep 2016 22:19:37 -0400
Subject: Re: [PATCH] qgroup: Prevent qgroup->reserved from going subzero
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, Goldwyn Rodrigues <rgoldwyn@suse.de>,
        linux-btrfs@vger.kernel.org
References: <1474570050-4715-1-git-send-email-rgoldwyn@suse.de>
 <a5707357-38d1-f2c3-41cf-b9d76bd992a3@cn.fujitsu.com>
 <628e1dcd-ddc3-3f37-8a47-c01c912db970@suse.com>
 <65e6515c-a9f3-d5f9-db6b-3ffd8d97f90e@cn.fujitsu.com>
 <0e892f0a-22b3-0fd7-ac8f-d52b76b4d4af@suse.de>
 <1274b3b2-d196-ee9e-2261-d2f5cb906477@cn.fujitsu.com>
 <2a9a3890-3f32-f175-b4aa-becf7caabb7f@suse.de>
 <cb81e839-1040-0942-3206-fa6acd9ee547@cn.fujitsu.com>
From: Goldwyn Rodrigues <rgoldwyn@suse.com>
Message-ID: <3ef8e20a-d671-7691-d964-014f35299703@suse.com>
Date: Tue, 27 Sep 2016 21:19:34 -0500
MIME-Version: 1.0
In-Reply-To: <cb81e839-1040-0942-3206-fa6acd9ee547@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 09/27/2016 08:44 PM, Qu Wenruo wrote:

<snipped>

> Finally reproduced it.
> 
> Although in a low chance, about 1/10.
> 
> Under most case, the final remove gets executed without error.

Change 50m to 500m while setting the qgroup limit, the probability will
increase.

-- 
Goldwyn
