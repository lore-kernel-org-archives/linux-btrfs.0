Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38786 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932320AbdKOQir (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 15 Nov 2017 11:38:47 -0500
Date: Wed, 15 Nov 2017 17:36:52 +0100
From: David Sterba <dsterba@suse.cz>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] btrfs: ref-verify: Remove unused parameter from
 walk_up_tree() to kill warning
Message-ID: <20171115163652.GT28899@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1510758280-6986-1-git-send-email-geert@linux-m68k.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1510758280-6986-1-git-send-email-geert@linux-m68k.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Nov 15, 2017 at 04:04:40PM +0100, Geert Uytterhoeven wrote:
> With gcc-4.1.2:
> 
>     fs/btrfs/ref-verify.c: In function ‘btrfs_build_ref_tree’:
>     fs/btrfs/ref-verify.c:1017: warning: ‘root’ is used uninitialized in this function
> 
> The variable is indeed passed uninitialized, but it is never used by the
> callee.  However, not all versions of gcc are smart enough to notice.
> 
> Hence remove the unused parameter from walk_up_tree() to silence the
> compiler warning.
> 
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>

Reviewed-by: David Sterba <dsterba@suse.com>
