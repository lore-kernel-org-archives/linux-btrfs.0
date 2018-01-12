Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from len.romanrm.net ([91.121.75.85]:60164 "EHLO len.romanrm.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965105AbeALUhv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 12 Jan 2018 15:37:51 -0500
Date: Sat, 13 Jan 2018 01:37:49 +0500
From: Roman Mamedov <rm@romanrm.net>
To: "Konstantin V. Gavrilenko" <k.gavrilenko@arhont.com>
Cc: Linux fs Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs subvolume mount with different options
Message-ID: <20180113013749.5338c057@natsu>
In-Reply-To: <20055256.49.1515779377187.JavaMail.gkos@dynomob>
References: <20055256.49.1515779377187.JavaMail.gkos@dynomob>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 12 Jan 2018 17:49:38 +0000 (GMT)
"Konstantin V. Gavrilenko" <k.gavrilenko@arhont.com> wrote:

> Hi list,
> 
> just wondering whether it is possible to mount two subvolumes with different mount options, i.e.
> 
> |
> |- /a  defaults,compress-force=lza

You can have use different compression algorithms across the filesystem
(including none), via "btrfs properties" on directories or subvolumes. They
are inherited down the tree.

$ mkdir test
$ sudo btrfs prop set test compression zstd
$ echo abc > test/def
$ sudo btrfs prop get test/def compression
compression=zstd

But it appears this doesn't provide a way to apply compress-force.

> |- /b  defaults,nodatacow

Nodatacow can be applied to any dir/subvolume recursively, or any file (as long as it's created but not
written yet) via chattr +C.

-- 
With respect,
Roman
