Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail1.arhont.com ([178.248.108.111]:50430 "EHLO
        mail1.arhont.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933200AbeAON51 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 15 Jan 2018 08:57:27 -0500
Date: Mon, 15 Jan 2018 13:57:23 +0000 (GMT)
From: "Konstantin V. Gavrilenko" <k.gavrilenko@arhont.com>
To: Linux fs Btrfs <linux-btrfs@vger.kernel.org>
Cc: Roman Mamedov <rm@romanrm.net>
Message-ID: <6077373.226.1516024638372.JavaMail.gkos@dynomob>
In-Reply-To: <20180113013749.5338c057@natsu>
References: <20055256.49.1515779377187.JavaMail.gkos@dynomob> <20180113013749.5338c057@natsu>
Subject: Re: btrfs subvolume mount with different options
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thanks, chattr +C is that's what I am currently using.
Also you already answered my next question, why it is not possible to set +C attribute on the existing file :)


Yours sincerely,
Konstantin V. Gavrilenko


----- Original Message -----
From: "Roman Mamedov" <rm@romanrm.net>
To: "Konstantin V. Gavrilenko" <k.gavrilenko@arhont.com>
Cc: "Linux fs Btrfs" <linux-btrfs@vger.kernel.org>
Sent: Friday, 12 January, 2018 9:37:49 PM
Subject: Re: btrfs subvolume mount with different options

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
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
