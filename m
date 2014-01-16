Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:45119 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752255AbaAPPHM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 16 Jan 2014 10:07:12 -0500
Date: Thu, 16 Jan 2014 16:07:11 +0100
From: David Sterba <dsterba@suse.cz>
To: Gerhard Heift <gerhard@heift.name>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: BTRFS_SEARCH_ARGS_BUFSIZE too small
Message-ID: <20140116150710.GL6498@suse.cz>
Reply-To: dsterba@suse.cz
References: <CACeaM885anPZOwbAw_2w43vOU8e0zkj-w_drar1sJhpppCsJeA@mail.gmail.com>
 <20140115183918.GF6498@twin.jikos.cz>
 <CACeaM88ouFDe0WwYdaLq_8MFG4-UCH3rFowCLYbb3qaJCUcJaw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CACeaM88ouFDe0WwYdaLq_8MFG4-UCH3rFowCLYbb3qaJCUcJaw@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jan 15, 2014 at 08:29:22PM +0100, Gerhard Heift wrote:
> I have already patches for such an ioctl. Which form do you prefer?

Great!

> struct btrfs_ioctl_search_args_inline {
>         struct btrfs_ioctl_search_key key;
>         __u64 buf_len
>         char buf[0];
> };

This one.

>         char __user *buf;

We want to avoid dereferencing any user pointers in kernel, the whole
structure is one blob.

> And against which commit should I rebase them?

The kernel patches against btrfs-next, progs patches against any recent
integration branch.


david
