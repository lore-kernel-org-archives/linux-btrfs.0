Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:32927 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753044AbcHCNcN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 3 Aug 2016 09:32:13 -0400
Subject: Re: [GIT PULL] Btrfs fixes for 4.8
To: <fdmanana@kernel.org>, <linux-btrfs@vger.kernel.org>
References: <1470220277-28026-1-git-send-email-fdmanana@kernel.org>
CC: Filipe Manana <fdmanana@suse.com>
From: Chris Mason <clm@fb.com>
Message-ID: <273e4a84-de08-8b38-0d5b-ef32537a8a46@fb.com>
Date: Wed, 3 Aug 2016 09:31:17 -0400
MIME-Version: 1.0
In-Reply-To: <1470220277-28026-1-git-send-email-fdmanana@kernel.org>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 08/03/2016 06:31 AM, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
>
> Hi Chris,
>
> Please consider the following small set of fixes for the 4.8 kernel.
> These are mostly send fixes, some of them reported and sent by Robbie Ko a
> long time ago, which I reviewed, updated (specially the change logs) and
> tested. All of these already have test cases in xfstests. The rest are
> just some fsync related fixes and a cleanup. These have all been sent to
> the mailing list before and were rebased against your 'next' branch.

Thanks Filipe!  Since these are all fixes, I'll queue up for rc2.  My 
second rc1 pull will go out today.

-chris
