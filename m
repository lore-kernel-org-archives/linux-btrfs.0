Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34710 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752674AbbEKQKG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 May 2015 12:10:06 -0400
Date: Mon, 11 May 2015 18:10:04 +0200
From: David Sterba <dsterba@suse.cz>
To: Omar Sandoval <osandov@osandov.com>
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.cz>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, Qu Wenruo <quwenruo@cn.fujitsu.com>
Subject: Re: [PATCH v2 5/6] Btrfs: unify subvol= and subvolid= mounting
Message-ID: <20150511161004.GT23255@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1428614837.git.osandov@osandov.com>
 <074cb88847c0034aa1fc28f78f69c3dd1d5bd938.1428614837.git.osandov@osandov.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <074cb88847c0034aa1fc28f78f69c3dd1d5bd938.1428614837.git.osandov@osandov.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Apr 09, 2015 at 02:34:55PM -0700, Omar Sandoval wrote:
> Currently, mounting a subvolume with subvolid= takes a different code
> path than mounting with subvol=. This isn't really a big deal except for
> the fact that mounts done with subvolid= or the default subvolume don't
> have a dentry that's connected to the dentry tree like in the subvol=
> case. To unify the code paths, when given subvolid= or using the default
> subvolume ID, translate it into a subvolume name by walking
> ROOT_BACKREFs in the root tree and INODE_REFs in the filesystem trees.
> 
> Signed-off-by: Omar Sandoval <osandov@osandov.com>

Reviewed-by: David Sterba <dsterba@suse.cz>
