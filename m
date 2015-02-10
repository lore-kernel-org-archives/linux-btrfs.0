Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:55120 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752735AbbBJO3G (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 10 Feb 2015 09:29:06 -0500
Date: Tue, 10 Feb 2015 15:29:03 +0100
From: David Sterba <dsterba@suse.cz>
To: Josef Bacik <jbacik@fb.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [GIT PULL] btrfsck and btrfs-image fixes
Message-ID: <20150210142903.GB28877@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1423512199-16552-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1423512199-16552-1-git-send-email-jbacik@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Feb 09, 2015 at 03:03:03PM -0500, Josef Bacik wrote:
> This series of patches fixes up btrfsck in lots of ways and adds some new
> functionality.  These patches were required to fix Hugo's broken multi-disk fs
> as well as fix fsck so it would actually pass all of the fsck tests.  This also
> fixes a long standing btrfs-image problem where it wouldn't restore multi disk
> images onto a single disk properly.  Dave you can pull this from
> 
> https://github.com/josefbacik/btrfs-progs.git for-kdave
> 
> These patches all pass make test.  Thanks,

Thanks, pulled to 3.19.

I see a new message from tests:

    [TEST]   002-bad-transid
    parent transid verify failed on 29360128 wanted 9 found 755944791
    parent transid verify failed on 29360128 wanted 9 found 755944791

bisected to 0b8aa1969bea17c6f539f03d673cfae1ba85ed63
Btrfs-progs: make restore update dev items

Please take a look, I need to process more pending patchsets and don't
want to block on that.
