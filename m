Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:54407 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751207AbbEYM5m (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 May 2015 08:57:42 -0400
Date: Mon, 25 May 2015 14:57:40 +0200
From: David Sterba <dsterba@suse.cz>
To: Anthony Plack <anthony@plack.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Additional Debug and other various pr_ additions
Message-ID: <20150525125740.GG23255@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <B6FEFB35-F6C4-41B7-9750-EC400392C0B8@plack.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <B6FEFB35-F6C4-41B7-9750-EC400392C0B8@plack.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, May 24, 2015 at 09:42:19PM -0500, Anthony Plack wrote:
> Would I step on anyone’s toes if I started submitting some extra
> patches to increase the verbosity of the BTRFS code in the kernel log?
> 
> I would probably start with most things as pr_debug just to keep it
> quiet on non-debug kernels, but I just thought that it might add a
> great deal of clarity to the code base and maybe help sysadmins figure
> out what is a BTRFS issue and what is some other issue.

Starting with pr_debug should be safe. There may be different oppinions
where to put the messages as this can easily fall into "too trivial"
category. This probably needs some "taste" and past experience with
debugging problems to find the good candidate spots in the code. Please
send a sample and let's see.
