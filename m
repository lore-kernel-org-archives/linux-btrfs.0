Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f42.google.com ([209.85.160.42]:60437 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752714Ab2LSP1g (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 19 Dec 2012 10:27:36 -0500
Received: by mail-pb0-f42.google.com with SMTP id rp2so1296938pbb.1
        for <linux-btrfs@vger.kernel.org>; Wed, 19 Dec 2012 07:27:36 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAMRmmp+=YT_-KdGHRWo5GrofiSnkZB_xVpN1Z8Jp4xgo0fVS3A@mail.gmail.com>
References: <CAMRmmp+=YT_-KdGHRWo5GrofiSnkZB_xVpN1Z8Jp4xgo0fVS3A@mail.gmail.com>
Date: Wed, 19 Dec 2012 09:27:36 -0600
Message-ID: <CAE5mzvhic3XdqHnLdwFMw2S=h2hG5hx2NwvQ3gU539P8ELEy_Q@mail.gmail.com>
Subject: Re: HIT WARN_ON WARNING: at fs/btrfs/extent-tree.c:6339
 btrfs_alloc_free_block+0x126/0x330 [btrfs]()
From: cwillu <cwillu@cwillu.com>
To: Rock Lee <zimilo@code-trick.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Dec 19, 2012 at 9:12 AM, Rock Lee <zimilo@code-trick.com> wrote:
> Hi all,
>
>     Did someone have met this problem before. When doing the tests, I hit
>
> the WARN_ON. Is this log make sense or someone had fixed the problem.
>
>  If needed, I can supply the detail log and the testcase source file.

That'd be good, as well as the specific kernel version.
