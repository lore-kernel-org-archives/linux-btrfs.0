Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:58947 "EHLO
        mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750819AbdHAGin (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 1 Aug 2017 02:38:43 -0400
Date: Mon, 31 Jul 2017 23:38:36 -0700
From: Marc MERLIN <marc@merlins.org>
To: Justin Maggard <jmaggard10@gmail.com>
Cc: Ivan Sizov <sivan606@gmail.com>, Martin Steigerwald <martin@lichtvoll.de>,
        Lu Fengqi <lufq.fnst@cn.fujitsu.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        David Sterba <dsterba@suse.cz>, Duncan <1i5t5.duncan@cox.net>
Subject: Re: 4.11.6 / more corruption / root 15455 has a root item with a
 more recent gen (33682) compared to the found root node (0)
Message-ID: <20170801063836.5lntqjcys54kawon@merlins.org>
References: <20170501170641.GG3516@merlins.org>
 <20170707163834.GA6083@merlins.org>
 <20170709043417.GE6704@merlins.org>
 <21425367.VGcO8ck7Vu@merkaba>
 <CAMG9ccyWS87NwUrJGNvF6Dt440yhCp_P9_-hFeJE70YDRwpfNg@mail.gmail.com>
 <20170731211750.bpo4roiqkr4t5iae@merlins.org>
 <CAKgsxVST3+DVxAoZ87JW0hLW56CakeHy8LUbLLs6Sp_X2UXOCg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAKgsxVST3+DVxAoZ87JW0hLW56CakeHy8LUbLLs6Sp_X2UXOCg@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jul 31, 2017 at 03:00:53PM -0700, Justin Maggard wrote:
> Marc, do you have quotas enabled?  IIRC, you're a send/receive user.
> The combination of quotas and btrfs receive can corrupt your
> filesystem, as shown by the xfstest I sent to the list a little while
> ago.

Thanks for checking. I do not use quota given the problems I had with
them early on over 2y ago.

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
