Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:56244 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751096AbbEKOvk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 May 2015 10:51:40 -0400
Date: Mon, 11 May 2015 16:51:37 +0200
From: David Sterba <dsterba@suse.cz>
To: Omar Sandoval <osandov@osandov.com>
Cc: Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/6] Btrfs: show subvolume name and ID in /proc/mounts
Message-ID: <20150511145137.GN23255@suse.cz>
Reply-To: dsterba@suse.cz
References: <cover.1428614837.git.osandov@osandov.com>
 <20150511094258.GA18249@mew>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20150511094258.GA18249@mew>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, May 11, 2015 at 02:42:58AM -0700, Omar Sandoval wrote:
> Sorry for the long-winded email! Thoughts, David, Qu?

I'm ok with the approach and the patchset as a whole. There was one
minor issue with the aliasing of the toplevel subvolume (id 0 or 5).
I'll post a comment to the patch.
