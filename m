Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:57072 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751602AbaLSJ1t (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 19 Dec 2014 04:27:49 -0500
Received: from kw-mxauth.gw.nic.fujitsu.com (unknown [10.0.237.134])
	by fgwmail6.fujitsu.co.jp (Postfix) with ESMTP id 2173B3EE0B6
	for <linux-btrfs@vger.kernel.org>; Fri, 19 Dec 2014 18:27:48 +0900 (JST)
Received: from s2.gw.fujitsu.co.jp (s2.gw.fujitsu.co.jp [10.0.50.92])
	by kw-mxauth.gw.nic.fujitsu.com (Postfix) with ESMTP id 2AEDBAC0948
	for <linux-btrfs@vger.kernel.org>; Fri, 19 Dec 2014 18:27:47 +0900 (JST)
Received: from g01jpfmpwyt03.exch.g01.fujitsu.local (g01jpfmpwyt03.exch.g01.fujitsu.local [10.128.193.57])
	by s2.gw.fujitsu.co.jp (Postfix) with ESMTP id CABE9E18004
	for <linux-btrfs@vger.kernel.org>; Fri, 19 Dec 2014 18:27:46 +0900 (JST)
Received: from g01jpexchyt38.g01.fujitsu.local (unknown [10.128.193.4])
	by g01jpfmpwyt03.exch.g01.fujitsu.local (Postfix) with ESMTP id C786046E491
	for <linux-btrfs@vger.kernel.org>; Fri, 19 Dec 2014 18:27:45 +0900 (JST)
Message-ID: <5493EF88.8020200@jp.fujitsu.com>
Date: Fri, 19 Dec 2014 18:27:36 +0900
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
MIME-Version: 1.0
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 0/5] Cleanup warnings from clang
References: <1418969592-21278-1-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1418969592-21278-1-git-send-email-quwenruo@cn.fujitsu.com>
Content-Type: text/plain; charset="iso-2022-jp"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

On 2014/12/19 15:13, Qu Wenruo wrote:
> Cleanup warning when compile btrfs-progs with clang.
> 
> Clang analyser also reports about 60+ errors, but it will be another
> patchset fixing it later.
> 
> Qu Wenruo (5):
>    btrfs-progs: Makefile: Move linker only option to LDFLAGS
>    btrfs-progs: Fix a clang dead-judgement warning in disk-io.c.
>    btrfs-progs: Remove a unused function root_gtp_mask().
>    btrfs-progs: Remove a unused function offset_to_bitmap()
>    btrfs-progs: Remove deprecated _BSD_SOURCE macro.

All these patches looks good to me.

Reviewed-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>

Thanks,
Satoru

> 
>   Makefile           |  3 ++-
>   cmds-receive.c     |  2 +-
>   disk-io.c          |  9 ++++++---
>   free-space-cache.c | 16 ----------------
>   radix-tree.c       |  5 -----
>   5 files changed, 9 insertions(+), 26 deletions(-)
> 

