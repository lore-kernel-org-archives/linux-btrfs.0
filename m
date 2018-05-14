Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:35868 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752296AbeENQKl (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 14 May 2018 12:10:41 -0400
From: Chris Mason <clm@fb.com>
To: Liu Bo <bo.liu@linux.alibaba.com>
CC: Qu Wenruo <quwenruo.btrfs@gmx.com>, <linux-btrfs@vger.kernel.org>
Subject: Re: verify key failure
Date: Mon, 14 May 2018 12:10:26 -0400
Message-ID: <99A8759B-68EA-480F-A95D-DF2496B5E767@fb.com>
In-Reply-To: <20180514143510.x5hwstlzm2lpeiqx@US-160370MP2.local>
References: <20180514143510.x5hwstlzm2lpeiqx@US-160370MP2.local>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 14 May 2018, at 10:35, Liu Bo wrote:

> Hi,
>
> I got another warning of verify_level_key by running btrfs/124 in a 
> loop, I'm testing against 4.17-rc3.
>
> Not sure if it's false positive.

How long does this take to trigger?

-chris
