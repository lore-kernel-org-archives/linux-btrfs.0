Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:52092 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758613Ab3BTPjF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 Feb 2013 10:39:05 -0500
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 196B09A0691
	for <linux-btrfs@vger.kernel.org>; Wed, 20 Feb 2013 08:39:04 -0700 (MST)
Date: Wed, 20 Feb 2013 10:39:01 -0500
From: Chris Mason <chris.mason@fusionio.com>
To: Alex Lyakas <alex.btrfs@zadarastorage.com>
CC: Josef Bacik <JBacik@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: LAST CALL FOR BTRFS-NEXT
Message-ID: <20130220153901.GB21291@shiny.masoncoding.com>
References: <20130220142612.GA2062@localhost.localdomain>
 <20130220151227.GA27541@twin.jikos.cz>
 <CAOcd+r3Qk+bAAS3ZVzF826MPpSEFHe5Z1U8vMFKwPJyVUw-qTA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <CAOcd+r3Qk+bAAS3ZVzF826MPpSEFHe5Z1U8vMFKwPJyVUw-qTA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Feb 20, 2013 at 08:35:30AM -0700, Alex Lyakas wrote:
> Hi Josef,
> can you please consider including these two patches from Jan 28:
> https://patchwork.kernel.org/patch/2057051/
> https://patchwork.kernel.org/patch/2057071/
> 
> I realize they have "V2" label, although the cover letter had "V3",
> this was my bad. However, they both apply to what you have now in
> btrfs-next.

It's really ok if we add more after I pull in the current next, but I
don't want to have to rebase the current next again.  So, I'd rather
that we focus on patches currently in -next and make sure they are the
correct versions etc.

-chris
