Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:64258 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755372AbaISPCr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 19 Sep 2014 11:02:47 -0400
Message-ID: <541C458E.3080406@fb.com>
Date: Fri, 19 Sep 2014 11:02:38 -0400
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: Liu Bo <bo.li.liu@oracle.com>, <xfs@oss.sgi.com>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] xfstests: remove check_scratch_fs in btrfs/012
References: <1409714759-9805-1-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1409714759-9805-1-git-send-email-bo.li.liu@oracle.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 09/02/2014 11:25 PM, Liu Bo wrote:
> From: Liu Bo <liub.liubo@gmail.com>
>
> btrfs/012 is a case to verify btrfs-convert feature, it converts an ext4 to
> btrfs firstly and do something, then rolls back to ext4.
>
> So at last we have a ext4 on the scratch device, but setting _require_scratch
> will force a btrfsck on a ext4 fs because $FSTYP here is btrfs, and it ends up
> with a failure report of _check_btrfs_filesystem.
>
> Now that we have deliberately check the final ext4 fs in btrfs/012, just do not
> set _require_scratch in this case.
>
> Signed-off-by: Liu Bo <liub.liubo@gmail.com>

I sent a patch for this already, it's on the fs-tests list.  Thanks,

Josef

