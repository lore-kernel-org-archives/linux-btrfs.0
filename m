Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53800 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751433AbcBVMdz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 22 Feb 2016 07:33:55 -0500
Date: Mon, 22 Feb 2016 13:33:46 +0100
From: David Sterba <dsterba@suse.cz>
To: Simon Quigley <tsimonq2@ubuntu.com>
Cc: dsterba@suse.cz, clm@fb.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] btrfs: backref: Fixed checkpatch warning of over 80
 characters
Message-ID: <20160222123346.GE4374@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1455992258-9176-1-git-send-email-tsimonq2@ubuntu.com>
 <20160222115741.GC4374@twin.jikos.cz>
 <1456143056.3587.8.camel@ubuntu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1456143056.3587.8.camel@ubuntu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Feb 22, 2016 at 06:10:56AM -0600, Simon Quigley wrote:
> > in short, whitespace-only changes do not help too much.
> 
> But they are encouraged for people who would like to get started with kernel programming, Linus
> himself says so. In the future I plan on giving more, but I wanted to get familiarized with the
> process. So I still think this should be accepted although it's just a whitespace change.

But you are getting familiarized, you sent a patch, got feedback, defend
your patches.  That's a great start, but it does not mean that the
patches end up merged. The decision is up to the maintainer(s) of the
subsystem.

Nobody will bite your head off if you do some trivial formal mistakes in
your first patch submissions. The mistakes will be pointed out, you will
be asked to resend.  Sometimes, when the mistakes or formalities are not
worth the email roundtrip, the maintainers fix it at commit time.
