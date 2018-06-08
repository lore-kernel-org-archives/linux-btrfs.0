Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwym03.jp.fujitsu.com ([211.128.242.42]:46844 "EHLO
        mgwym03.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752326AbeFHAng (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 7 Jun 2018 20:43:36 -0400
Received: from g01jpfmpwkw02.exch.g01.fujitsu.local (g01jpfmpwkw02.exch.g01.fujitsu.local [10.0.193.56])
        by yt-mxauth.gw.nic.fujitsu.com (Postfix) with ESMTP id 51F90AC0365
        for <linux-btrfs@vger.kernel.org>; Fri,  8 Jun 2018 09:43:31 +0900 (JST)
Subject: Re: [PATCH] btrfs-progs: check: Initialize all filed of
 btrfs_inode_item in insert_inode_item()
To: <dsterba@suse.cz>, linux-btrfs <linux-btrfs@vger.kernel.org>
References: <cover.1528339598.git.misono.tomohiro@jp.fujitsu.com>
 <a9e2495c-6085-4efb-5257-f58a5019e2b7@jp.fujitsu.com>
 <20180607122246.GB3215@twin.jikos.cz>
From: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
Message-ID: <56d8305a-8d52-49ad-fdff-61269e01192a@jp.fujitsu.com>
Date: Fri, 8 Jun 2018 09:43:04 +0900
MIME-Version: 1.0
In-Reply-To: <20180607122246.GB3215@twin.jikos.cz>
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2018/06/07 21:22, David Sterba wrote:
> On Thu, Jun 07, 2018 at 11:49:58AM +0900, Misono Tomohiro wrote:
>> Initialize all filed of btrfs_inode_item to zero in order to prevent
>> having some garbage, especially for flags field.
> 
> Have you observed in practice or is it a matter of precaution?

I saw failure of fsck-test/010 in yesterday's devel branch and
made this patch. It turned out that root cause was wrong flag comparison
in btrfs check.
(https://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg77758.html)

With Su's fix, failure of fsck-test/010 is also gone without this patch,
but it is better to initialize the variables anyway.

