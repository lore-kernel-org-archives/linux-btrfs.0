Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:53191 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754619AbaBFVWK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 6 Feb 2014 16:22:10 -0500
Date: Thu, 6 Feb 2014 22:22:09 +0100
From: David Sterba <dsterba@suse.cz>
To: Mitch Harder <mitch.harder@sabayonlinux.org>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: Convert BUG() to BUG_ON(1)
Message-ID: <20140206212209.GU1364@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1391711648-7224-1-git-send-email-mitch.harder@sabayonlinux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1391711648-7224-1-git-send-email-mitch.harder@sabayonlinux.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Feb 06, 2014 at 12:34:08PM -0600, Mitch Harder wrote:
> Convert the instances of BUG() to BUG_ON(1) to provide information
> about the location of the abort.

kerncompat.h:

#define BUG() abort()

#define BUG_ON(c) assert(!(c))

I'd rather fix the definition to do the same thing, that way no
developer would need to know the difference (that actually exists only
in the userspace tools, in kernel the two produce the same outout).


david
