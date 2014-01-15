Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:55178 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752596AbaAOSjT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 15 Jan 2014 13:39:19 -0500
Date: Wed, 15 Jan 2014 19:39:18 +0100
From: David Sterba <dsterba@suse.cz>
To: Gerhard Heift <gerhard@heift.name>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: BTRFS_SEARCH_ARGS_BUFSIZE too small
Message-ID: <20140115183918.GF6498@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <CACeaM885anPZOwbAw_2w43vOU8e0zkj-w_drar1sJhpppCsJeA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CACeaM885anPZOwbAw_2w43vOU8e0zkj-w_drar1sJhpppCsJeA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jan 10, 2014 at 12:44:17AM +0100, Gerhard Heift wrote:
> I'm playing around with the BTRFS_IOC_SEARCH_TREE to extract the csums
> of the physical blocks. During the tests some item_header had len = 0,
> which indicates the buffer was to small to hold the item. I added a
> printk into the kernel to get the original size of the item and it was
> around 6600 bytes.

This can happen with the metadata blocks bigger than 4k, the search
ioctl does not have buffer large enough as you've found. The EXTENT_CSUM
items seem to cap at 16k, no matter what's the node size (tried with
64k).

> Is there another way to get the item? Otherwise I would suggest to
> create an ioctl, which is a little bit more flexible, something like
> 
> struct btrfs_ioctl_search_args2 {
>         struct btrfs_ioctl_search_key key;
>         __u64 buf_len
>         char buf[0];
> };

Yeah, a V2 ioctl has to be introduced, the structure could look like
this. Kernel would have uo directly copy_to_user to the buffer without
the intermediate memcpy to the in-kernel copy of the ioctl structure.


david
