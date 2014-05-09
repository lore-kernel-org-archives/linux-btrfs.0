Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:59217 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757025AbaEIRYx (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 9 May 2014 13:24:53 -0400
Message-ID: <536D0F56.8040604@fb.com>
Date: Fri, 9 May 2014 13:24:38 -0400
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
CC: "xfs@oss.sgi.com" <xfs@oss.sgi.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v2 1/3] xfstests/btrfs: add qgroup rescan stress test
References: <1394423051-17356-1-git-send-email-wangsl.fnst@cn.fujitsu.com> <536A9E73.90802@fb.com> <536AFC3B.7070502@cn.fujitsu.com> <536BCDF7.7070404@fb.com>,<536C2C99.6020506@cn.fujitsu.com> <xmifb9cukl6cxjty7n8malrf.1399601580721@email.android.com> <536C40E7.5090502@cn.fujitsu.com>
In-Reply-To: <536C40E7.5090502@cn.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 05/08/2014 10:43 PM, Wang Shilong wrote:
> On 05/09/2014 10:13 AM, Josef Bacik wrote:
>> The inode cache is saved in the FS tree itself for every individual FS
>> tree, that affects the sizes reported by qgroup show so we need to
>> explicitly turn it off to get consistent values.  Thanks,
> Right, so we need turn off inode_cache explicitly rather than free_space
> option.
> I will fix all your addressed comments and resend the patch.
>

Sigh I totally said nospace_cache didn't I?  I really meant 
noinode_cache, sorry,

Josef

