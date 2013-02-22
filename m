Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:49031 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757844Ab3BVWVW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 Feb 2013 17:21:22 -0500
Date: Fri, 22 Feb 2013 23:21:20 +0100
From: David Sterba <dsterba@suse.cz>
To: Marios Titas <redneb8888@gmail.com>
Cc: bo.li.liu@oracle.com, btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: update inode flags when renaming
Message-ID: <20130222222120.GM27541@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1361520691-22665-1-git-send-email-bo.li.liu@oracle.com>
 <CAAdM645SGn=in2xq-Gv=DBCfpxJvynQEywr5tq7sh=jt-J197A@mail.gmail.com>
 <20130222084034.GC12835@liubo.cn.oracle.com>
 <CAAdM644hwRoGyrJVcmZgEY6S0EMDX4d-ZAQQ550mVi3SYVsYwg@mail.gmail.com>
 <20130222100015.GD12835@liubo.cn.oracle.com>
 <CAAdM644O8k3K16As84tbtoP9Knac93wqNB5Bwg_wN6YJ16Ea3g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAAdM644O8k3K16As84tbtoP9Knac93wqNB5Bwg_wN6YJ16Ea3g@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Feb 22, 2013 at 04:19:27PM -0500, Marios Titas wrote:
> I think that many end users will find all this very confusing. They
> will never expect that renaming a file will cause it to suddenly lose
> one flag (NODATACOW) while preserving the other (NODATASUM).
> Especially since they cannot explicitly control the NODATASUM flag on
> a per file basis. I think that renaming a file should preserve all
> flags no matter if it's done in the same directory or not. Just like
> it preserves permissions, ownership and inode number.

I agree. For completeness, the other inherited flags/attributes are
compression statuses. Silently changing them on remove may be wrong in
case the file gains the 'never try to compress' flag after some clever
heuristic (which we do not have yet) decides so.

> So I think
> inheriting the flags from the parent on rename is not a good idea
> either. Interestingly enough, files don't lose any of the two flags if
> instead of renaming you link and then unlink the original.

Link does not take the same codepath as new file or rename. A new
directory entry is created and link count increased.

david
