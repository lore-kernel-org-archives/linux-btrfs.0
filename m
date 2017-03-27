Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47585 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752250AbdC0LsY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 27 Mar 2017 07:48:24 -0400
Date: Mon, 27 Mar 2017 13:47:40 +0200
From: David Sterba <dsterba@suse.cz>
To: Mike Gilbert <floppym@gentoo.org>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Missing __error symbol in btrfs-progs-4.10
Message-ID: <20170327114740.GA4781@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <CAJ0EP40B51rd1trLP=wMY+2=T4wPLUwYarBwf5Hi5RBABuJv6A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAJ0EP40B51rd1trLP=wMY+2=T4wPLUwYarBwf5Hi5RBABuJv6A@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Mar 26, 2017 at 04:37:05PM -0400, Mike Gilbert wrote:
> A Gentoo user reports that snapper broke after upgrading to btrfs-progs-4.10.
> 
> snapper: symbol lookup error: /usr/lib64/libbtrfs.so.0: undefined
> symbol: __error
> 
> https://bugs.gentoo.org/show_bug.cgi?id=613890
> 
> It seems that the __error symbol is referenced, but not included in libbtrfs.
> 
> Exporting this symbol seems like a bad idea, so I would suggest
> renaming it, or go back to inlining it in the headers.

Right, the name is too generic. I'd like to keep the function not
inlined, so I'll rename them to __btrfs_error etc, but the macros could
still clash with other symbols from the library user.
