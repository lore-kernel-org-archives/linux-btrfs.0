Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([66.114.96.31]:36289 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758577Ab2JZMTo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 26 Oct 2012 08:19:44 -0400
Date: Fri, 26 Oct 2012 08:19:41 -0400
From: Chris Mason <chris.mason@fusionio.com>
To: Jan Schmidt <list.btrfs@jan-o-sch.net>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: BUG in btrfs_set_item_key_safe
Message-ID: <20121026121941.GB23729@shiny>
References: <508A2F3F.3030500@jan-o-sch.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <508A2F3F.3030500@jan-o-sch.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Oct 26, 2012 at 12:35:43AM -0600, Jan Schmidt wrote:
> Hi,
> 
> while running extensive qgroup and tree mod log tests I got to the following
> BUG, which is probably not related to tree mod log:

So our keys are out of order...are you able to reproduce this?

-chris
