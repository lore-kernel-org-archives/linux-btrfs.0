Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:45297 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751691AbeEVARI (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 21 May 2018 20:17:08 -0400
Received: by mail-pf0-f194.google.com with SMTP id c10-v6so7840461pfi.12
        for <linux-btrfs@vger.kernel.org>; Mon, 21 May 2018 17:17:08 -0700 (PDT)
Date: Mon, 21 May 2018 17:17:06 -0700
From: Omar Sandoval <osandov@osandov.com>
To: linux-btrfs@vger.kernel.org
Cc: kernel-team@fb.com, David Sterba <dsterba@suse.com>,
        Tomohiro Misono <misono.tomohiro@jp.fujitsu.com>
Subject: Re: [PATCH] Btrfs: allow empty subvol= again
Message-ID: <20180522001706.GD14774@vader>
References: <4daab3c9993c97f3f962b16fcb9b5d578853765d.1526947478.git.osandov@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4daab3c9993c97f3f962b16fcb9b5d578853765d.1526947478.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, May 21, 2018 at 05:07:19PM -0700, Omar Sandoval wrote:
> From: Omar Sandoval <osandov@fb.com>
> 
> I got a report that after upgrading to 4.16, someone's filesystems
> weren't mounting:
> 
> [   23.845852] BTRFS info (device loop0): unrecognized mount option 'subvol='
> 
> Before 4.16, this mounted the default subvolume. It turns out that this
> empty "subvol=" is actually an application bug, but it was causing the
> application to fail, so it's an ABI break if you squint.
> 
> The generic parsing code we use for mount options (match_token())
> doesn't match an empty string as "%s". Previously, setup_root_args()
> removed the "subvol=" string, but the mount path was cleaned up to not
> need that. Add a dummy Opt_subvol_empty to fix this.
> 
> Fixes: 312c89fbca06 ("btrfs: cleanup btrfs_mount() using btrfs_mount_root()")
> Signed-off-by: Omar Sandoval <osandov@fb.com>
> ---
> Hi, Dave,
> 
> This is silly but IMO it's a regression. If you agree, this should
> probably go to 4.17 + stable. I'll submit an xfstests test shortly.
> 
> Thanks!

Update, we fixed the userspace bug now so I'd be fine if we dropped this
patch. I guess there's still a possibility that there are other users
that hit this, so I'll leave it up to you, Dave, whether it's important
enough to care.
