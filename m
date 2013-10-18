Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:36536 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750981Ab3JRQOh (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 18 Oct 2013 12:14:37 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id C8BD47C06B4
	for <linux-btrfs@vger.kernel.org>; Fri, 18 Oct 2013 10:14:36 -0600 (MDT)
Date: Fri, 18 Oct 2013 12:14:34 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Roman Mamedov <rm@romanrm.net>
CC: Josef Bacik <jbacik@fusionio.com>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: fix up seek_hole/seek_data handling
Message-ID: <20131018161434.GF6924@localhost.localdomain>
References: <1382111301-3116-1-git-send-email-jbacik@fusionio.com>
 <20131018221115.460375f7@natsu>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20131018221115.460375f7@natsu>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Oct 18, 2013 at 10:11:15PM +0600, Roman Mamedov wrote:
> On Fri, 18 Oct 2013 11:48:21 -0400
> Josef Bacik <jbacik@fusionio.com> wrote:
> 
> > Whoever wrote this was braindead.
> 
> You do realize you sent a number of people googling for "Delalloc is such a
> pain. If we have a hole and we have pending" just out of curiosity? :))
> 

When I say things like this you can just assume it was me who wrote it ;).

Josef

