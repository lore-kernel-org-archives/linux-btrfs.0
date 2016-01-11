Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:34289 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932895AbcAKNzY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Jan 2016 08:55:24 -0500
Date: Mon, 11 Jan 2016 08:55:07 -0500
From: Chris Mason <clm@fb.com>
To: <fdmanana@kernel.org>
CC: <linux-btrfs@vger.kernel.org>, Filipe Manana <fdmanana@suse.com>
Subject: Re: [GIT PULL] More btrfs bug fixes for 4.5
Message-ID: <20160111135507.5qswrrfckj5mxyno@ret.masoncoding.com>
References: <1452253431-29510-1-git-send-email-fdmanana@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1452253431-29510-1-git-send-email-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jan 08, 2016 at 11:43:51AM +0000, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> Hi Chris.
> 
> Please consider the following bug fixes for the 4.5 kernel release.
> Just the usual set of bug fixes. One of these is tagged for stable and it
> fixes a regression introduced in 4.3 that makes a filesystem unbootable
> after a fitrim operation (recently reported by a few openSUSE users).
> These patches were all previously sent to the mailing list as well as a
> new test case for fstests that covers the regression with fitrim.
> 
> Thanks.
> 
> The following changes since commit 511711af91f21d80b27f18b569352d6896562828:
> 
>   btrfs: don't run delayed references while we are creating the free space tree (2015-12-30 07:52:35 -0800)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/fdmanana/linux.git for-chris-4.5

Thanks Filipe, pulling this in.

-chris
