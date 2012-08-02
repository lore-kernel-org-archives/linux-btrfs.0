Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.fusionio.com ([66.114.96.30]:48792 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752833Ab2HBMMB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 2 Aug 2012 08:12:01 -0400
Date: Thu, 2 Aug 2012 08:11:58 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Liu Bo <liub.liubo@gmail.com>
CC: Josef Bacik <JBacik@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: barrier before waitqueue_active
Message-ID: <20120802121158.GF2263@localhost.localdomain>
References: <1343852708-24009-1-git-send-email-jbacik@fusionio.com>
 <501A5A94.7070307@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <501A5A94.7070307@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 02, 2012 at 04:46:44AM -0600, Liu Bo wrote:
> On 08/02/2012 04:25 AM, Josef Bacik wrote:
> > We need an smb_mb() before waitqueue_active to avoid missing wakeups.
> > Before Mitch was hitting a deadlock between the ordered flushers and the
> > transaction commit because the ordered flushers were waiting for more refs
> > and were never woken up, so those smp_mb()'s are the most important.
> > Everything else I added for correctness sake and to avoid getting bitten by
> > this again somewhere else.  Thanks,
> > 
> 
> Hi Josef,
> 
> I'll appreciate a lot if you can add some comments for each memory
> barrier, because not everyone knows why it is used here and there. :)
> 

I'm not going to add comments to all those places, you need a memory barrier in
places you don't have an implicit barrier before you do waitqueue_active because
you could miss somebody being added to the waitqueue, it's just basic
correctness.  Thanks,

Josef
