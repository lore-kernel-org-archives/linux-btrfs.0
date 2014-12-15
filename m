Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:35993 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750801AbaLORgB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Dec 2014 12:36:01 -0500
Date: Mon, 15 Dec 2014 18:35:58 +0100
From: David Sterba <dsterba@suse.cz>
To: Filipe David Manana <fdmanana@gmail.com>
Cc: Qu Wenruo <quwenruo@cn.fujitsu.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 1/2] btrfs-progs: Add support for btrfs-image + corrupt
 script fsck test case.
Message-ID: <20141215173558.GS27601@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1418615699-18169-1-git-send-email-quwenruo@cn.fujitsu.com>
 <CAL3q7H5TrEGT87by4Zgs_Gy-OagBBEQVdk0A54snC9334wRP1w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAL3q7H5TrEGT87by4Zgs_Gy-OagBBEQVdk0A54snC9334wRP1w@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Dec 15, 2014 at 09:36:51AM +0000, Filipe David Manana wrote:
> So another thing I would like to see is doing a more comprehensive
> verification that the repair code worked as expected. Currently we
> only check that a readonly fsck, after running fsck --repair, returns
> 0.
> 
> For the improvements you've been doing, it's equally important to
> verify that --repair recovered the inodes, links, etc to the
> lost+found directory (or whatever is the directory's name).
> 
> So perhaps adding a verify.sh script to the tarball for example?

A verifier script would be good, but I'd rather not put it into the
tarball. We might want to edit it, do cleanups etc, this would require
to regenerate the image each time and the changes would be hard to
review.

We can use the base image name and add -verify.sh suffix instead, eg.
007-bad_root_items_fs_skinny.tar.xz and
007-bad_root_items_fs_skinny-verify.sh


