Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from vmicros1.altlinux.org ([194.107.17.57]:39248 "EHLO
        vmicros1.altlinux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752422AbdCBNKb (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 2 Mar 2017 08:10:31 -0500
Date: Thu, 2 Mar 2017 16:01:17 +0300
From: "Dmitry V. Levin" <ldv@altlinux.org>
To: David Sterba <dsterba@suse.com>
Cc: Chris Mason <clm@fb.com>, Jeff Mahoney <jeffm@suse.com>,
        Josef Bacik <jbacik@fb.com>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] btrfs: remove btrfs_err_str function from uapi/linux/btrfs.h
Message-ID: <20170302130117.GA2208@altlinux.org>
References: <20170215200259.GA1028@altlinux.org> <e5736c5a-1cef-58cb-a171-055e139e26e7@suse.com> <20170215225503.GA2947@altlinux.org> <20170228231250.GA10156@altlinux.org> <20170301145434.GD4662@twin.jikos.cz> <20170302114212.GK4662@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170302114212.GK4662@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Mar 02, 2017 at 12:42:12PM +0100, David Sterba wrote:
> On Wed, Mar 01, 2017 at 03:54:35PM +0100, David Sterba wrote:
> > On Wed, Mar 01, 2017 at 02:12:50AM +0300, Dmitry V. Levin wrote:
> > > btrfs_err_str function is not called from anywhere and is replicated
> > > in the userspace headers for btrfs-progs.
> > > 
> > > It's removal also fixes the following linux/btrfs.h userspace
> > > compilation error:
> > > 
> > > /usr/include/linux/btrfs.h: In function 'btrfs_err_str':
> > > /usr/include/linux/btrfs.h:740:11: error: 'NULL' undeclared (first use in this function)
> > >     return NULL;
> > > 
> > > Suggested-by: Jeff Mahoney <jeffm@suse.com>
> > > Signed-off-by: Dmitry V. Levin <ldv@altlinux.org>
> > > Reviewed-by: David Sterba <dsterba@suse.com>
> > > ---
> > > v3: the patch seems to be lost, resending with updated list of addressees
> > 
> > Indeed, I can't find how or where it got lost, sorry. Added to 4.11
> > again.
> 
> So it's because you did not CC linux-btrfs@ , I have the mails in my
> inbox but haven't found it in the other folder while picking patches.

Thanks, I though so when Cc'ed linux-btrfs@ the last time.

Consider updating MAINTAINERS file so that scripts/get_maintainer.pl
would be able to print the right addressees for btrfs header files:

diff --git a/MAINTAINERS b/MAINTAINERS
index 0001835..04a758f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2905,4 +2905,6 @@ S:	Maintained
 F:	Documentation/filesystems/btrfs.txt
 F:	fs/btrfs/
+F:	include/linux/btrfs*
+F:	include/uapi/linux/btrfs*
 
 BTTV VIDEO4LINUX DRIVER

-- 
ldv
