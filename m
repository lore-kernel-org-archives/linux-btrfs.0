Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:46158 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751314AbaDNMqp (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 14 Apr 2014 08:46:45 -0400
Message-ID: <534BD8B8.9000108@fb.com>
Date: Mon, 14 Apr 2014 08:46:48 -0400
From: Chris Mason <clm@fb.com>
MIME-Version: 1.0
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, <linux-btrfs@vger.kernel.org>
CC: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH v2] btrfs: Change the expanding write sequence to fix
 snapshot related bug.
References: <1397443448-20367-1-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1397443448-20367-1-git-send-email-quwenruo@cn.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 04/13/2014 10:44 PM, Qu Wenruo wrote:
> When testing fsstress with snapshot making background, some snapshot
> following problem.
>
> Snapshot 270:
> inode 323: size 0
>
> Snapshot 271:
> inode 323: size 349145
> |-------Hole---|---------Empty gap-------|-------Hole-----|
> 0	    122880			172032	      349145
>
> Snapshot 272:
> inode 323: size 349145
> |-------Hole---|------------Data---------|-------Hole-----|
> 0	    122880			172032	      349145
>
> The fsstress operation on inode 323 is the following:
> write: 		offset 	126832 	len 43124
> truncate: 	size 	349145
>
> Since the write with offset is consist of 2 operations:
> 1. punch hole
> 2. write data
> Hole punching is faster than data write, so hole punching in write
> and truncate is done first and then buffered write, so the snapshot 271 got
> empty gap, which will not pass btrfsck.
>
> To fix the bug, this patch will change the write sequence which will
> first punch a hole covering the write end if a hole is needed.
>
> Reported-by: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
> Cc: Al Viro <viro@ZenIV.linux.org.uk>
> Signed-off-by: Chris Mason <clm@fb.com>
> ---
> changelog:
> v2:
>    Use 'pos + count' instead of 'pos + iov->iov_len' to deal with
> multi-seg iov.

Thanks for the review Al.  Qu, could you please send an incremental?

-chris
