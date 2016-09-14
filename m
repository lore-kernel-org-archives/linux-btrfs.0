Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.3]:49769 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755489AbcINKs6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 14 Sep 2016 06:48:58 -0400
From: Heinz Werner Kramski-Grote <kramski@web.de>
To: linux-btrfs@vger.kernel.org, quwenruo@cn.fujitsu.com
Subject: Re: Unable to repair "bad key order": Cyclic bad block flip-flop
Date: Wed, 14 Sep 2016 12:48:49 +0200
Message-ID: <2645291.NjGXSRg41N@haspl>
In-Reply-To: <6c6c8a43-e443-f6ce-4778-24398d118c9b@cn.fujitsu.com>
References: <4818221.8fBhXcTYy5@sandl.hnstr58.local> <6c6c8a43-e443-f6ce-4778-24398d118c9b@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Dienstag, 13. September 2016 08:39:27 CEST Qu Wenruo wrote:

> You could try using backup roots to avoid corrupted tree root.
> And it may also fix your extent tree.
> ---
> # btrfs-show-super -f
> ...
> backup_roots[4]:
> 	backup 0:
> 		backup_tree_root:	31932416	gen: 10	level: 0
> 		backup_chunk_root:	20971520	gen: 7	level: 0
[...]
> 
> That "backup_tree_root" is what you're looking for.
> 
> And use btrfsck with "-r <backup_tree_root_bytenr>" to check if the bad
> order problem disappear.

Thanks, Qu, but this did not help (tried all four positions).

Will do a clean setup.

Regards,
   Heinz



