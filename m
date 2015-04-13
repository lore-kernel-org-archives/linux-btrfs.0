Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:7365 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752268AbbDMO4b (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 13 Apr 2015 10:56:31 -0400
Message-ID: <552BD8C1.3000400@fb.com>
Date: Mon, 13 Apr 2015 10:54:57 -0400
From: Chris Mason <clm@fb.com>
MIME-Version: 1.0
To: Zhaolei <zhaolei@cn.fujitsu.com>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 8/9] btrfs: wait for delayed iputs on no space
References: <cover.1428554022.git.zhaolei@cn.fujitsu.com> <4a2f9c8918b1386ef6296d52ee4e331b7099b247.1428554023.git.zhaolei@cn.fujitsu.com>
In-Reply-To: <4a2f9c8918b1386ef6296d52ee4e331b7099b247.1428554023.git.zhaolei@cn.fujitsu.com>
Content-Type: text/plain; charset="windows-1252"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 04/09/2015 12:34 AM, Zhaolei wrote:
> From: Zhao Lei <zhaolei@cn.fujitsu.com>
> 
> btrfs will report no_space when we run following write and delete
> file loop:
>  # FILE_SIZE_M=[ 75% of fs space ]
>  # DEV=[ some dev ]
>  # MNT=[ some dir ]
>  #
>  # mkfs.btrfs -f "$DEV"
>  # mount -o nodatacow "$DEV" "$MNT"
>  # for ((i = 0; i < 100; i++)); do dd if=/dev/zero of="$MNT"/file0 bs=1M count="$FILE_SIZE_M"; rm -f "$MNT"/file0; done
>  #
> 
> Reason:
>  iput() and evict() is run after write pages to block device, if
>  write pages work is not finished before next write, the "rm"ed space
>  is not freed, and caused above bug.
> 
> Fix:
>  We can add "-o flushoncommit" mount option to avoid above bug, but
>  it have performance problem. Actually, we can to wait for on-the-fly
>  writes only when no-space happened, it is which this patch do.

Can you please change this so we only do this flush if the first commit
doesn't free up enough space?  I think this is going to have a
performance impact as the FS fills up.

-chris

