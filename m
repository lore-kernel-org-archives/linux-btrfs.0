Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:53445 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933846Ab3ECRaF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 3 May 2013 13:30:05 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 2F1707C0681
	for <linux-btrfs@vger.kernel.org>; Fri,  3 May 2013 11:30:04 -0600 (MDT)
Date: Fri, 3 May 2013 13:30:01 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Rich Johnston <rjohnston@sgi.com>
CC: Josef Bacik <JBacik@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "xfs@oss.sgi.com" <xfs@oss.sgi.com>
Subject: Re: [PATCH] xfstests 311: test fsync with dm flakey V3
Message-ID: <20130503173001.GC12414@localhost.localdomain>
References: <1367003639-17621-1-git-send-email-jbacik@fusionio.com>
 <5183AD53.7030403@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <5183AD53.7030403@sgi.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 03, 2013 at 06:28:03AM -0600, Rich Johnston wrote:
> Josef,
> 
> The patch does not compile on older kernels (i.e. SLES11 SP2).
> 
> fsync-tester.c: In function 'test_three':
> fsync-tester.c:133: warning: implicit declaration of function 'syncfs'
> /tmp/cciHR6Gb.o: In function `test_three':
> /data/lwork/gulag1c/rjohnston/xfstests/src/fsync-tester.c:133: undefined 
> reference to `syncfs'
> collect2: ld returned 1 exit status
> gmake[3]: *** [fsync-tester] Error 1
> gmake[2]: *** [src] Error 2
> make[1]: *** [default] Error 2
> make: *** [default] Error 2
> 
> 
> src/fsync-tester.c
> 133                                 syncfs(test_fd);
> Typo ?????                          ^^^^^^
> Did you mean fsync?
> 

Argh crap I should have noticed this in the manpage

syncfs() first appeared in Linux 2.6.39

You can just replace it with sync(), or do you want me to resend the patch with
that change?  Thanks,

Josef
