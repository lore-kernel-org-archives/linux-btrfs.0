Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:58092 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932855AbcCaVNN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 31 Mar 2016 17:13:13 -0400
Date: Thu, 31 Mar 2016 17:13:07 -0400
From: Chris Mason <clm@fb.com>
To: <fdmanana@kernel.org>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v2] Btrfs: fix file/data loss caused by fsync after
 rename and new inode
Message-ID: <20160331211307.li3fhk2dav34hs2f@floor.thefacebook.com>
References: <1459330710-3181-1-git-send-email-fdmanana@kernel.org>
 <1459377441-3609-1-git-send-email-fdmanana@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1459377441-3609-1-git-send-email-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Mar 30, 2016 at 11:37:21PM +0100, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> If we rename an inode A (be it a file or a directory), create a new
> inode B with the old name of inode A and under the same parent directory,
> fsync inode B and then power fail, at log tree replay time we end up
> removing inode A completely. If inode A is a directory then all its files
> are gone too.
> 
> Example scenarios where this happens:
> This is reproducible with the following steps, taken from a couple of
> test cases written for fstests which are going to be submitted upstream
> soon:

Thanks Filipe!  Since this is an older bug, I won't rush it into
tomorrow's pull, but I'll test and get it into next week.

-chris
