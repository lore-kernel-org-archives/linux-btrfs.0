Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:37755 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759904Ab3B0NyB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Feb 2013 08:54:01 -0500
Date: Wed, 27 Feb 2013 14:54:00 +0100
From: David Sterba <dsterba@suse.cz>
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 00/17] btrfs-progs: More misc fixes & cleanups
Message-ID: <20130227135400.GD27541@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1361832890-40921-1-git-send-email-sandeen@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1361832890-40921-1-git-send-email-sandeen@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Feb 25, 2013 at 04:54:33PM -0600, Eric Sandeen wrote:
> A bunch of Coverity static analysis checker fixes, including
> a couple actual bugfixes.
> 
> This gets it down from around 80 defects to about 50; I have a couple
> other patches I need to clean up which quiets it even more.
> 
> By getting it to a tolerable level, subsequent runs to check for
> regressions & new problems should be more manageable...

Thank you very much.

> [PATCH 01/17] btrfs-progs: Unify size-parsing

I've added 02-17 to the queue and left out 01 as it looks like it needs
a few changes after the feedback.

david
