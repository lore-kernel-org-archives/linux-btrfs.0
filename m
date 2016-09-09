Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:46214 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751260AbcIIPCD (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 9 Sep 2016 11:02:03 -0400
Subject: Re: bug report about patch "Btrfs: kill the btree_inode"
To: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>,
        David Sterba <dsterba@suse.com>
References: <57D272A5.5050201@cn.fujitsu.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
From: Josef Bacik <jbacik@fb.com>
Message-ID: <687e4285-cbdd-b0c1-23e1-34b47ca5a874@fb.com>
Date: Fri, 9 Sep 2016 11:00:58 -0400
MIME-Version: 1.0
In-Reply-To: <57D272A5.5050201@cn.fujitsu.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 09/09/2016 04:28 AM, Wang Xiaoguang wrote:
> hello,
>
> When we rebase dedupe patches to David's for-next-20160906 branch,
> we found below panic. By bisect, it seems that "Btrfs: kill the btree_inode"
> causing this bug, please check.
> Fstests case btrfs/060 can easily reproduce this bug.

Oops forgot to run with SCRATCH_DEV_POOL.  Thanks I'll fix this up and send out 
the corrected patch,

Josef
