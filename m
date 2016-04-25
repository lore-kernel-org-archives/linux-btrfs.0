Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52628 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933039AbcDYQcx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 Apr 2016 12:32:53 -0400
Date: Mon, 25 Apr 2016 18:32:41 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH 3/3] btrfs: refactor btrfs_dev_replace_start for reuse
Message-ID: <20160425163241.GE29353@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1458816494-483-1-git-send-email-anand.jain@oracle.com>
 <1458816494-483-3-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1458816494-483-3-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Mar 24, 2016 at 06:48:14PM +0800, Anand Jain wrote:
> A refactor patch, and avoids user input verification in the
> btrfs_dev_replace_start(), and so this function can be reused.
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>

Added on top of the delete-by-id patchset as there's a dependency, plus
the 1/3 patch "btrfs: use fs_info directly".
