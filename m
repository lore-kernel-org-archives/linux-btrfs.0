Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:3362 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752938AbaKMPxa (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 13 Nov 2014 10:53:30 -0500
Message-ID: <5464D3F4.6030706@fb.com>
Date: Thu, 13 Nov 2014 10:53:24 -0500
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: Filipe Manana <fdmanana@suse.com>, <fstests@vger.kernel.org>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v2] fstests: btrfs, add regression test for clone ioctl
References: <1413924191-30467-1-git-send-email-fdmanana@suse.com> <1415619766-30814-1-git-send-email-fdmanana@suse.com>
In-Reply-To: <1415619766-30814-1-git-send-email-fdmanana@suse.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 11/10/2014 06:42 AM, Filipe Manana wrote:
> Regression test for a btrfs clone ioctl issue where races between
> a clone operation and concurrent target file reads would result in
> leaving stale data in the page cache. After the clone operation
> finished, reading from the clone target file would return the old
> and no longer valid data. This affected only buffered reads (i.e.
> didn't affect direct IO reads).
>
> This issue was fixed by the following linux kernel patch:
>
>      Btrfs: ensure readers see new data after a clone operation
>      (commit c125b8bff1d9f6c8c91ce4eb8bd5616058c7d510)
>
> Signed-off-by: Filipe Manana <fdmanana@suse.com>
> ---

Verified and the test looks sane, you can add

Reviewed-by: Josef Bacik <jbacik@fb.com>

