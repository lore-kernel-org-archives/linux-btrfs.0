Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:55747 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754475Ab3DOQ7h (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Apr 2013 12:59:37 -0400
Date: Mon, 15 Apr 2013 09:59:36 -0700
From: Mark Fasheh <mfasheh@suse.de>
To: Eric Sandeen <sandeen@redhat.com>
Cc: miaox@cn.fujitsu.com, Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 2/2] Btrfs: introduce noextiref mount option
Message-ID: <20130415165936.GH24720@wotan.suse.de>
Reply-To: Mark Fasheh <mfasheh@suse.de>
References: <51669144.20107@cn.fujitsu.com> <516691F0.4080204@cn.fujitsu.com> <51683DDF.9010004@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <51683DDF.9010004@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Apr 12, 2013 at 12:01:19PM -0500, Eric Sandeen wrote:
> On 4/11/13 5:35 AM, Miao Xie wrote:
> > Now, we set incompat flag EXTEND_IREF when we actually need insert a
> > extend inode reference, not when making a fs. But some users may hope
> > that the fs still can be mounted on the old kernel, and don't hope we
> > insert any extend inode references. So we introduce noextiref mount
> > option to close this function.
> 
> I'd really rather not have yet another work-around mount option.
> 
> Wouldn't it be better to say: if you don't want extended irefs, turn
> that feature off on the filesystem itself, either at mkfs time or via
> btrfstune after the fact.
> 
> So rather than opportunistically turning it on, and then adding another
> patch to disable that behavior with a mount option, why not just teach
> btrfstune to turn off the flag, if it's not desired by the admin?
> 
> It'd save a mount option, and 50 or so lines of new kernel code,
> and make things simpler overall, IMHO.

I don't like this so much either - in particular I don't like the fs to
silently turn on incompat flags based on some heuristic or random number
that the user won't likely know (in this case, the number of bytes that
would fit in a standard btrfs hard link).

Tunefs can already turn the flag on, I don't see why we don't add the
reverse functionality. Also making it optional on mkfs time is easy
enough...
	--Mark

--
Mark Fasheh
