Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:59039 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932089Ab2JDIHb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 4 Oct 2012 04:07:31 -0400
Date: Thu, 4 Oct 2012 10:07:27 +0200
From: David Sterba <dave@jikos.cz>
To: =?iso-8859-1?Q?=D8ystein_S=E6ttem?= Middelthun
	<oystein@middelthun.no>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: tree root
Message-ID: <20121004080727.GZ14582@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <506C6934.5010904@middelthun.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <506C6934.5010904@middelthun.no>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Oct 03, 2012 at 06:35:00PM +0200, Øystein Sættem Middelthun wrote:
> Well block 14102764707840 seems great, but generation doesn't match,
> have=109268, want=109269
> 
> Because the filesystem was last in use with a pre 3.2-kernel I am unable to
> use mount -o recovery, but restore seems to work when I specify the previous
> tree-root. My problem is however that the btrfs is so large I have nowhere
> to temporarily put all the files. I am currently running kernel 3.5. Does
> mount have an option to manually tell it to use the tree root at block
> 14102764707840?

It's not possible to supply the tree_root via mount option, but it
should be possible to modify the superblock to point the tree_root to
the one you've found, in a similar way that the -o recovery does that,
but this hasn't been done before and "minor" details may make it
complicated (like getting the transaction number in sync, as the
tree_root has latest-1).


david
