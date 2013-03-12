Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:59125 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932532Ab3CLT0n (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Mar 2013 15:26:43 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id A1A179A04E9
	for <linux-btrfs@vger.kernel.org>; Tue, 12 Mar 2013 13:26:42 -0600 (MDT)
Received: from mail1.int.fusionio.com (mail1.int.fusionio.com [10.101.1.21]) by mx1.fusionio.com with ESMTP id KBPYW4Tvw6dYQXsQ (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Tue, 12 Mar 2013 13:26:42 -0600 (MDT)
Date: Tue, 12 Mar 2013 15:26:40 -0400
From: Chris Mason <chris.mason@fusionio.com>
To: Josef Bacik <jbacik@fusionio.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Btrfs-progs: Update btrfs restore so it matches all current
 development
Message-ID: <20130312192640.GD12725@shiny.masoncoding.com>
References: <1363109897-7931-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1363109897-7931-1-git-send-email-jbacik@fusionio.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 12, 2013 at 11:38:07AM -0600, Josef Bacik wrote:
> Hello,
> 
> I noticed today that a bunch of work that had been done to restore last year
> wasn't in the normal btrfs-progs restore.  So this work forward ports all of the
> patches that were missing, and redoes a bunch of the work that was done to deal
> with really broken file systems so that it uses more of the generic helpers that
> Chris wrote a while ago.  This is based on the latest integration branch, Dave
> if you want to just pull you can do
> 
> git://github.com/josefbacik/btrfs-progs.git for-kdave

Thanks Josef, this seems like a great time for me to pull integration
again.

-chris
