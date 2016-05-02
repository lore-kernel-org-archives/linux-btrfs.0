Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37341 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752472AbcEBMdh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 2 May 2016 08:33:37 -0400
Date: Mon, 2 May 2016 14:33:21 +0200
From: David Sterba <dsterba@suse.cz>
To: dsterba@suse.cz, Qu Wenruo <quwenruo@cn.fujitsu.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: Restrict e2fsprogs version for new convert
Message-ID: <20160502123321.GH29353@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1460615074-2492-1-git-send-email-quwenruo@cn.fujitsu.com>
 <20160415111726.GD28775@twin.jikos.cz>
 <57143652.20206@cn.fujitsu.com>
 <20160425145532.GA29353@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160425145532.GA29353@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Apr 25, 2016 at 04:55:32PM +0200, David Sterba wrote:
> On Mon, Apr 18, 2016 at 09:20:18AM +0800, Qu Wenruo wrote:
> > 
> > 
> > David Sterba wrote on 2016/04/15 13:17 +0200:
> > > On Thu, Apr 14, 2016 at 02:24:34PM +0800, Qu Wenruo wrote:
> > >> New btrfs-convert is using a lot of new macro in e2fsprogs 1.42.
> > >> Unfortunately the new compatible layer for older e2fsprogs is still
> > >> under development.
> > >
> > > It hasn't been released yet so it's not really a big problem, although
> > > it makes testing on my side a bit harder. The configure-time check
> > > should be 1.41 and until it's fixed we can print a warning.
> > >
> > >
> > Did I missed something?
> > 
> > I checkout 1.41.14 and it shows no cluster support in ext2fs.h.
> > 
> > Also git describe shows it's v1.41.14-36-g1da5ef7, after the last v1.41 
> > version.
> > 
> > So I think the check should be 1.42, just as the patch.
> 
> The idea is to keep lowest supported version 1.41, because this version
> can be commonly found on enterprise distros. The lack of cluster is
> expected and needs to be dealt with both build- and run-time.

I've committed the following patch, as it was your idea to add the
version check:

btrfs-progs: Restrict e2fsprogs version for convert

We want to support version 1.41 due to longterm and enterprise distros,
make the check explicit.

Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
Signed-off-by: David Sterba <dsterba@suse.com>

diff --git a/configure.ac b/configure.ac
index fc343ea1aa5d..797eb7903520 100644
--- a/configure.ac
+++ b/configure.ac
@@ -105,7 +105,7 @@ AS_IF([test "x$enable_convert" = xyes], [DISABLE_BTRFSCONVERT=0], [DISABLE_BTRFS
 AC_SUBST([DISABLE_BTRFSCONVERT])

 if test "x$enable_convert" = xyes; then
-       PKG_CHECK_MODULES(EXT2FS, [ext2fs])
+       PKG_CHECK_MODULES(EXT2FS, [ext2fs >= 1.41])
        PKG_CHECK_MODULES(COM_ERR, [com_err])
 fi
