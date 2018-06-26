Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwkm04.jp.fujitsu.com ([202.219.69.171]:25255 "EHLO
        mgwkm04.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934562AbeFZAvJ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 25 Jun 2018 20:51:09 -0400
Received: from g01jpfmpwyt03.exch.g01.fujitsu.local (g01jpfmpwyt03.exch.g01.fujitsu.local [10.128.193.57])
        by kw-mxoi1.gw.nic.fujitsu.com (Postfix) with ESMTP id 41B4FAC0211
        for <linux-btrfs@vger.kernel.org>; Tue, 26 Jun 2018 09:51:01 +0900 (JST)
Subject: Re: [PATCH] btrfs: Use iocb to derive pos instead of passing a
 separate parameter
To: <dsterba@suse.cz>, Goldwyn Rodrigues <rgoldwyn@suse.de>,
        <linux-btrfs@vger.kernel.org>, Goldwyn Rodrigues <rgoldwyn@suse.com>
References: <20180617173947.818-1-rgoldwyn@suse.de>
 <5678d4d9-cc58-e07f-9592-07caa4deb59b@jp.fujitsu.com>
 <20180625162037.GG27958@twin.jikos.cz>
From: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
Message-ID: <c626b0ca-6c4e-dfe4-6eb5-08220c1fd0b4@jp.fujitsu.com>
Date: Tue, 26 Jun 2018 09:50:53 +0900
MIME-Version: 1.0
In-Reply-To: <20180625162037.GG27958@twin.jikos.cz>
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2018/06/26 1:20, David Sterba wrote:
> On Mon, Jun 25, 2018 at 01:58:58PM +0900, Misono Tomohiro wrote:
>> So, this is the updated version of https://patchwork.kernel.org/patch/10063039/
>>
>> This time xfstest is ok and
>>  Reviewed-by: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
> 
> Your comment about invalidate_mapping_pages is also ok, right? As
> filemap_fdatawait_range and invalidate_mapping_pages use the same
> start/end of the range.
> 

This time local variable 'pos' is kept to have the same value before and
invalidate_mapping_pages() uses it, so it should be ok.

