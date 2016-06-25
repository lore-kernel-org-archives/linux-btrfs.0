Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:55938 "EHLO
	mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751080AbcFYFp5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 25 Jun 2016 01:45:57 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
	by mx0b-001b2d01.pphosted.com (8.16.0.11/8.16.0.11) with SMTP id u5P5iF0o083862
	for <linux-btrfs@vger.kernel.org>; Sat, 25 Jun 2016 01:45:56 -0400
Received: from e23smtp05.au.ibm.com (e23smtp05.au.ibm.com [202.81.31.147])
	by mx0b-001b2d01.pphosted.com with ESMTP id 23skjwgjd3-1
	(version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Sat, 25 Jun 2016 01:45:56 -0400
Received: from localhost
	by e23smtp05.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Sat, 25 Jun 2016 15:45:53 +1000
Received: from d23relay08.au.ibm.com (d23relay08.au.ibm.com [9.185.71.33])
	by d23dlp03.au.ibm.com (Postfix) with ESMTP id 2E5413578056
	for <linux-btrfs@vger.kernel.org>; Sat, 25 Jun 2016 15:45:51 +1000 (EST)
Received: from d23av06.au.ibm.com (d23av06.au.ibm.com [9.190.235.151])
	by d23relay08.au.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id u5P5jp6t7733616
	for <linux-btrfs@vger.kernel.org>; Sat, 25 Jun 2016 15:45:51 +1000
Received: from d23av06.au.ibm.com (localhost [127.0.0.1])
	by d23av06.au.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id u5P5joPF023442
	for <linux-btrfs@vger.kernel.org>; Sat, 25 Jun 2016 15:45:51 +1000
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Qu Wenruo <quwenruo@cn.fujitsu.com>, dsterba@suse.cz,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v11 00/13] Btrfs dedupe framework
Date: Sat, 25 Jun 2016 11:15:39 +0530
In-Reply-To: <fe84125c-12e6-3425-7948-73819a891e77@gmx.com>
References: <20160615021001.9588-1-quwenruo@cn.fujitsu.com> <2530830.B25feXa6fV@reserved-192-168-1-6.rchland.ibm.com> <fe84125c-12e6-3425-7948-73819a891e77@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-Id: <1761846.d56ix9Vzn2@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Saturday, June 25, 2016 09:22:44 AM Qu Wenruo wrote:
> 
> On 06/24/2016 05:29 PM, Chandan Rajendra wrote:
> > On Friday, June 24, 2016 10:50:41 AM Qu Wenruo wrote:
> >> Hi Chandan, David,
> >>
> >> When I'm trying to rebase dedupe patchset on top of Chadan's sub page
> >> size patchset (using David's for-next-test-20160620), although the
> >> rebase itself is quite simple, but I'm afraid that I found some bugs for
> >> sub page size patchset, *without* dedupe patchset applied.
> >>
> >> These bugs seems to be unrelated to each other
> >> 1) state leak at btrfs rmmod time
> >
> > The leak was due to not freeing 'cached_state' in
> > read_extent_buffer_pages(). I have fixed this and the fix will be part of the
> > patchset when I post the next version to the mailing list.
> >
> > I have always compiled the btrfs code as part of the vmlinux image and hence
> > have never rmmod the btrfs module during my local testing. The space leak
> > messages might have appeared when I shut down my guest. Hence I had never
> > noticed them before. Thanks once again for informing me about it.
> >
> >> 2) bytes_may_use leak at qgroup EDQUOTA error time
> >
> > I have a slightly older version of btrfs-progs which does not yet have btrfs
> > dedupe" command. I will get the new version and check if the space leak can be
> > reproduced on my machine.
> >
> > However, I don't see the space leak warning messages when the reproducer
> > script is executed after commenting out "btrfs dedupe enable $mnt".
> 
> Strange.
> That dedupe command is not useful at all, as I'm using the branch 
> without the dedupe patchset.
> Even with btrfs-progs dedupe patchset, dedupe enable only output ENOTTY 
> error message.
> 
> I'll double check if it's related to the dedupe.
> 
> BTW, are you testing with 4K page size?

Yes, I executed the script with 4k page size. I had based my patchset on top
of 4.7-rc2 kernel. If you are interested, you can get the kernel sources at
'https://github.com/chandanr/linux subpagesize-blocksize'.

I will soon rebase my patchset on David's master branch. I will let you know
if I hit the space leak issue on the rebased kernel.

-- 
chandan

