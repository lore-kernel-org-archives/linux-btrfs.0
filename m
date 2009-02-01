From: Josef Bacik <jbacik@redhat.com>
Subject: Re: [PATCH] btrfs: Handle SGID bit when creating inodes
Date: Sun, 1 Feb 2009 08:38:48 -0500
Message-ID: <20090201133848.GA21973@unused.rdu.redhat.com>
References: <m363ju3jh5.fsf@pullcord.laptop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Chris Ball <cjb@laptop.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <m363ju3jh5.fsf@pullcord.laptop.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Jan 31, 2009 at 10:48:54PM -0500, Chris Ball wrote:
> Before this patch, new files/dirs would ignore the SGID bit on their
> parent directory and always be owned by the creating user's uid/gid.
> 
> Signed-off-by: Chris Ball <cjb@laptop.org>

Looks good, thanks much for taking care of this,

Josef
