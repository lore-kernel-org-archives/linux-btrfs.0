Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:46143 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751476Ab3HMOOL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 13 Aug 2013 10:14:11 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 24FDA9A06A7
	for <linux-btrfs@vger.kernel.org>; Tue, 13 Aug 2013 08:14:11 -0600 (MDT)
Date: Tue, 13 Aug 2013 10:14:08 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Duncan <1i5t5.duncan@cox.net>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: don't allow a subvol to be deleted if it is the
 default subovl
Message-ID: <20130813141408.GE2150@localhost.localdomain>
References: <1376336375-20631-1-git-send-email-jbacik@fusionio.com>
 <pan$445b2$64e1e159$c2f6f85b$84d1e879@cox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <pan$445b2$64e1e159$c2f6f85b$84d1e879@cox.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Aug 13, 2013 at 04:54:32AM +0000, Duncan wrote:
> Josef Bacik posted on Mon, 12 Aug 2013 15:39:35 -0400 as excerpted:
> 
> > Fix this by adding a check to see if our default subvol points to the
> > subvol we are trying to delete, and if it does not allowing it to
> > happen.
> 
> Umm... not to be a grammar policeman, but...
> 
> That last sub-sentence REALLY (!!) needs another comma:
> 
> ... and if it does, not allowing it to happen.
> 
> or
> 
> ... and if it does not, allowing it to happen.
>

I'll fix it up in git, sorry English isn't my first language.  Thanks,

Josef 
