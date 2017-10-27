Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:39527 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751167AbdJ0EV4 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 27 Oct 2017 00:21:56 -0400
Date: Thu, 26 Oct 2017 21:17:36 -0700
From: Liu Bo <bo.li.liu@oracle.com>
To: Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: What is the purpose of EXTENT_PAGE_MAPPED
Message-ID: <20171027041736.GA18058@lim.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <f8f92f68-7ea9-e08e-bb4c-602616d46813@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <f8f92f68-7ea9-e08e-bb4c-602616d46813@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Oct 24, 2017 at 05:47:11AM -0500, Goldwyn Rodrigues wrote:
> 
> EXTENT_PAGE_MAPPED gets set in set_page_extent_mapped(), but I don't see
> it being cross checked anytime. What is the purpose of setting it?

Please check commit d1310b2e0cd98eb1348553e69b73827b436dca7b, it was
used to differentiate page for metadata and for data, but I think
currently it's just a piece of legacy code.

-liubo
