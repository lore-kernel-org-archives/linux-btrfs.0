Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:39154 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752098AbbCXC5f convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 23 Mar 2015 22:57:35 -0400
Message-ID: <5510D29A.9060903@cn.fujitsu.com>
Date: Tue, 24 Mar 2015 10:57:30 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: Pavol Cupka <pavol.cupka@gmail.com>, <linux-btrfs@vger.kernel.org>
Subject: Re: Error: btrfs check --repair --init-csum-tree --init-extent-tree
References: <CAH4oapfmnuN=NwE5yuC68oqojak2uHesgJQtuHritYx4HiOvOw@mail.gmail.com>
In-Reply-To: <CAH4oapfmnuN=NwE5yuC68oqojak2uHesgJQtuHritYx4HiOvOw@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



-------- Original Message  --------
Subject: Error: btrfs check --repair --init-csum-tree --init-extent-tree
From: Pavol Cupka <pavol.cupka@gmail.com>
To: <linux-btrfs@vger.kernel.org>
Date: 2015年03月21日 20:26

> When running btrfs check on a RAID1 system using btrfs-progs v3.19-rc2
> and running the 4.0.0-rc4 linux kernel. I get this:
>
> btrfs check --repair --init-csum-tree --init-extent-tree /dev/sda1
Before btrfs-progs v3.19-rc3(Yes, there is rc3 now), --init-extent-tree 
can't work with --init-csum-tree properly. Although not the error your 
reported...

It's recommended to use v3.19-rc3 to test, since it contains the fix for 
--init-csum-tree with --init-extent-tree.
(Commit: 25db1dd11de2f25 "btrfs-progs: Make csum tree rebuild works with 
extent tree rebuild.")

BTW, it's *HIGHLY* recommended to do a dd backup of your filesystem 
before using such repair.

If v3.19-rc3 fixes it, that's good and nothing need to be done more.
But if not, please continue reading...
> ...
> ...
> Incorrect local backref count on 2019737948160 parent 2541793873920
> owner 0 offset 0 found 1 wanted 0 back 0x624dece0
> backpointer mismatch on [2019737948160 4096]
> ref mismatch on [2019737952256 4096] extent item 0, found 5
> adding new data backref on 2019737952256 root 271 owner 615 offset 0 found 1
> adding new data backref on 2019737952256 parent 2935248711680 owner 0
> offset 0 found 1
> adding new data backref on 2019737952256 parent 3289312481280 owner 0
> offset 0 found 1
> ctree.c:1595: leaf_space_used: Assertion `data_len < 0` failed.
This one seems strange, not sure what's the cause, but possible leaf 
header corruption? (but why no csum error?)

If your fs is not huge and don't contain important info, would you 
please provide a compressed image of your fs?
I'm afraid btrfs-image dump won't work in this case, so binary dump(dd) 
would be quite nice to debug the case.

If fs is too large or contains personal info, you can also try 
btrfs-debug-tree to only dump metadata. (although output maybe large and 
still need compression).

Thanks,
Qu
> btrfs[0x43324d]
> btrfs[0x43380c]
> btrfs(btrfs_leaf_free_space+0x24)[0x434f64]
> btrfs(btrfs_check_leaf+0xa5)[0x435065]
> btrfs[0x435432]
> btrfs(btrfs_search_slot+0x305)[0x437025]
> btrfs(btrfs_insert_empty_items+0x8a)[0x4384aa]
> btrfs[0x43ebe9]
> btrfs[0x43edb7]
> btrfs(btrfs_inc_extent_ref+0xf1)[0x440151]
> btrfs[0x40b512]
> btrfs[0x412fe5]
> btrfs(cmd_check+0x77d)[0x426afd]
> btrfs(main+0x82)[0x413742]
> /lib64/libc.so.6(__libc_start_main+0xf5)[0x7f9078031a65]
> btrfs[0x413843]
>
> is someone from the devs interested on debuging this?
>
> Let me know
> Pavol
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
