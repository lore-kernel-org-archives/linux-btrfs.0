Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:21739 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750777AbbFYQfi (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 25 Jun 2015 12:35:38 -0400
Date: Thu, 25 Jun 2015 09:35:07 -0700
From: Omar Sandoval <osandov@fb.com>
To: wangyf <wangyf-fnst@cn.fujitsu.com>
CC: Ed Tomlinson <edt@aei.ca>, <linux-btrfs@vger.kernel.org>,
        Miao Xie <miaoxie@huawei.com>, Zhao Lei <zhaolei@cn.fujitsu.com>,
        Philip <bugzilla@philip-seeger.de>
Subject: Re: [PATCH v2 0/5] Btrfs: RAID 5/6 missing device scrub+replace
Message-ID: <20150625163507.GA24394@huxley.DHCP.TheFacebook.com>
References: <cover.1434739053.git.osandov@fb.com>
 <5588CD54.9050405@cn.fujitsu.com>
 <20150624041310.GA26148@huxley.DHCP.TheFacebook.com>
 <5cfdd3e8-e9ba-4b3a-a858-49f6a36f18de@aei.ca>
 <558B8BBD.2010004@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <558B8BBD.2010004@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 25, 2015 at 01:03:57PM +0800, wangyf wrote:
>  I confirmed this bug report, and found the reason is that
>  I compiled the patched module with a dirty kernel.
>  This morning I tested this patch again, and didn't see above error, this
> patch is OK.
>  Sorry for this bug report. : (

It's no problem! Do either of you feel like providing your Tested-by?

-- 
Omar
