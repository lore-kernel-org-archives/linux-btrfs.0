Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59566 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753203AbeGBJni (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 2 Jul 2018 05:43:38 -0400
Subject: Re: [PATCH RFC 0/3] btrfs-progs: lowmem: delay before lowmem repair
To: Su Yue <suy.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
References: <20180702092820.16285-1-suy.fnst@cn.fujitsu.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <93c08062-8368-616f-f8c6-5ff8616aad08@suse.com>
Date: Mon, 2 Jul 2018 12:43:20 +0300
MIME-Version: 1.0
In-Reply-To: <20180702092820.16285-1-suy.fnst@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On  2.07.2018 12:28, Su Yue wrote:
> Since lowmem repair is dangerous, it should remind user more obviously.
> The patchset add 10 seconds delay like btrfs balance and add am option
> '--force-repair-lowmem' to skip the delay.

IMO this is the wrong way to approach a dangerous option. If it's so
dangerous it needs to be written in the documentation explicitly this is
so. If someone wants to use lowmem then they should explicitly set
--mode lowmem. So I'm inclined to NACK this patch.

> 
> ---
> I don't whether it's a good idea to add delay and the option only for
> lowmem repair is acceptable, so make it RFC.
> 
> Su Yue (3):
>   btrfs-progs: lowmem: delay before lowmem repair starts
>   btrfs-progs: lowmem: force to start without delay with option
>     '--force-repair-lowmem'
>   btrfs-progs: tests: append '--force-repair-lowmem' if lowmem repair is
>     enabled
> 
>  check/main.c       | 43 ++++++++++++++++++++++++++++++++++++-------
>  tests/common.local |  1 +
>  2 files changed, 37 insertions(+), 7 deletions(-)
> 
