Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:14207 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750881AbaAWXsK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 23 Jan 2014 18:48:10 -0500
Message-ID: <52E1AA35.4050803@fb.com>
Date: Thu, 23 Jan 2014 18:48:05 -0500
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: Filipe David Borba Manana <fdmanana@gmail.com>, <xfs@oss.sgi.com>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v3] xfstests: add test for btrfs incremental send infinite
 loop issue
References: <1390348610-8098-1-git-send-email-fdmanana@gmail.com> <1390520280-19282-1-git-send-email-fdmanana@gmail.com>
In-Reply-To: <1390520280-19282-1-git-send-email-fdmanana@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On 01/23/2014 06:38 PM, Filipe David Borba Manana wrote:
> Regression test for btrfs' incremental send feature:
>
> 1) Create several nested directories;
>
> 2) Create a read only snapshot;
>
> 3) Change the parentship of some of the deepest directories in a reverse
>     way, so that parents become children and children become parents;
>
> 4) Create another read only snapshot and use it for an incremental send
>     relative to the first snapshot.
>
> At step 4 btrfs' send entered an infinite loop, increasing the memory it
> used while building path strings until a krealloc was unable to allocate
> more memory, which caused a warning dump in dmesg.
>
> The following linux kernel patch fixes this issue.
>
>     Btrfs: fix infinite path build loops in incremental send
>     (https://patchwork.kernel.org/patch/3522361/)
>
> Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>

Reviewed-by: Josef Bacik <jbacik@fb.com>

Thanks,

Josef
