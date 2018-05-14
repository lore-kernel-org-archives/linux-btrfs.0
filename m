Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pg0-f41.google.com ([74.125.83.41]:43039 "EHLO
        mail-pg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751422AbeENUWP (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 14 May 2018 16:22:15 -0400
Received: by mail-pg0-f41.google.com with SMTP id p8-v6so2431400pgq.10
        for <linux-btrfs@vger.kernel.org>; Mon, 14 May 2018 13:22:15 -0700 (PDT)
Date: Mon, 14 May 2018 13:22:13 -0700
From: Omar Sandoval <osandov@osandov.com>
To: Dimitri John Ledkov <xnox@ubuntu.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Clarification needed about libbtrfs & libbtrfsutil
Message-ID: <20180514202213.GD13417@vader>
References: <CANBHLUjcAjvcA3BCn=i4VmDvKUcxSBk4_g3qp7Jw-k84sZXx5g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CANBHLUjcAjvcA3BCn=i4VmDvKUcxSBk4_g3qp7Jw-k84sZXx5g@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, May 14, 2018 at 09:40:19AM +0100, Dimitri John Ledkov wrote:
> Are both of these meant to be public libraries, installed on the user
> systems, and available in .so variant as well for 3rd party
> development and public dynamic linking?
> 
> Or are these private internal libraries, which are installed as public
> runtime only, simply to share code between the utils, but otherwise
> provide no abi stability and will forever remain libfoo.so.0?

They're both meant to be public. In fact, libbtrfsutil is already 1.0.0.

> Or should these even be a noinst_ libraries (~= Libtool Convenience
> Libraries), and are simply intermediate by-products?
> 
> I'm asking because despite compiling shared & static variants of these
> libraries, and "shared linked" and "static linked" variants of the
> utils, it appears that all utilities are statically linking against
> libbtrfs/libbtrfsutils. Thus no binaries nor bindings, dynamically
> link against neither libbtrfs nor libbtrfsutil.
> 
> Tweaking the makefile to use libs_shared variable instead of libs or
> libs_static, results in slightly smaller binaries, dynamically linked
> against libbtrfs/libbtrfsutil.
> 
> But it is hard to tell if this is a bug/mistake, or an intentional feature.

I'm not sure why we statically link libbtrfs into the the tools, and I
just copied that for libbtrfsutil.
