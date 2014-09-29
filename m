Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:37109 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752310AbaI2QKt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 29 Sep 2014 12:10:49 -0400
Date: Mon, 29 Sep 2014 18:10:47 +0200
From: David Sterba <dsterba@suse.cz>
To: Omar Sandoval <osandov@osandov.com>
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] btrfs: fix sparse lock context warnings
Message-ID: <20140929161047.GD11436@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1411894092-28784-1-git-send-email-osandov@osandov.com>
 <1411894092-28784-3-git-send-email-osandov@osandov.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1411894092-28784-3-git-send-email-osandov@osandov.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Sep 28, 2014 at 01:48:12AM -0700, Omar Sandoval wrote:
> Fix several sparse warnings that can easily be addressed with context
> annotations. These annotations also provide some sort of documentation for the
> internal helper functions.
> 
> Signed-off-by: Omar Sandoval <osandov@osandov.com>

Reviewed-by: David Sterba <dsterba@suse.cz>
