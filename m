Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:49169 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751064AbbANAmS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 13 Jan 2015 19:42:18 -0500
Date: Wed, 14 Jan 2015 01:42:16 +0100
From: David Sterba <dsterba@suse.cz>
To: Merlijn Wajer <merlijn@wizzup.org>
Cc: Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.cz>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Revert "btrfs-progs: disable backtrace and define
 __always_inline"
Message-ID: <20150114004216.GR3685@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1421187619-24936-1-git-send-email-jbacik@fb.com>
 <20150114001341.GP3685@twin.jikos.cz>
 <54B5B5FA.20904@wizzup.org>
 <o7p8o4w432kx17p86ckfs9b3.1421195194593@email.android.com>
 <alpine.LNX.2.00.1501140126290.19863@chrometwo.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <alpine.LNX.2.00.1501140126290.19863@chrometwo.fritz.box>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jan 14, 2015 at 01:31:34AM +0100, Merlijn Wajer wrote:
> > This only works if you include features.h and I don't know if other libcs provide that.  Thanks,
> 
> musl provides /usr/include/features.h and glibc does so as well. (Checked
> on musl and glibc systems) Searching the web seems to suggest that uclibc
> supports it as well.

I'd say that we care about these two right now.

> Would you be in favour of including features.h and checking for __GLIBC__ ?

Yes please.
