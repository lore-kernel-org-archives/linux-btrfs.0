Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:34380 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755471Ab3HZFib (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 26 Aug 2013 01:38:31 -0400
Received: from /spool/local
	by e28smtp09.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Mon, 26 Aug 2013 11:02:29 +0530
Received: from d28relay01.in.ibm.com (d28relay01.in.ibm.com [9.184.220.58])
	by d28dlp01.in.ibm.com (Postfix) with ESMTP id 6853EE0054
	for <linux-btrfs@vger.kernel.org>; Mon, 26 Aug 2013 11:09:00 +0530 (IST)
Received: from d28av03.in.ibm.com (d28av03.in.ibm.com [9.184.220.65])
	by d28relay01.in.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id r7Q5e1d426673364
	for <linux-btrfs@vger.kernel.org>; Mon, 26 Aug 2013 11:10:02 +0530
Received: from d28av03.in.ibm.com (localhost [127.0.0.1])
	by d28av03.in.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id r7Q5cO7M020394
	for <linux-btrfs@vger.kernel.org>; Mon, 26 Aug 2013 11:08:25 +0530
From: chandan <chandan@linux.vnet.ibm.com>
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-btrfs@vger.kernel.org, xfs@oss.sgi.com, sekharan@linux.vnet.ibm.com
Subject: Re: [PATCH] xfstests: generic/255: Execute only if blocksize <= 4096
Date: Mon, 26 Aug 2013 11:08:24 +0530
Message-ID: <44437668.FEX1DiRokR@localhost.localdomain>
In-Reply-To: <521A36C6.40006@sandeen.net>
References: <2909046.09LYLQvZ6q@localhost.localdomain> <521A36C6.40006@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sunday, August 25, 2013 11:54:30 AM Eric Sandeen wrote:
> Can you explain why this is necessary?
> 
> What failures do you see, on what filesystems?

generic/255 currently fails on Btrfs on a ppc64 machine with 64k page size and
hence 64k block size.

generic/255 has been written to test the corner cases for 4k block size. I did
try to make it work with variable sized block sizes, But I got stuck
working with md5sum (since we would need two sets of md5sums, due to
_test_generic_punch() being invoked with and without '-k' option per block
size). 

Since 4k block size support for Btrfs on ppc64 is already being worked on, I
think its better to prevent execution of generic/255 for block sizes greater
than 4k.

Apologies for not including the above description in the patch.

- chandan

