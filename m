Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:25210 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757290AbaEIRdL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 9 May 2014 13:33:11 -0400
Message-ID: <536D1149.2020502@fb.com>
Date: Fri, 9 May 2014 13:32:57 -0400
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: Wang Shilong <wangsl.fnst@cn.fujitsu.com>, <xfs@oss.sgi.com>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v3] xfstests/btrfs: add qgroup rescan stress test
References: <1394423051-17356-1-git-send-email-wangsl.fnst@cn.fujitsu.com> <1399615343-28544-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
In-Reply-To: <1399615343-28544-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 05/09/2014 02:02 AM, Wang Shilong wrote:
> Test flow is to run fsstress after triggering quota rescan.
> the ruler is simple, we just remove all files and directories,
> sync filesystem and see if qgroup's ref and excl are nodesize.
>
> Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
> ---
> v2->v3: addressed comments from josef:
> 	- remove unnecessary redirections
> 	- don't use _run_btrfs_util_prog() when capturing qgroup show output.
> 	- turn off inode_cache mount option explicitly.
>
> v1->v2: switch to _run_btrfs_util_prog()

Perfect thanks Wang,

Reviewed-by: Josef Bacik <jbacik@fb.com>

