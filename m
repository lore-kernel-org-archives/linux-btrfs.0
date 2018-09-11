Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46576 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726622AbeIKUi7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 11 Sep 2018 16:38:59 -0400
Date: Tue, 11 Sep 2018 17:39:04 +0200
From: David Sterba <dsterba@suse.cz>
To: dsterba@suse.cz, Mike Gilbert <floppym@gentoo.org>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2] Install uncompressed man pages
Message-ID: <20180911153904.GC2154@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180806205432.11009-1-floppym@gentoo.org>
 <20180807140957.GG3218@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180807140957.GG3218@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Aug 07, 2018 at 04:09:57PM +0200, David Sterba wrote:
> On Mon, Aug 06, 2018 at 04:54:31PM -0400, Mike Gilbert wrote:
> > Build systems do not typically compress man pages when installing them.
> > This is generally left to distro packaging mechanisms, which may end up
> > recompressing them using a different compressor.
> 
> Makes sense. I've tested this on openSUSE and there's a post-build step
> that indeed recompresses the manual pages. It does not work for me here
> with the uncompressed pages yet for some reason, also the symlinked
> pages would need to be reworked to the manual page links, but that can
> be fixed.
> 
> I'll queue this patch for a major release, expecting that some breakage
> might happen. Thanks.

FYI, the patches are now in devel. Expected release is in 4.18.
