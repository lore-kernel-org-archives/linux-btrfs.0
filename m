Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.fusionio.com ([66.114.96.30]:60520 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752254Ab2LSPaA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 19 Dec 2012 10:30:00 -0500
Date: Wed, 19 Dec 2012 10:29:25 -0500
From: Josef Bacik <jbacik@fusionio.com>
To: Rock Lee <zimilo@code-trick.com>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: HIT WARN_ON WARNING: at fs/btrfs/extent-tree.c:6339
 btrfs_alloc_free_block+0x126/0x330 [btrfs]()
Message-ID: <20121219152925.GC4033@localhost.localdomain>
References: <CAMRmmp+=YT_-KdGHRWo5GrofiSnkZB_xVpN1Z8Jp4xgo0fVS3A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <CAMRmmp+=YT_-KdGHRWo5GrofiSnkZB_xVpN1Z8Jp4xgo0fVS3A@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Dec 19, 2012 at 08:12:01AM -0700, Rock Lee wrote:
> Hi all,
> 
>     Did someone have met this problem before. When doing the tests, I hit
> 
> the WARN_ON. Is this log make sense or someone had fixed the problem.
> 
>  If needed, I can supply the detail log and the testcase source file.
> 
>  Version: the latest codes at linus git tree.
>

If you can give me your testcase I will love you forever.  Thanks,

Josef 
