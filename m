Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:6967 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752552Ab3JIQsO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 9 Oct 2013 12:48:14 -0400
Date: Wed, 9 Oct 2013 09:48:03 -0700
From: Zach Brown <zab@redhat.com>
To: Josef Bacik <jbacik@fusionio.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: use right root when checking for hash collision
Message-ID: <20131009164803.GY25712@lenny.home.zabbo.net>
References: <1381336002-3016-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1381336002-3016-1-git-send-email-jbacik@fusionio.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Oct 09, 2013 at 12:26:42PM -0400, Josef Bacik wrote:
> btrfs_rename was using the root of the old dir instead of the root of the new
> dir when checking for a hash collision, so if you tried to move a file into a
> subvol it would freak out because it would see the file you are trying to move
> in its current root.  This fixes the bug where this would fail
> 
> btrfs subvol create test1
> btrfs subvol create test2
> mv test1 test2.
> 
> Thanks to Chris Murphy for catching this,
> 
> Reported-by: Chris Murphy <lists@colorremedies.com>
> Signed-off-by: Josef Bacik <jbacik@fusionio.com>

Looks right to me.

Reviewed-by: Zach Brown <zab@redhat.com>

