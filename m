Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:52232 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756333Ab2FZMdr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Jun 2012 08:33:47 -0400
Date: Tue, 26 Jun 2012 14:33:35 +0200
From: David Sterba <dave@jikos.cz>
To: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Cc: chris.mason@fusionio.com, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: return error of btrfs_update_inode() to caller
Message-ID: <20120626123335.GR28144@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <201206260325.AA00003@FM-323941448.jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <201206260325.AA00003@FM-323941448.jp.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jun 26, 2012 at 12:25:22PM +0900, Tsutomu Itoh wrote:
> We didn't check error of btrfs_update_inode(), but that error looks
> easy to bubble back up.

Yep, the callers check for the retvals, and the one missed in
__btrfs_unlink_inode seems serious, as unlink_inode and rename would not
see the error (probably ENOSPC).

Reviewed-by: David Sterba <dsterba@suse.cz>
