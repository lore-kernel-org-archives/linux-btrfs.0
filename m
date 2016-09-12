Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail02.iobjects.de ([188.40.134.68]:41554 "EHLO
        mail02.iobjects.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932467AbcILITT (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 12 Sep 2016 04:19:19 -0400
Subject: Re: [PATCH v3] btrfs: should block unused block groups deletion work
 when allocating data space
To: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org,
        Naohiro Aota <naohiro.aota@hgst.com>
References: <20160909081748.26540-1-wangxg.fnst@cn.fujitsu.com>
 <pan$db9b8$41125892$42517798$e874738e@applied-asynchrony.com>
 <57D29579.1080700@applied-asynchrony.com> <57D65B6C.4030400@cn.fujitsu.com>
From: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>
Message-ID: <57D66500.8090207@applied-asynchrony.com>
Date: Mon, 12 Sep 2016 10:19:12 +0200
MIME-Version: 1.0
In-Reply-To: <57D65B6C.4030400@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 09/12/16 09:38, Wang Xiaoguang wrote:
<snip>
>> Actually even that is not true; both patches seem to be wrong in subtle
>> ways. Naohiro's patch seems to prevent the deletion during balance, whereas
>> yours prevents the cleaner from kicking in.
> Indeed in my patch, I just change "struct mutex delete_unused_bgs_mutex"
> to "struct rw_semaphore bg_delete_sem", and try to get bg_delete_sem when
> we allocate data space, so this patch should work as before :)
> 
>>
>> As a simple reproducer you can convert from -mdup to -msingle (to create
>> bloat) and then balance with -musage=10. Depending on which of the two
>> patches are applied, you end with bloat that only grows and never shrinks,
>> or bloat that ends up in mixed state (dup and single).
> Can you give me a simple test script to reproduce your problem.
> (I can write it myself, but I'm afraid I may misunderstand you :) )

I don't have a script and no time this week to play with this.
Just create an fs with dup metadata, balance -mconvert=single and then
back with -mconvert=dup. That's all I tried.

Holger

