Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:36735 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763296Ab3ECTFR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 3 May 2013 15:05:17 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 51CBF9A0686
	for <linux-btrfs@vger.kernel.org>; Fri,  3 May 2013 13:05:17 -0600 (MDT)
Date: Fri, 3 May 2013 15:05:14 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Rich Johnston <rjohnston@sgi.com>
CC: Josef Bacik <JBacik@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "xfs@oss.sgi.com" <xfs@oss.sgi.com>
Subject: Re: [PATCH] xfstests 311: test fsync with dm flakey V3
Message-ID: <20130503190514.GD12414@localhost.localdomain>
References: <1367003639-17621-1-git-send-email-jbacik@fusionio.com>
 <51840047.4020908@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <51840047.4020908@sgi.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 03, 2013 at 12:21:59PM -0600, Rich Johnston wrote:
> Thanks for another patch Josef, it has been committed with the change 
> discussed.
> 

Err I forgot to point out I already have a "sync" variable in there so it fails
to compile, we'll need to change the var to do_sync or something.  Want me to
send a patch along?  Thanks,

Josef
