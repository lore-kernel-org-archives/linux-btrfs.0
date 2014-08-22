Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55873 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756423AbaHVPcJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 Aug 2014 11:32:09 -0400
Message-ID: <53F7627D.3060405@redhat.com>
Date: Fri, 22 Aug 2014 10:32:13 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: Liu Bo <bo.li.liu@oracle.com>, linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v2] Btrfs: fix crash on endio of reading corrupted block
References: <1408462393-3291-1-git-send-email-bo.li.liu@oracle.com> <1408524679-13583-1-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1408524679-13583-1-git-send-email-bo.li.liu@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 8/20/14, 3:51 AM, Liu Bo wrote:
> The crash is
> 
> ------------[ cut here ]------------
> kernel BUG at fs/btrfs/extent_io.c:2124!
> invalid opcode: 0000 [#1] SMP

...

> ---
> v2:
>    - Improve the commit log to be clear, suggested by Eric.

Well, I had specifically asked for it to include details on when
the regression occurred, but didn't get that...  ;)

If you state that it's a regression, people may start wondering
if their kernels are vulnerable, how far back into -stable it
should go, which distros should pick up the fix, etc.  If you
don't say when it regressed, we're all left wondering...

Thanks,

-Eric

