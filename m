Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail02.iobjects.de ([188.40.134.68]:38726 "EHLO
        mail02.iobjects.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750831AbdFGPsI (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 7 Jun 2017 11:48:08 -0400
Subject: Re: [PATCH 0/7] Btrfs: fix total_bytes_pinned counter
To: Omar Sandoval <osandov@osandov.com>, linux-btrfs@vger.kernel.org
Cc: Josef Bacik <jbacik@fb.com>, Liu Bo <bo.li.liu@oracle.com>,
        kernel-team@fb.com
References: <cover.1496792333.git.osandov@fb.com>
From: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>
Message-ID: <af6b94b7-3aa9-5bcb-df7e-01c21506a219@applied-asynchrony.com>
Date: Wed, 7 Jun 2017 17:48:05 +0200
MIME-Version: 1.0
In-Reply-To: <cover.1496792333.git.osandov@fb.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 06/07/17 01:45, Omar Sandoval wrote:
> From: Omar Sandoval <osandov@fb.com>
> 
> This series fixes several problems with the total_bytes_pinned counter.
> Patches 1 and 2 are cleanups. Patches 3 and 4 are straightforward fixes.
> Patch 5 is prep for patch 6. Patch 6 is the most complicated fix.
> Patches 5 and 6 are ugly, I'd love any suggestions for a cleaner fix.
> Finally, patch 7 adds a warning to catch similar issues in the future.

Since this didn't really change the code significantly from the previous
version (except for the addition of minor patches 2+7) have a

Tested-by: Holger Hoffstätte <holger@applied-asynchrony.com>

Thanks!
Holger
