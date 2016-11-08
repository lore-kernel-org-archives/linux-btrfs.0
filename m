Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail02.iobjects.de ([188.40.134.68]:53468 "EHLO
        mail02.iobjects.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750938AbcKHNnO (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 8 Nov 2016 08:43:14 -0500
Subject: Re: [PATCH v2] btrfs: make block group flags in balance printks
 human-readable
To: Adam Borowski <kilobyte@angband.pl>, David Sterba <dsterba@suse.cz>,
        linux-btrfs@vger.kernel.org
References: <20161107213810.GA25649@angband.pl>
 <20161107214049.4378-1-kilobyte@angband.pl>
From: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>
Message-ID: <5821D634.4070204@applied-asynchrony.com>
Date: Tue, 8 Nov 2016 14:42:12 +0100
MIME-Version: 1.0
In-Reply-To: <20161107214049.4378-1-kilobyte@angband.pl>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 11/07/16 22:40, Adam Borowski wrote:
> They're not even documented anywhere, letting users with no recourse but
> to RTFS.  It's no big burden to output the bitfield as words.
> 
> Also, display unknown flags as hex.
> 
> Signed-off-by: Adam Borowski <kilobyte@angband.pl>
[..]
>  
>  /*
> + * explain bit flags, prefixed by a '|' that'll be dropped
> + */
> +static char *describe_block_group_flags(char *buf, u64 flags)
> +{
> +#define BUF_SIZE 128
> +	char *buf0 = buf = kmalloc(BUF_SIZE, GFP_NOFS);
[..]

Maybe I'm missing some clever (?) trick here, but what's the point of passing
in a potentially uninitialized 'buf' when it's immediately reassigned locally,
and a new value is returned and assigned at the call site?
IMHO you'd probably either want to pass the buffer in or return it, but not
both - and in that case the allocation should probably be hoisted out
into the caller as well, if only to make things a bit more symmetric.

-h

