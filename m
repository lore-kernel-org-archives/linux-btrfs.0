Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37928 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750772AbbFSLor (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 19 Jun 2015 07:44:47 -0400
Date: Fri, 19 Jun 2015 13:44:45 +0200
From: Karel Zak <kzak@redhat.com>
To: dsterba@suse.cz, Liu Bo <bo.li.liu@oracle.com>,
        linux-btrfs@vger.kernel.org, fdmanana@suse.com,
        linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk
Subject: Re: i_version vs iversion (Was: Re: [RFC PATCH v2 1/2] Btrfs: add
 noi_version option to disable MS_I_VERSION)
Message-ID: <20150619114445.GG1992@ws.net.home>
References: <1434527672-5762-1-git-send-email-bo.li.liu@oracle.com>
 <20150617153306.GY6761@twin.jikos.cz>
 <20150617155234.GB7773@localhost.localdomain>
 <20150617170118.GA6761@twin.jikos.cz>
 <20150618024607.GA8530@localhost.localdomain>
 <20150618143856.GG6761@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20150618143856.GG6761@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 18, 2015 at 04:38:56PM +0200, David Sterba wrote:
> AFAICS, ext4 had added it's own i_version before iversion was added to
> mount:

It is not so unusual that some mount option is introduced as
fs-specific and later re-implemented as generic (another example is
MS_LAZYTIME). The mount(8) cares about the generic options only.

> ext4:
> 
> Commit:      25ec56b518257a56d2ff41a941d288e4b5ff9488
> Commit date: Mon Jan 28 23:58:27 2008 -0500
> Subject:     ext4: Add inode version support in ext4
> 
> util-linux:
> 
> Commti:      4fa5e73d16828c94234ba0aeafaec2470f79011c
> Commit date: Thu Nov 27 12:08:44 2008 +0100
> Subject:     mount: add i_version support
> 
> I don't know the history, this looks like adding the options was not
> coordinated.

I don't remember this change, but MS_I_VERSION is part of the kernel
API (include/uapi/linux/fs.h) so I guess it's fine to support it in
mount(8).

    Karel

-- 
 Karel Zak  <kzak@redhat.com>
 http://karelzak.blogspot.com
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
