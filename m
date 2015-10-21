Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47381 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753822AbbJULfp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 21 Oct 2015 07:35:45 -0400
Date: Wed, 21 Oct 2015 13:34:24 +0200
From: David Sterba <dsterba@suse.cz>
To: Eryu Guan <guaneryu@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 05/10] btrfs-progs: mute coverity warnings about deadcode
Message-ID: <20151021113424.GE13624@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1445254680-11102-1-git-send-email-guaneryu@gmail.com>
 <1445254680-11102-6-git-send-email-guaneryu@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1445254680-11102-6-git-send-email-guaneryu@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Oct 19, 2015 at 07:37:55PM +0800, Eryu Guan wrote:
> Coverity reports execution cannot reach this statements. So put WARN_ON
> in if-else conditions.
> 
> Signed-off-by: Eryu Guan <guaneryu@gmail.com>

Applied, thanks.
