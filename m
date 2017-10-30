Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47320 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751663AbdJ3NVy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 30 Oct 2017 09:21:54 -0400
Subject: Re: What is the purpose of EXTENT_PAGE_MAPPED
To: bo.li.liu@oracle.com, Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc: linux-btrfs@vger.kernel.org
References: <f8f92f68-7ea9-e08e-bb4c-602616d46813@suse.de>
 <20171027041736.GA18058@lim.localdomain>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <0f6ac8d3-af9b-c3f9-0d52-e3214306af6a@suse.com>
Date: Mon, 30 Oct 2017 15:21:51 +0200
MIME-Version: 1.0
In-Reply-To: <20171027041736.GA18058@lim.localdomain>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 27.10.2017 07:17, Liu Bo wrote:
> On Tue, Oct 24, 2017 at 05:47:11AM -0500, Goldwyn Rodrigues wrote:
>>
>> EXTENT_PAGE_MAPPED gets set in set_page_extent_mapped(), but I don't see
>> it being cross checked anytime. What is the purpose of setting it?
> 
> Please check commit d1310b2e0cd98eb1348553e69b73827b436dca7b, it was
> used to differentiate page for metadata and for data, but I think
> currently it's just a piece of legacy code.

Be that as it may - is there any reason why we are keeping this and can
it be killed off?

> 
> -liubo
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
