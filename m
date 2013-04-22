Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:36906 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755223Ab3DVUiG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 22 Apr 2013 16:38:06 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id EBE067C04D8
	for <linux-btrfs@vger.kernel.org>; Mon, 22 Apr 2013 14:38:05 -0600 (MDT)
Date: Mon, 22 Apr 2013 16:37:40 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Mark Ridley <mark@backupsystems.co.uk>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: 3.8.8 kernel crash while editing a file
Message-ID: <20130422203740.GC2631@localhost.localdomain>
References: <loom.20130422T213104-840@post.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <loom.20130422T213104-840@post.gmane.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Apr 22, 2013 at 01:33:12PM -0600, Mark Ridley wrote:
> Hi,
> 
> This stack trace came out earlier today when I edited a file in perl
> that had a btrfs snapshot.
> 
> Any idea why? or what I can do to get you more info.
> 
> 3.8.8-202.fc18.x86_64 
> 
> The device has 21TB of used data on it.
> 

Can you run btrfsck on the fs and see if it complains about anything?  Thanks,

Josef
