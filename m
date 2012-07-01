Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:52269 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754385Ab2GAJlg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 1 Jul 2012 05:41:36 -0400
Received: by pbbrp8 with SMTP id rp8so6341260pbb.19
        for <linux-btrfs@vger.kernel.org>; Sun, 01 Jul 2012 02:41:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAEH94Lht_TcBFa1qvO1-pz12GsdfH05xnYMC-smKLOFPP2HydA@mail.gmail.com>
References: <CAEH94Lht_TcBFa1qvO1-pz12GsdfH05xnYMC-smKLOFPP2HydA@mail.gmail.com>
Date: Sun, 1 Jul 2012 10:41:35 +0100
Message-ID: <CAMU1PDgEokfvoCREVwB9O4Mm0Po=9UdFau3W2D0nZhhf2oWNsw@mail.gmail.com>
Subject: Re: btrfs_print_tree?
From: Mike Fleetwood <mike.fleetwood@googlemail.com>
To: Zhi Yong Wu <zwu.kernel@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 1 July 2012 05:53, Zhi Yong Wu <zwu.kernel@gmail.com> wrote:
> HI,
>
> Do anyone know where btrfs_print_tree is invoked? thanks.
>
> --
> Regards,
>
> Zhi Yong Wu

Is this the answer you are after?

$ grep -r btrfs_print_tree fs/btrfs/
fs/btrfs/print-tree.c:void btrfs_print_tree(struct btrfs_root *root,
struct extent_buffer *c)
fs/btrfs/print-tree.c:		btrfs_print_tree(root, next);
fs/btrfs/print-tree.h:void btrfs_print_tree(struct btrfs_root *root,
struct extent_buffer *t);

Mike
