Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f172.google.com ([209.85.223.172]:56037 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751147Ab3KBIMK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 2 Nov 2013 04:12:10 -0400
Received: by mail-ie0-f172.google.com with SMTP id tp5so9179835ieb.31
        for <linux-btrfs@vger.kernel.org>; Sat, 02 Nov 2013 01:12:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <52742B59.3060405@friedels.name>
References: <52742B59.3060405@friedels.name>
Date: Sat, 2 Nov 2013 02:12:09 -0600
Message-ID: <CAE5mzvijfSOi9dP0MWCMd6=R5MW3bhabote4QYmFnqNEerDifw@mail.gmail.com>
Subject: Re: btrfsck errors is it save to fix?
From: cwillu <cwillu@cwillu.com>
To: Hendrik Friedel <hendrik@friedels.name>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> Now that I am searching, I see this in dmesg:
> [95764.899359]  [<ffffffffa00d9a59>] free_fs_root+0x99/0xa0 [btrfs]
> [95764.899384]  [<ffffffffa00dd653>] btrfs_drop_and_free_fs_root+0x93/0xc0
> [btrfs]
> [95764.899408]  [<ffffffffa00dd74f>] del_fs_roots+0xcf/0x130 [btrfs]
> [95764.899433]  [<ffffffffa00ddac6>] close_ctree+0x146/0x270 [btrfs]
> [95764.899461]  [<ffffffffa00b4eb9>] btrfs_put_super+0x19/0x20 [btrfs]
> [95764.899493]  [<ffffffffa00b754a>] btrfs_kill_super+0x1a/0x90 [btrfs]

Need to see the rest of the trace this came from.
