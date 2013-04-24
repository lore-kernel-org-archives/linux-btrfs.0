Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:46887 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755099Ab3DXPBS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 24 Apr 2013 11:01:18 -0400
Date: Wed, 24 Apr 2013 17:01:16 +0200
From: David Sterba <dsterba@suse.cz>
To: Josef Bacik <jbacik@fusionio.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: don't try and free ebs twice in log replay
Message-ID: <20130424150116.GF16427@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1366729794-1542-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1366729794-1542-1-git-send-email-jbacik@fusionio.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Apr 23, 2013 at 11:09:54AM -0400, Josef Bacik wrote:
> This work is done by btrfs_free_path() anyway so there's no need for this
> duplicate work.  Thanks,
> 
> Signed-off-by: Josef Bacik <jbacik@fusionio.com>

Reviewed-by: David Sterba <dsterba@suse.cz>
