Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:34465 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752938AbaKMPpX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 13 Nov 2014 10:45:23 -0500
Message-ID: <5464D20B.3040101@fb.com>
Date: Thu, 13 Nov 2014 10:45:15 -0500
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: Filipe Manana <fdmanana@suse.com>, <fstests@vger.kernel.org>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v2] fstests: btrfs, add test for snapshoting after file
 write + truncate
References: <1413886389-16144-1-git-send-email-fdmanana@suse.com> <1414323543-31557-1-git-send-email-fdmanana@suse.com>
In-Reply-To: <1414323543-31557-1-git-send-email-fdmanana@suse.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 10/26/2014 07:39 AM, Filipe Manana wrote:
> Regression test for a btrfs issue where if right after the snapshot
> creation ioctl started, a file write followed by a file truncate
> happened, with both operations increasing the file's size, the created
> snapshot would capture an inconsistent state of the file system tree.
> That state reflected the file truncation but it didn't reflect the
> write operation, and left a gap between two file extent items (and
> that gap corresponded to the total or a partial area of the write
> operation's range).
>
> This issue was fixed by the following linux kernel patch:
>
>      Btrfs: fix snapshot inconsistency after a file write followed by truncate
>
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Ran with and without the patch applied to make sure it did the right 
thing, the test looks sane.  Thanks for this

Reviewed-by: Josef Bacik <jbacik@fb.com>

