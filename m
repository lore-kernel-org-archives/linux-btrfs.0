Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwkm01.jp.fujitsu.com ([202.219.69.168]:22112 "EHLO
        mgwkm01.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753183AbeGBIRy (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 2 Jul 2018 04:17:54 -0400
Received: from g01jpfmpwyt03.exch.g01.fujitsu.local (g01jpfmpwyt03.exch.g01.fujitsu.local [10.128.193.57])
        by kw-mxauth.gw.nic.fujitsu.com (Postfix) with ESMTP id 0B989AC00CD
        for <linux-btrfs@vger.kernel.org>; Mon,  2 Jul 2018 17:17:49 +0900 (JST)
Subject: Re: Enabling quota may not correctly rescan on 4.17
To: Nikolay Borisov <nborisov@suse.com>, Qu Wenruo <quwenruo.btrfs@gmx.com>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>
References: <0ced0e29-9ecc-01fb-b0a5-9de32966666e@jp.fujitsu.com>
 <bceb24d5-fa2f-b019-fc60-146fa7a62844@gmx.com>
 <9f158a77-fb11-1b77-d67a-e64f42e67e51@jp.fujitsu.com>
 <fd81f784-4c2e-5911-421a-39738c99177f@gmx.com>
 <50806075-6faa-db22-1508-450c5d5b6e34@jp.fujitsu.com>
 <80e72414-325c-61f1-a466-d5aaafe2a65b@suse.com>
From: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
Message-ID: <d0dc55a2-4eb9-bf1d-d69f-7c9b28fd4a9b@jp.fujitsu.com>
Date: Mon, 2 Jul 2018 17:15:38 +0900
MIME-Version: 1.0
In-Reply-To: <80e72414-325c-61f1-a466-d5aaafe2a65b@suse.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> Misono,
> 
> Can you please try the attached patch?
> 

I tried and it works (on 4.18.0-rc3).

Committing transaction before starting rescan worker is
what btrfs_qgroup_resan() does, so it looks fine. 

(though I'm not sure why you don't see the problem in your machine.)

Reviewed-by: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
Thanks.

