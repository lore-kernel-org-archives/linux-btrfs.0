Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from syrinx.knorrie.org ([82.94.188.77]:42218 "EHLO
        syrinx.knorrie.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751392AbcJOSld (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 15 Oct 2016 14:41:33 -0400
Subject: Re: Rust library for BTRFS
To: James Pharaoh <james@pharaoh.uk>, linux-btrfs@vger.kernel.org
References: <2636de69-cd94-1700-f589-9f0c981bbac2@pharaoh.uk>
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Message-ID: <1c974452-3523-d91e-1149-a55986276c7f@mendix.com>
Date: Sat, 15 Oct 2016 20:41:27 +0200
MIME-Version: 1.0
In-Reply-To: <2636de69-cd94-1700-f589-9f0c981bbac2@pharaoh.uk>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 10/15/2016 04:31 PM, James Pharaoh wrote:
> 
> I have created a BTRFS library for Rust - very incomplete so far, but
> possibly of interest to someone.

Nice work, I'm doing the same for python. Just picked up working on it
again, after summer: https://github.com/knorrie/python-btrfs

> https://gitlab.wellbehavedsoftware.com/well-behaved-software/rust-btrfs
> 
> I've basically reimplemented what I find in other tools because, as far
> as I can tell, there is no C library for BTRFS at this point.

For code operating on an online filesystem, using the IOCTLs, you don't
really need a lot from btrfs-progs. You need to known about some structs
and throw them back and forth to the kernel. And not being afraid of
doing some reverse engineering helps. :o)

The btrfs-progs programs operate in two ways:
1. Using the IOCTLs, implementing a command/args input model and
converting the output back to text on the console.
2. Also directly doing low-level plumbing, reading and writing inside
unmounted btrfs filesystems. For this, there's a copy of a bunch of code
from the kernel, to be able to read/write a filesystem that is not
mounted from the running program, in a similar way that kernel does when
it's live. If you don't plan to write your own btrfs check --repair,
this is also not what you need to import as a library.

This might be interesting:
https://patchwork.kernel.org/patch/9356749/

But, I'm not the C expert here, this is what I know.

> The currently supported functions are:
> 
> - Deduplication
> - File system info
> - Space info

Is there a specific use case you're building this for?

My primary trigger to start on it is best described as: "Tired of
parsing the output of btrfs <foo> <bar>? Try this!"

Also, if you're using IRC, #btrfs on freenode is a good place to hang out.

Have fun,
-- 
Hans van Kranenburg
