Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:53481 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753878Ab3JIQ1I (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 9 Oct 2013 12:27:08 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 75F9F9A06B9
	for <linux-btrfs@vger.kernel.org>; Wed,  9 Oct 2013 10:27:08 -0600 (MDT)
Date: Wed, 9 Oct 2013 12:27:06 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Chris Murphy <lists@colorremedies.com>
CC: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: regression, can't move subvols into subvols
Message-ID: <20131009162706.GG16461@localhost.localdomain>
References: <459265C7-5E22-4F5B-A69C-A5A6AC455495@colorremedies.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
In-Reply-To: <459265C7-5E22-4F5B-A69C-A5A6AC455495@colorremedies.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Oct 08, 2013 at 03:58:23PM -0600, Chris Murphy wrote:
> I don't think this is expected, is it? I can no longer move a subvolume into another subvolume. I can move a subvolume into a directory. This happens with 3.11.3, and 3.12 rc4. I'm not sure yet when the regression first appeared.
> 
> Example move subvol to subvol, where home is a subvolume that contains files, and f20inprogress is a newly created (empty) subvolume.
> 
> [root@f20s btrfs]# mv home f20inprogress
> mv: cannot move ‘home’ to ‘f20inprogress/home’: File exists
> 

Fixed it with

[PATCH] Btrfs: use right root when checking for hash collision

Sorry about that.

Josef
