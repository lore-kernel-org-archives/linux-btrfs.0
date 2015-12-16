Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:52843 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932379AbbLPRdW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 16 Dec 2015 12:33:22 -0500
Date: Wed, 16 Dec 2015 12:33:12 -0500
From: Chris Mason <clm@fb.com>
To: <fdmanana@kernel.org>
CC: <linux-btrfs@vger.kernel.org>, Filipe Manana <fdmanana@suse.com>
Subject: Re: [GIT PULL] Btrfs fixes for 4.4
Message-ID: <20151216173312.GF6322@ret.masoncoding.com>
References: <1449747890-26516-1-git-send-email-fdmanana@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1449747890-26516-1-git-send-email-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Dec 10, 2015 at 11:44:50AM +0000, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> Hi Chris,
> 
> Please consider the following fixes for kernel 4.4. Two of them are fixes
> to new issues introduced in the 4.4 merge window and 4.4 release candidates.
> The other one just fixes a warning message that is confusing and has made
> several users wonder if they are supposed to do anything or not when we
> fail to read a space cache.
> All these fixes have been previously sent to the mailing list.

Thanks Filipe, I tested these and pushed out, along with my two from
this week.

-chris
