Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34644 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752674AbbEKQJ5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 May 2015 12:09:57 -0400
Date: Mon, 11 May 2015 18:09:55 +0200
From: David Sterba <dsterba@suse.cz>
To: Omar Sandoval <osandov@osandov.com>
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.cz>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, Qu Wenruo <quwenruo@cn.fujitsu.com>
Subject: Re: [PATCH v2 4/6] Btrfs: fail on mismatched subvol and subvolid
 mount options
Message-ID: <20150511160955.GS23255@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1428614837.git.osandov@osandov.com>
 <40c40f7f26acb30eea471b8c7b7bc01cce74be4d.1428614837.git.osandov@osandov.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <40c40f7f26acb30eea471b8c7b7bc01cce74be4d.1428614837.git.osandov@osandov.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Apr 09, 2015 at 02:34:54PM -0700, Omar Sandoval wrote:
> There's nothing to stop a user from passing both subvol= and subvolid=
> to mount, but if they don't refer to the same subvolume, someone is
> going to be surprised at some point. Error out on this case, but allow
> users to pass in both if they do match (which they could, for example,
> get out of /proc/mounts).
> 
> Signed-off-by: Omar Sandoval <osandov@osandov.com>

Reviewed-by: David Sterba <dsterba@suse.cz>
