Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwkm04.jp.fujitsu.com ([202.219.69.171]:38613 "EHLO
        mgwkm04.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1422849AbeCBIWD (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 2 Mar 2018 03:22:03 -0500
Received: from g01jpfmpwyt02.exch.g01.fujitsu.local (g01jpfmpwyt02.exch.g01.fujitsu.local [10.128.193.56])
        by kw-mxoi1.gw.nic.fujitsu.com (Postfix) with ESMTP id 3D306AC0149
        for <linux-btrfs@vger.kernel.org>; Fri,  2 Mar 2018 17:22:00 +0900 (JST)
Subject: Re: [PATCH 5/5] btrfs: Show more accurate max_inline
To: Qu Wenruo <wqu@suse.com>, <linux-btrfs@vger.kernel.org>
CC: <dsterba@suse.cz>
References: <20180302052254.7059-1-wqu@suse.com>
 <20180302052254.7059-6-wqu@suse.com>
From: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>
Message-ID: <51d4f512-364d-61f5-be5b-4f996d82249e@jp.fujitsu.com>
Date: Fri, 2 Mar 2018 17:21:24 +0900
MIME-Version: 1.0
In-Reply-To: <20180302052254.7059-6-wqu@suse.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2018/03/02 14:22, Qu Wenruo wrote:
> Btrfs shows max_inline option into kernel message, but for
> max_inline=4096, btrfs won't really inline 4096 bytes inline data if
> it's not compressed.

Hello,
I have a question.

man mount(8) says: 
   max_inline=bytes
          Specify  the  maximum  amount  of space, in bytes, that can be
          inlined in a metadata B-tree leaf.  The value is specified  in
          bytes,  optionally with a K, M, or G suffix, case insensitive.
          In practice, this value is limited by the  root  sector  size,
          with  some  space  unavailable  due to leaf headers.  For a 4k
          sectorsize, max inline data is ~3900 bytes.

So, is the size of 4k-(size of leaf header) actually the maximum value
of max_inline instead of 4095 for 4k sectorsize?

Thanks,

