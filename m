Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:37738 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753249AbaI2Qgs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 29 Sep 2014 12:36:48 -0400
Date: Mon, 29 Sep 2014 18:36:46 +0200
From: David Sterba <dsterba@suse.cz>
To: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Chris Mason <clm@fb.com>, Filipe Manana <fdmanana@suse.com>
Subject: Re: [PATCH 1/4] btrfs: correct empty compression property behavior
Message-ID: <20140929163646.GF11436@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <541BED3D.5020803@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <541BED3D.5020803@jp.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 19, 2014 at 05:45:49PM +0900, Satoru Takeuchi wrote:
> In the current implementation, compression property == "" has
> the two different meanings: one is with BTRFS_INODE_NOCOMPRESS,
> and the other is without this flag.
> 
> So, even if the two files a and b have the same compression
> property, "", and the same contents, one file seems to be
> compressed and the other is not. It's difficult to understand
> for users and also confuses them.

Fixing this inconsistency is good, let me think more about the
interface.
