Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:57833 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751812Ab3JAOky (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 1 Oct 2013 10:40:54 -0400
Date: Tue, 1 Oct 2013 16:40:47 +0200
From: David Sterba <dsterba@suse.cz>
To: Josef Bacik <jbacik@fusionio.com>
Cc: Liu Bo <bo.li.liu@oracle.com>, linux-btrfs@vger.kernel.org,
        xfs@oss.sgi.com
Subject: Re: [PATCH] xfstests/btrfs: do not test btrfs/010 with autodefrag
Message-ID: <20131001144047.GI18291@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1379481475-10842-1-git-send-email-bo.li.liu@oracle.com>
 <20130927134544.GI18681@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130927134544.GI18681@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 27, 2013 at 09:45:44AM -0400, Josef Bacik wrote:
> On Wed, Sep 18, 2013 at 01:17:55PM +0800, Liu Bo wrote:
> > btrfs/010 is going to create a fragmented file, however, with autodefrag
> > this is impossible, so just skip the test when we're with autodefrag.
> > 
> > Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> 
> I'd rather you just strip out the autodefrag option if it is there and add it
> back once the test is done (or hell just remove it, mount, and add it back).

I think the test should be skipped if it does not make sense with a
specific mount option rather than temporarily removing it, because then
it looks like the test passes with the option altough it does not.
