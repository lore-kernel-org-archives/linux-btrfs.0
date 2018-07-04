Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40404 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932386AbeGDFyU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 4 Jul 2018 01:54:20 -0400
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 7553DADC9
        for <linux-btrfs@vger.kernel.org>; Wed,  4 Jul 2018 05:54:19 +0000 (UTC)
Subject: Re: [PATCH 1/5] btrfs: tree-checker: Verify block_group_item
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20180703091009.16399-1-wqu@suse.com>
 <20180703091009.16399-2-wqu@suse.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <a2ce3e7c-ef70-123f-426b-6f4c0945e793@suse.com>
Date: Wed, 4 Jul 2018 08:54:17 +0300
MIME-Version: 1.0
In-Reply-To: <20180703091009.16399-2-wqu@suse.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On  3.07.2018 12:10, Qu Wenruo wrote:
> A crafted image with invalid block group items could make free space cache
> code to cause panic.
> 
> We could early detect such invalid block group item by checking:
> 1) Item size
>    Fixed value.
> 2) Block group size (key.offset)
>    We have a up limit on block group item (10G)
> 3) Chunk objectid
>    Fixed value.
> 4) Type
>    Only 4 valid type values, DATA, METADATA, SYSTEM and DATA|METADATA.
>    No more than 1 bit set for profile type.
> 5) Used space
>    No more than block group size.
> 
> This should allow btrfs to detect and refuse to mount the crafted image.
> 
> Link: https://bugzilla.kernel.org/show_bug.cgi?id=199849
> Reported-by: Xu Wen <wen.xu@gatech.edu>
> Signed-off-by: Qu Wenruo <wqu@suse.com>

Reviewed-by: Nikolay Borisov <nborisov@suse.com>
