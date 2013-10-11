Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:46162 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751932Ab3JKOWd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 11 Oct 2013 10:22:33 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 6F2AA9A069F
	for <linux-btrfs@vger.kernel.org>; Fri, 11 Oct 2013 08:22:33 -0600 (MDT)
Date: Fri, 11 Oct 2013 10:22:31 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Stefan Behrens <sbehrens@giantdisaster.de>
CC: Josef Bacik <jbacik@fusionio.com>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: fail device statistic reset on read-only
 filesystem
Message-ID: <20131011142231.GB5095@localhost.localdomain>
References: <2a649d6a51055ac36352a73add403037acc537ef.1381493768.git.sbehrens@giantdisaster.de>
 <20131011134733.GA5095@localhost.localdomain>
 <52580629.90307@giantdisaster.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <52580629.90307@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Oct 11, 2013 at 04:07:37PM +0200, Stefan Behrens wrote:
> On Fri, 11 Oct 2013 09:47:33 -0400, Josef Bacik wrote:
> > Hey look something else that should go into xfstests,
> 
> I don't think so. It's a bug that is there from the very beginning, not
> a regression. We can't catch all possible errors (non-regressions) with
> xfstests. We would spend all time for writing xfstests, there wouldn't
> be any time left to actually add bugs.
> 

Sure it's been there forever, but now that we've fixed it I'd like to make sure
we don't ever have to fix it again.

Josef
