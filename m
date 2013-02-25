Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:58884 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758612Ab3BYS4u (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 Feb 2013 13:56:50 -0500
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 327A37C0445
	for <linux-btrfs@vger.kernel.org>; Mon, 25 Feb 2013 11:56:50 -0700 (MST)
Date: Mon, 25 Feb 2013 13:56:47 -0500
From: Josef Bacik <jbacik@fusionio.com>
To: Liu Bo <bo.li.liu@oracle.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Marios Titas <redneb8888@gmail.com>, David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH] Btrfs: do not change inode flags in rename
Message-ID: <20130225185647.GB2434@localhost.localdomain>
References: <1361765082-6331-1-git-send-email-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1361765082-6331-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Feb 24, 2013 at 09:04:42PM -0700, Liu Bo wrote:
> Before we forced to change a file's NOCOW and COMPRESS flag due to
> the parent directory's, but this ends up a bad idea, because it
> confuses end users a lot about file's NOCOW status, eg. if someone
> change a file to NOCOW via 'chattr' and then rename it in the current
> directory which is without NOCOW attribute, the file will lose the
> NOCOW flag silently.
> 
> This diables 'change flags in rename', so from now on we'll only
> inherit flags from the parent directory on creation stage while in
> other places we can use 'chattr' to set NOCOW or COMPRESS flags.
>

I'm of the mind we definitely shouldn't drop flags we've set previously, but I
think we should also inherit any flags we have set on the directory, so if we
move a file into a NOCOW directory we should inherit the flag.  I'm not married
to the idea, but it seems to make the most sense to me.  Thanks,

Josef 
