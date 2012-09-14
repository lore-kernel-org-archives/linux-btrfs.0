Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([66.114.96.31]:35580 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751597Ab2INOlU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 14 Sep 2012 10:41:20 -0400
Date: Fri, 14 Sep 2012 10:41:17 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Liu Bo <bo.li.liu@oracle.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 1/5] Btrfs: fix deadlock with freeze and sync
Message-ID: <20120914144117.GM12994@localhost.localdomain>
References: <1347613087-3489-1-git-send-email-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1347613087-3489-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 14, 2012 at 02:58:03AM -0600, Liu Bo wrote:
> While testing xfstests 068, I realized that
> 
> commit bd7de2c9a449e26a5493d918618eb20ae60d56bd
> (Btrfs: fix deadlock with freeze and sync V2)
> 
> did not fix the bug yet, since someone might jump in between checking
> running transaction and joining transaction, and we may still run into
> deadlock between freeze and sync.
> 
> So IMO the safest and most efficient way is to check running transaction
> in joining a transaction directly.
> 
> With this patch, I tested xfstests 068 for 120 times and it did not get
> into deadlock at least here.
> 

Ok I've come up with a different way to fix this one and I'm still trying to
reproduce the problem your 2nd patch talks about, but I've taken the other 3 and
pushed them to btrfs-next.  Thanks!

Josef
