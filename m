Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ud10.udmedia.de ([194.117.254.50]:50313 "EHLO
        mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752469AbcIDKGb (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 4 Sep 2016 06:06:31 -0400
Date: Sun, 4 Sep 2016 12:06:25 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Francesco Turco <fturco@fastmail.fm>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: OOM killer and Btrfs
Message-ID: <20160904100625.GA305@x4>
References: <1472983177.1812484.715201857.036A622E@webmail.messagingengine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1472983177.1812484.715201857.036A622E@webmail.messagingengine.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016.09.04 at 11:59 +0200, Francesco Turco wrote:
> I use Btrfs on a Gentoo Linux system with kernel 4.7.2. When my computer
> is under heavy I/O load some application often crashes, for example
> ClamAV, Firefox or Portage. I suspect the problem is due to Btrfs, but I
> may be wrong.
> 
> These are the most recent error messages from journalctl, but I have
> many other similar ones in my logs:
> 
> *** BEGIN ***
> 
> Sep 04 10:13:26 desktop kernel: gpg-agent invoked oom-killer:
> gfp_mask=0x27080c0(GFP_KERNEL_ACCOUNT|__GFP_ZERO|__GFP_NOTRACK),
> order=2, oom_
> 
> Is the problem already known? Should I report a bug? Is there a patch I
> can try? Thanks.

This issue was recently fixed by:

commit 6b4e3181d7bd5ca5ab6f45929e4a5ffa7ab4ab7f
Author: Michal Hocko <mhocko@suse.com>
Date:   Thu Sep 1 16:14:41 2016 -0700

    mm, oom: prevent premature OOM killer invocation for high order request

It will be backported to the 4.7.x stable kernel, too.

-- 
Markus
