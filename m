Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:51157 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755215AbaFLKvx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 12 Jun 2014 06:51:53 -0400
Date: Thu, 12 Jun 2014 12:51:51 +0200
From: David Sterba <dsterba@suse.cz>
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>, Karel Zak <kzak@redhat.com>
Subject: Re: [PATCH V2] btrfs-progs: add mount options to btrfs-mount.5
Message-ID: <20140612105151.GN1903@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <5398D475.4070309@redhat.com>
 <5398D4DF.9080508@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5398D4DF.9080508@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 11, 2014 at 05:14:55PM -0500, Eric Sandeen wrote:
> This is a straight cut and paste from the util-linux
> mount manpage into btrfs-mount.5
> 
> It's pretty much impossible for util-linux to keep up
> with every filesystem out there, and Karel has more than
> once expressed a wish that mount options move into fs-specific
> manpages.
> 
> So, here we go.
> 
> The way btrfs asciidoc is generated, there's not a trivial
> way to have both btrfs(5) and btrfs(8) so I named it btrfs-mount(5)
> for now.  A bit ick and I'm open to suggestions.

So what if the mount options are generated from btrfs-mount.txt but
installed under btrfs.5.gz name? If there are more section 5 manpages we
can make it more generic but for now hardcoding btrfs-mount.* ->
btrfs.5. sounds ok to me.
