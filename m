Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwkm02.jp.fujitsu.com ([202.219.69.169]:45397 "EHLO
        mgwkm02.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726659AbeGaDZh (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 30 Jul 2018 23:25:37 -0400
Received: from g01jpfmpwkw02.exch.g01.fujitsu.local (g01jpfmpwkw02.exch.g01.fujitsu.local [10.0.193.56])
        by kw-mxoi2.gw.nic.fujitsu.com (Postfix) with ESMTP id 173F0AC010D
        for <linux-btrfs@vger.kernel.org>; Tue, 31 Jul 2018 10:47:42 +0900 (JST)
Subject: Re: [PATCH 0/2] btrfs-progs: completion: Small fixes to make debug
 simpler
To: Qu Wenruo <wqu@suse.com>, <linux-btrfs@vger.kernel.org>
References: <20180717061532.11857-1-wqu@suse.com>
From: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
Message-ID: <f8bc239c-3884-7f61-51d0-3b2b83806d67@jp.fujitsu.com>
Date: Tue, 31 Jul 2018 10:47:32 +0900
MIME-Version: 1.0
In-Reply-To: <20180717061532.11857-1-wqu@suse.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is useful.

Reviewed-by: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>

On 2018/07/17 15:15, Qu Wenruo wrote:
> For developer, it's pretty common to use "btrfs check" or "btrfs ins
> dump-tree" on raw dumps.
> 
> However "btrfs check" can only complete real block devices, and
> "btrfs inspect dump-tree" can only complete dir.
> 
> Make them to use _filedir() so any filename can be completed and save us
> developer a little time and nerve hitting that holy tab.
> 
> Qu Wenruo (2):
>   btrfs-progs: completion: Use _filedir() to replace _btrfs_devs()
>   btrfs-progs: completion: Let dump-tree/dump-super/inode-resolve to
>     accept any file
> 
>  btrfs-completion | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 

