Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:51320 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755420Ab2JXJ6r convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 24 Oct 2012 05:58:47 -0400
Received: by mail-lb0-f174.google.com with SMTP id n3so941712lbo.19
        for <linux-btrfs@vger.kernel.org>; Wed, 24 Oct 2012 02:58:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <507AA0E7.30706@petaramesh.org>
References: <507AA0E7.30706@petaramesh.org>
Date: Wed, 24 Oct 2012 11:58:45 +0200
Message-ID: <CAOcd+r1Gt5XoPuRB3vyDak21xNFufCLvfATbFvCyt3foq4RfJw@mail.gmail.com>
Subject: Re: inode_cache
From: Alex Lyakas <alex.btrfs@zadarastorage.com>
To: =?ISO-8859-1?Q?Sw=E2mi_Petaramesh?= <swami@petaramesh.org>
Cc: "BTRFS, Linux" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Swami,
I believe the only thing that "inode_cache" mount option does is
allowing to reuse inode numbers. Like if you had a file with inode
number=X and you delete this file, then you will never have inode=X in
the same file tree (subvolume) again. You can look at
btrfs_find_free_ino() that allocates an inode number to understand
this better. Since inode number is u64, it is perhaps unlikely that
you ever run out of inode numbers. But still this mount option is
present and implemented, so perhaps there is some reason for that.
You can also look at "Free space cache writeback issue" note from Jan
on the list; looks like he discovered some issue with that option.

Alex.


On Sun, Oct 14, 2012 at 1:24 PM, Swâmi Petaramesh <swami@petaramesh.org> wrote:
> Hi there,
>
> On a performance standpoint - and on Ubuntu Quantall kernel 3.5.0-17 -
> is it advisable to mount BTRFS with "inode_cache" ?
>
> Is there any risk or counterpart doing so ?
>
> TIA, kind regards.
>
> --
> Swāmi Petaramesh <swami@petaramesh.org> http://petaramesh.org PGP 9076E32E
> Ne cherchez pas : Je ne suis pas sur Facebook.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
