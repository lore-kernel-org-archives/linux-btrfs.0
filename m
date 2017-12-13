Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwkm01.jp.fujitsu.com ([202.219.69.168]:61689 "EHLO
        mgwkm01.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750886AbdLMBkR (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 12 Dec 2017 20:40:17 -0500
Received: from g01jpfmpwkw01.exch.g01.fujitsu.local (g01jpfmpwkw01.exch.g01.fujitsu.local [10.0.193.38])
        by kw-mxauth.gw.nic.fujitsu.com (Postfix) with ESMTP id 5CA1BAC00AC
        for <linux-btrfs@vger.kernel.org>; Wed, 13 Dec 2017 10:40:11 +0900 (JST)
Subject: Re: [PATCH 2/2] btrfs-progs: doc: remove explanation of 'X' attribute
To: <dsterba@suse.cz>, linux-btrfs <linux-btrfs@vger.kernel.org>
References: <6dabbe1b-87a2-77cd-4fca-9835a1573961@jp.fujitsu.com>
 <93de4c81-b80e-068c-3f4b-30860febc7fe@jp.fujitsu.com>
 <20171212183714.GQ3553@twin.jikos.cz>
From: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>
Message-ID: <2bd317a6-a33f-702d-7f89-a54e83c17e31@jp.fujitsu.com>
Date: Wed, 13 Dec 2017 10:40:05 +0900
MIME-Version: 1.0
In-Reply-To: <20171212183714.GQ3553@twin.jikos.cz>
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

1st patch requires btrfs/048's output to be modified.
If the patch is Ok, I will update the xfstest.

Thanks,
Tomohiro

On 2017/12/13 3:37, David Sterba wrote:
> On Tue, Dec 12, 2017 at 04:08:17PM +0900, Misono, Tomohiro wrote:
>> e2fsprogs has removed compression support since v1.43 and there is no field
>> 'X' (no compress) for lxattr now. So, just remove the explanation.
> 
> Hm right, I hoped that we could export the NOCOMP flag through
> lsattr/chattr, but this relied on a compile-time compression support of
> e2fsprogs.
> 
> 

