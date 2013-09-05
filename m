Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:51743 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754615Ab3IESo4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 5 Sep 2013 14:44:56 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 0FFBE7C042D
	for <linux-btrfs@vger.kernel.org>; Thu,  5 Sep 2013 12:44:56 -0600 (MDT)
Date: Thu, 5 Sep 2013 14:44:53 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Eric Sandeen <sandeen@redhat.com>
CC: =?utf-8?B?0KLQuNC80L7RhNC10Lkg0KLQuNGC0L7QstC10YY=?=
	<nefelim4ag@gmail.com>,
        <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs-convert won't convert ext* - No valid Btrfs found on
 /dev/sdb1
Message-ID: <20130905184453.GF15634@localhost.localdomain>
References: <CAGqmi74L9WrifDROz7Mr4r3BxqDWiyiQqy0Wn6JBdfz17qDY9A@mail.gmail.com>
 <5228A713.6060003@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
In-Reply-To: <5228A713.6060003@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Sep 05, 2013 at 10:45:23AM -0500, Eric Sandeen wrote:
> On 9/5/13 9:43 AM, Тимофей Титовец wrote:
> > Hello guys, i try to convert ext4 volume, but btrfs-convert show me error:
> > "No valid Btrfs found on file
> > unable to open ctree
> > conversion aborted."
> > Ubuntu 13.04
> > Kernel: 3.11
> > btrfs-progs git version 0.20-git20130822~194aa4a13
> > 
> > way to reproduce error:
> > $ truncate -s 4G file
> > $ mkfs.ext4 file #say yes to create fs on non block device.
> > $ btrfs-convert file
> >  No valid Btrfs found on file
> >  unable to open ctree
> >  conversion aborted.
> 
> This was a regression around July 3; there was no regression test at
> the time.
> 
> [615f2867854c186a37cb2e2e5a2e13e9ed4ab0df] Btrfs-progs: cleanup similar code in open_ctree_* and close_ctree
> 
> broke it.
> 
> Patches were sent to the list to fix it on July 17,
> 
> https://patchwork.kernel.org/patch/2828820/
> 
> but they haven't been merged into the main repo.
> 
> I sent a regression test for it to the list on Aug 4, but nobody
> reviewed it, so it hasn't been merged into the test suite, either.
> 
> Winning all around!

Alright, alright I'll review it, Jesus.  ;),

Josef
