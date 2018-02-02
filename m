Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43112 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751795AbeBBOwF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 2 Feb 2018 09:52:05 -0500
Date: Fri, 2 Feb 2018 15:49:52 +0100
From: David Sterba <dsterba@suse.cz>
To: Omar Sandoval <osandov@osandov.com>
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH 25/26] btrfs-progs: deprecate libbtrfs helpers with
 libbtrfsutil equivalents
Message-ID: <20180202144952.GO18553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1516991902.git.osandov@fb.com>
 <8f43201c315567b1379dd4edaaed3a114332d431.1516991902.git.osandov@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <8f43201c315567b1379dd4edaaed3a114332d431.1516991902.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jan 26, 2018 at 10:41:13AM -0800, Omar Sandoval wrote:
> From: Omar Sandoval <osandov@fb.com>
> 
> The old libbtrfs defines some helpers which do the same thing as some
> libbtrfsutil helpers. Reimplement the libbtrfs helpers in terms of the
> libbtrfsutil APIs and mark the libbtrfs versions as deprecated, which we
> could ideally get rid of eventually.

Can we keep both libraries separate, ie. no runtime dependency? The
libbtrfs still has some use internally, the deprecation should happen on
the application level.

If there are some exported functions in libbtrfs that are (and should)
be provided by the util library, then we can use the same .o for
building as a temporary solution.
