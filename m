Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34532 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751049AbbEKQIo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 May 2015 12:08:44 -0400
Date: Mon, 11 May 2015 18:08:42 +0200
From: David Sterba <dsterba@suse.cz>
To: Omar Sandoval <osandov@osandov.com>
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.cz>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, Qu Wenruo <quwenruo@cn.fujitsu.com>
Subject: Re: [PATCH v2 3/6] Btrfs: clean up error handling in mount_subvol()
Message-ID: <20150511160842.GR23255@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1428614837.git.osandov@osandov.com>
 <607a31672e1eb72dafbca88c816187dd3b0846a6.1428614837.git.osandov@osandov.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <607a31672e1eb72dafbca88c816187dd3b0846a6.1428614837.git.osandov@osandov.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Apr 09, 2015 at 02:34:53PM -0700, Omar Sandoval wrote:
> In preparation for new functionality in mount_subvol(), give it
> ownership of subvol_name and tidy up the error paths.
> 
> Signed-off-by: Omar Sandoval <osandov@osandov.com>

Reviewed-by: David Sterba <dsterba@suse.cz>
