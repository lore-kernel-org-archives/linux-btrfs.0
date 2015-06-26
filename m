Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:22819 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753017AbbFZCIG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 25 Jun 2015 22:08:06 -0400
Message-ID: <558CB3F2.70509@cn.fujitsu.com>
Date: Fri, 26 Jun 2015 10:07:46 +0800
From: wangyf <wangyf-fnst@cn.fujitsu.com>
MIME-Version: 1.0
To: Omar Sandoval <osandov@fb.com>
CC: Ed Tomlinson <edt@aei.ca>, <linux-btrfs@vger.kernel.org>,
        Miao Xie <miaoxie@huawei.com>, Zhao Lei <zhaolei@cn.fujitsu.com>,
        Philip <bugzilla@philip-seeger.de>
Subject: Re: [PATCH v2 0/5] Btrfs: RAID 5/6 missing device scrub+replace
References: <cover.1434739053.git.osandov@fb.com> <5588CD54.9050405@cn.fujitsu.com> <20150624041310.GA26148@huxley.DHCP.TheFacebook.com> <5cfdd3e8-e9ba-4b3a-a858-49f6a36f18de@aei.ca> <558B8BBD.2010004@cn.fujitsu.com> <20150625163507.GA24394@huxley.DHCP.TheFacebook.com>
In-Reply-To: <20150625163507.GA24394@huxley.DHCP.TheFacebook.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

No problem.

Wang Yanfeng <wangyf-fnst@cn.fujitsu.com>

cheers
wangyf
在 2015年06月26日 00:35, Omar Sandoval 写道:
> On Thu, Jun 25, 2015 at 01:03:57PM +0800, wangyf wrote:
>>   I confirmed this bug report, and found the reason is that
>>   I compiled the patched module with a dirty kernel.
>>   This morning I tested this patch again, and didn't see above error, this
>> patch is OK.
>>   Sorry for this bug report. : (
> It's no problem! Do either of you feel like providing your Tested-by?
>

