Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:36743 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753544AbaCRISO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 18 Mar 2014 04:18:14 -0400
Received: from /spool/local
	by e23smtp09.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Tue, 18 Mar 2014 18:18:12 +1000
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [9.190.235.21])
	by d23dlp03.au.ibm.com (Postfix) with ESMTP id 6850A3578054
	for <linux-btrfs@vger.kernel.org>; Tue, 18 Mar 2014 19:18:10 +1100 (EST)
Received: from d23av03.au.ibm.com (d23av03.au.ibm.com [9.190.234.97])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id s2I8HuvX11469260
	for <linux-btrfs@vger.kernel.org>; Tue, 18 Mar 2014 19:17:56 +1100
Received: from d23av03.au.ibm.com (localhost [127.0.0.1])
	by d23av03.au.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id s2I8I9ZU016919
	for <linux-btrfs@vger.kernel.org>; Tue, 18 Mar 2014 19:18:09 +1100
From: chandan <chandan@linux.vnet.ibm.com>
To: dsterba@suse.cz
Cc: linux-btrfs@vger.kernel.org, aneesh.kumar@linux.vnet.ibm.com
Subject: Re: [PATCH 0/6 EARLY RFC] Btrfs: Get rid of whole page I/O.
Date: Tue, 18 Mar 2014 13:48 +0630
Message-ID: <1785327.CGV06aaKrn@localhost.localdomain>
In-Reply-To: <20140317145555.GG29256@twin.jikos.cz>
References: <1394634033-2528-1-git-send-email-chandan@linux.vnet.ibm.com> <20140317145555.GG29256@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello David,

> I looked at previous postings of this patchset, but haven't found what
> are the expected supported block sizes.
> 
> I assume powers of two starting with 512b, until 64k.

The earlier patchset posted by Chandra Seethraman was to get 4k
blocksize to work with ppc64's 64k PAGE_SIZE. I chose to do 2k
blocksize on x86_64's 4k PAGE_SIZE since that would allow others in
the community to work/experiment with subpagesize-blocksize feature.

The root node of "tree root" tree has 1957 bytes being written by
make_btrfs() (in btrfs-progs).  Hence I chose to do 2k blocksize for
the initial subpagesize-blocksize work. So with this patchset the
supported blocksizes would be in the range 2k-64k.

Thanks,
chandan

