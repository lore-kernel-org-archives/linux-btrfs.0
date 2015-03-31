Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwkm04.jp.fujitsu.com ([202.219.69.171]:52309 "EHLO
	mgwkm04.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753353AbbCaIiX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 31 Mar 2015 04:38:23 -0400
Received: from m3051.s.css.fujitsu.com (m3051.s.css.fujitsu.com [10.134.21.209])
	by kw-mxoi2.gw.nic.fujitsu.com (Postfix) with ESMTP id C4664AC00D0
	for <linux-btrfs@vger.kernel.org>; Tue, 31 Mar 2015 17:27:14 +0900 (JST)
Message-ID: <551A5A2F.6010609@jp.fujitsu.com>
Date: Tue, 31 Mar 2015 17:26:23 +0900
From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
MIME-Version: 1.0
To: Zhaolei <zhaolei@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: wait for delayed iputs on no space
References: <cover.1427450911.git.zhaolei@cn.fujitsu.com>
In-Reply-To: <cover.1427450911.git.zhaolei@cn.fujitsu.com>
Content-Type: text/plain; charset=iso-2022-jp
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2015/03/27 19:21, Zhaolei wrote:
> From: Zhao Lei <zhaolei@cn.fujitsu.com>
> 
> This is another fix of no_space case.
> 
> All patchs for fix no_space bug are available at fix_no_space
> branch on:
>    git://github.com/zhaoleidd/btrfs

I tested in the environment that applied the following patch to
'fix_no_space' branch.
 - Btrfs: fix find_free_dev_extent() malfunction in case device tree has hole

It works fine to me. Thanks.

Tested-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>

> 
> Any suggestions are welcome.
> 
> Zhao Lei (1):
>    btrfs: wait for delayed iputs on no space
> 
>   fs/btrfs/extent-tree.c | 3 +++
>   1 file changed, 3 insertions(+)
> 

