Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34220 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751524AbbJGJCc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 7 Oct 2015 05:02:32 -0400
Date: Wed, 7 Oct 2015 11:01:27 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: optimize check for stale device
Message-ID: <20151007090127.GD7734@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1444035437-9442-1-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1444035437-9442-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Oct 05, 2015 at 04:57:17PM +0800, Anand Jain wrote:
> optimize check for stale device to only be checked when there
> is device added or changed. If there is no update to the
> device, there is no need to call btrfs_free_stale_device().
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>

Ok for the change, same comment to the changelog (74 chars, capitals).
