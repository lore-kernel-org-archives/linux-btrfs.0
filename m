Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:46785 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754253Ab3DXO7L (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 24 Apr 2013 10:59:11 -0400
Date: Wed, 24 Apr 2013 16:59:08 +0200
From: David Sterba <dsterba@suse.cz>
To: Josef Bacik <jbacik@fusionio.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: add tree block level sanity check
Message-ID: <20130424145908.GE16427@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1366731099-1940-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1366731099-1940-1-git-send-email-jbacik@fusionio.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Apr 23, 2013 at 11:31:39AM -0400, Josef Bacik wrote:
> With a users corrupted fs I was getting weird behavior and panics and it turns
> out it was because one of his tree blocks had a bogus header level.  So add this
> to the sanity checks in the endio handler for tree blocks.  Thanks,
> 
> Signed-off-by: Josef Bacik <jbacik@fusionio.com>

Reviewed-by: David Sterba <dsterba@suse.cz>
