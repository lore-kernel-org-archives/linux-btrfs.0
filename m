Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f51.google.com ([209.85.213.51]:34364 "EHLO
	mail-vk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752576AbbIKNYy (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 11 Sep 2015 09:24:54 -0400
Received: by vkhf67 with SMTP id f67so26350971vkh.1
        for <linux-btrfs@vger.kernel.org>; Fri, 11 Sep 2015 06:24:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1441897376-5572-1-git-send-email-dsterba@suse.com>
References: <1441897376-5572-1-git-send-email-dsterba@suse.com>
Date: Fri, 11 Sep 2015 15:24:53 +0200
Message-ID: <CAHji150Jb5KrLoGJP6TmAPeGfexOC-wAXX7L1vUZ8EBxnM4wDA@mail.gmail.com>
Subject: Re: [PATCH] btrfs-progs: fix cross stripe boundary check
From: =?UTF-8?Q?Holger_Hoffst=C3=A4tte?=
	<holger.hoffstaette@googlemail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Sep 10, 2015 at 5:02 PM, David Sterba <dsterba@suse.com> wrote:
> Commit 854437ca3c228d8ab3eb24d2efc1c21b5d56a635 ("btrfs-progs:
> extent-tree: avoid allocating tree block that crosses stripe boundary")
> does not work for 64k nodesize. Due to an off-by-one error, all queries
> to check_crossing_stripes will return that all extents cross a stripe
> and this will lead to a false ENOSPC. This crashes later
>
> $ ./mkfs.btrfs -n 64k image
>
> ./mkfs.btrfs(btrfs_reserve_extent+0xb77)[0x417f38]
> ./mkfs.btrfs(btrfs_alloc_free_block+0x57)[0x417fe0]
> ./mkfs.btrfs(__btrfs_cow_block+0x163)[0x408eb7]
> ./mkfs.btrfs(btrfs_cow_block+0xd0)[0x4097c4]
> ./mkfs.btrfs(btrfs_search_slot+0x16f)[0x40be4d]
> ./mkfs.btrfs(btrfs_insert_empty_items+0xc0)[0x40d5f9]
> ./mkfs.btrfs(btrfs_insert_item+0x99)[0x40da5f]
> ./mkfs.btrfs(btrfs_make_block_group+0x4d)[0x41705c]
> ./mkfs.btrfs(main+0xeef)[0x434b56]

Am I correct that this also causes false positives with btrfs check? I just
ran a sanity check on an fs that had no problems whatsoever and was
definitely not converted (so 16k nodesize) and got thousands of
cross-stripe complaints; repair didn't help. Applying the patch seems to
have fixed those; it completes without problems now.

Holger
