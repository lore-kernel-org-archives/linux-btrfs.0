Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58108 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756564Ab3AWRi0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Jan 2013 12:38:26 -0500
Date: Wed, 23 Jan 2013 18:38:24 +0100
From: David Sterba <dsterba@suse.cz>
To: Gene Czarcinski <gene@czarc.net>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 06/13] btrfs-show-super.c
Message-ID: <20130123173824.GN28263@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1358715858-4469-1-git-send-email-gene@czarc.net>
 <1358715858-4469-7-git-send-email-gene@czarc.net>
 <20130121164628.GK19967@twin.jikos.cz>
 <50FED3D8.1080208@czarc.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <50FED3D8.1080208@czarc.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jan 22, 2013 at 01:00:56PM -0500, Gene Czarcinski wrote:
> The patch which created btrfs-show-super.c had an extra line at the end and
> I got annoyed at git-am complaining about it.  This first patch fixes that.
> This should have been a separate commit.

No need to send separate patches for whitespaces if the number of
places to fix is small.

> The other patch (which should have been its own commit) addresses this
> problem:
> http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg19264.html
> 
> I could not see that it did any harm and it helped on at least one system
> type

Now I remember I saw that patch fly by; added to the queue.

david
