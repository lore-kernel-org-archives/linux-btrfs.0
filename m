Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:44871 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752414Ab3H0MQT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 27 Aug 2013 08:16:19 -0400
Received: from /spool/local
	by e23smtp04.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Tue, 27 Aug 2013 21:59:04 +1000
Received: from d23relay04.au.ibm.com (d23relay04.au.ibm.com [9.190.234.120])
	by d23dlp03.au.ibm.com (Postfix) with ESMTP id F1DA53578051
	for <linux-btrfs@vger.kernel.org>; Tue, 27 Aug 2013 22:16:14 +1000 (EST)
Received: from d23av03.au.ibm.com (d23av03.au.ibm.com [9.190.234.97])
	by d23relay04.au.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id r7RC0Aml63373492
	for <linux-btrfs@vger.kernel.org>; Tue, 27 Aug 2013 22:00:10 +1000
Received: from d23av03.au.ibm.com (localhost [127.0.0.1])
	by d23av03.au.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id r7RCGDeV011982
	for <linux-btrfs@vger.kernel.org>; Tue, 27 Aug 2013 22:16:14 +1000
From: chandan <chandan@linux.vnet.ibm.com>
To: Eric Sandeen <sandeen@redhat.com>, Eric Sandeen <sandeen@sandeen.net>
Cc: linux-btrfs@vger.kernel.org, xfs@oss.sgi.com, sekharan@linux.vnet.ibm.com
Subject: Re: [PATCH] xfstests: generic/255: Execute only if blocksize <= 4096
Date: Tue, 27 Aug 2013 17:46:07 +0530
Message-ID: <3942763.p7a9her5Nt@localhost.localdomain>
In-Reply-To: <521B664B.7030404@redhat.com>
References: <2909046.09LYLQvZ6q@localhost.localdomain> <44437668.FEX1DiRokR@localhost.localdomain> <521B664B.7030404@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Monday, August 26, 2013 09:29:31 AM Eric Sandeen wrote:
> 
> Just as a sanity check, does it also fail on xfs for 64k block sizes on ppc64?
> 

Yes, it does fail as shown below:

generic/255      - output mismatch (see /home/chandan/xfstests/results//generic/255.out.bad)
    --- tests/generic/255.out   2013-08-27 06:59:08.241344176 -0400
    +++ /home/chandan/xfstests/results//generic/255.out.bad     2013-08-27 07:01:45.311352161 -0400
    @@ -2,306 +2,202 @@
        1. into a hole
     daa100df6e6711906b61c9ab5aa16032
        2. into allocated space
    -0: [0..7]: extent
    -1: [8..23]: hole
    -2: [24..39]: extent
    +0: [0..127]: extent
     ...
     (Run 'diff -u tests/generic/255.out /home/chandan/xfstests/results//generic/255.out.bad' to see the entire diff)

In this instance, the test basically ends up punching a hole within a block
and hence fails.

- chandan

