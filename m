Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from relay3.sgi.com ([192.48.152.1]:49036 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756459Ab3ECM2v (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 3 May 2013 08:28:51 -0400
Message-ID: <5183AD53.7030403@sgi.com>
Date: Fri, 3 May 2013 07:28:03 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
To: Josef Bacik <jbacik@fusionio.com>
CC: <linux-btrfs@vger.kernel.org>, <xfs@oss.sgi.com>
Subject: Re: [PATCH] xfstests 311: test fsync with dm flakey V3
References: <1367003639-17621-1-git-send-email-jbacik@fusionio.com>
In-Reply-To: <1367003639-17621-1-git-send-email-jbacik@fusionio.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Josef,

The patch does not compile on older kernels (i.e. SLES11 SP2).

fsync-tester.c: In function 'test_three':
fsync-tester.c:133: warning: implicit declaration of function 'syncfs'
/tmp/cciHR6Gb.o: In function `test_three':
/data/lwork/gulag1c/rjohnston/xfstests/src/fsync-tester.c:133: undefined 
reference to `syncfs'
collect2: ld returned 1 exit status
gmake[3]: *** [fsync-tester] Error 1
gmake[2]: *** [src] Error 2
make[1]: *** [default] Error 2
make: *** [default] Error 2


src/fsync-tester.c
133                                 syncfs(test_fd);
Typo ?????                          ^^^^^^
Did you mean fsync?

Regards,
--Rich

