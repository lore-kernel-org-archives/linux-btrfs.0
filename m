Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:59265 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756482Ab3K0QqF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Nov 2013 11:46:05 -0500
Date: Wed, 27 Nov 2013 17:46:02 +0100
From: David Sterba <dsterba@suse.cz>
To: Konstantinos Skarlatos <k.skarlatos@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Btrfs-tools build instructions for Centos
Message-ID: <20131127164602.GE25312@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <5294600F.8050601@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5294600F.8050601@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Nov 26, 2013 at 10:47:11AM +0200, Konstantinos Skarlatos wrote:
> Hello,
> in https://btrfs.wiki.kernel.org/index.php/Btrfs_source_repositories, i used
> the fedora instructions for Centos.
> The problem is that lzo2-devel is named lzo-devel in Centos, so if somebody
> follows the fedora instructions and doesn't notice that lzo2-devel is
> missing, btrfs-progs build will fail with "/usr/bin/ld: cannot find -llzo2".
> The solution is to install lzo-devel instead. Can this be added to the wiki?

Sure, feel free to add it, it's a wiki.
