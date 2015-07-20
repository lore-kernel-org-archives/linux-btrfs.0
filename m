Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:44932 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753288AbbGTLds (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 20 Jul 2015 07:33:48 -0400
Date: Mon, 20 Jul 2015 13:33:42 +0200
From: David Sterba <dsterba@suse.com>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org, clm@fb.com
Subject: Re: [PATCH] btrfs: its btrfs_err() instead of btrfs_error()
Message-ID: <20150720113342.GL6306@suse.cz>
Reply-To: dsterba@suse.com
References: <1437147923-23965-1-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1437147923-23965-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jul 17, 2015 at 11:45:23PM +0800, Anand Jain wrote:
> sorry I indented to use btrfs_err() and I have no idea
> how btrfs_error() got there.
> infact I was thinking about these kind of oversights
> since these two func are too closely named.

Indeed, it's confusing. I suggest to convert btrfs_errror to
btrfs_std_error and change the prototype to

#define btrfs_std_error(fs_info, errno, fmt, args...)

and switch all btrfs_error users to pass NULL for 'fmt'.

> Signed-off-by: Anand Jain <anand.jain@oracle.com>

Reviewed-by: David Sterba <dsterba@suse.com>
