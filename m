Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54125 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752100AbcEaTx1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 31 May 2016 15:53:27 -0400
Date: Tue, 31 May 2016 12:53:25 -0700
From: Mark Fasheh <mfasheh@suse.de>
To: Josef Bacik <jbacik@fb.com>
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH] Btrfs: don't BUG_ON() in btrfs_orphan_add
Message-ID: <20160531195325.GB7633@wotan.suse.de>
Reply-To: Mark Fasheh <mfasheh@suse.de>
References: <1464368584-3531-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1464368584-3531-1-git-send-email-jbacik@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 27, 2016 at 01:03:04PM -0400, Josef Bacik wrote:
> This is just a screwup for developers, so change it to an ASSERT() so developers
> notice when things go wrong and deal with the error appropriately if ASSERT()
> isn't enabled.  Thanks,
> 
> Signed-off-by: Josef Bacik <jbacik@fb.com>

Reviewed-by: Mark Fasheh <mfasheh@suse.de>

--
Mark Fasheh
