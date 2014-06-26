Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:38730 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757360AbaFZQyD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 26 Jun 2014 12:54:03 -0400
Date: Thu, 26 Jun 2014 18:54:01 +0200
From: David Sterba <dsterba@suse.cz>
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH, RFC] btrfs: refactor open_ctree()
Message-ID: <20140626165401.GZ1553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <53AB6185.9060109@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <53AB6185.9060109@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 25, 2014 at 06:55:49PM -0500, Eric Sandeen wrote:
> open_ctree() is almost 1000 lines long.  I've started trying
> to refactor it, primarily into helper functions, and also
> simplifying (?) things a bit at the beginning by removing the
> ret = func(); if (ret) { err = ret; goto ... } dance where it's not
> needed.
> 
> Does this look like a reasonable thing to do?  Have I cut
> things into the right chunks?  Would you rather see it as
> as series of patches, moving one hunk of code at a time?

Looks good to me, I'd prefer separate patches for each helper, for the
sake of easier review. The separation seems ok.
