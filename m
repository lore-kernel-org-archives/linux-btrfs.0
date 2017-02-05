Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from syrinx.knorrie.org ([82.94.188.77]:49622 "EHLO
        syrinx.knorrie.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752166AbdBEWpx (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 5 Feb 2017 17:45:53 -0500
Received: from [IPv6:2001:980:4a41:fb::12] (unknown [IPv6:2001:980:4a41:fb::12])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by syrinx.knorrie.org (Postfix) with ESMTPSA id 7628E60014
        for <linux-btrfs@vger.kernel.org>; Sun,  5 Feb 2017 23:45:51 +0100 (CET)
Subject: Re: Bug or feature? logical_to_ino skips inodes with offset mismatch
To: linux-btrfs <linux-btrfs@vger.kernel.org>
References: <9eb6d42e-a44b-c427-ed37-1eaa67944b3f@mendix.com>
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Message-ID: <73a4f8c9-8878-5bd0-8e0a-e9b2bf6a3428@mendix.com>
Date: Sun, 5 Feb 2017 23:45:51 +0100
MIME-Version: 1.0
In-Reply-To: <9eb6d42e-a44b-c427-ed37-1eaa67944b3f@mendix.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 02/05/2017 10:54 PM, Hans van Kranenburg wrote:
> I was playing around with logical_to_ino and also implemented calling
> ino_lookup today to create a program that will print all data extents in
> a block group, and their related inodes and at least one filename per inode.
> 
> https://github.com/knorrie/python-btrfs/commits/develop
> See "examples: show filenames for data extents"
> 
> I ran into the following behaviour of logical_to_ino:
> 
> If the offset value in a backreference of an extent_item does not match
> the offset value of the extent_data object in the fs tree,
> logical_to_ino will skip the inode that uses data from the extent, and
> not report it.

Ah, wait... To answer my own question... The reason is probably because
the data at that exact place is not actually in use.

-# btrfs inspect-internal logical-resolve 336064511 . (+ 16KiB - 1)
-# btrfs inspect-internal logical-resolve 336064512 . (+ 16KiB)
./vmlinuz-4.9.0-1-amd64
-# btrfs inspect-internal logical-resolve 336064513 .
./vmlinuz-4.9.0-1-amd64

Jups... Makes sense.

But, it also means that I cannot use logical_to_ino as a helper to
expand shared backrefs to actual inode info... Meh.

-- 
Hans van Kranenburg
