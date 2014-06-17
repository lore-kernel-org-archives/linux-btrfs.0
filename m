Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail.fujitsu.co.jp ([164.71.1.133]:52633 "EHLO
	fgwmail.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754046AbaFQCKp (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 16 Jun 2014 22:10:45 -0400
Received: from kw-mxq.gw.nic.fujitsu.com (unknown [10.0.237.131])
	by fgwmail.fujitsu.co.jp (Postfix) with ESMTP id 19C6B3EE0C2
	for <linux-btrfs@vger.kernel.org>; Tue, 17 Jun 2014 11:10:44 +0900 (JST)
Received: from s1.gw.fujitsu.co.jp (s1.gw.nic.fujitsu.com [10.0.50.91])
	by kw-mxq.gw.nic.fujitsu.com (Postfix) with ESMTP id 25A17AC03D7
	for <linux-btrfs@vger.kernel.org>; Tue, 17 Jun 2014 11:10:43 +0900 (JST)
Received: from m1001.s.css.fujitsu.com (m1001.s.css.fujitsu.com [10.240.81.139])
	by s1.gw.fujitsu.co.jp (Postfix) with ESMTP id CC2611DB8050
	for <linux-btrfs@vger.kernel.org>; Tue, 17 Jun 2014 11:10:42 +0900 (JST)
Message-ID: <539FA395.5050704@jp.fujitsu.com>
Date: Tue, 17 Jun 2014 11:10:29 +0900
From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
MIME-Version: 1.0
To: Chris Mason <clm@fb.com>
CC: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [3.16-rc1] BUG: soft lockup - CPU#0 stuck for 23s! [kworker/u25:4:5189]
References: <539E9026.1020406@jp.fujitsu.com> <539F2FEA.1060809@fb.com> <539F7D8E.9010608@jp.fujitsu.com> <539F8351.3010700@fb.com> <539F846A.4080608@jp.fujitsu.com> <539F9006.4090109@fb.com>
In-Reply-To: <539F9006.4090109@fb.com>
Content-Type: text/plain; charset=ISO-2022-JP
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2014/06/17 9:47, Chris Mason wrote:
> On 06/16/2014 07:57 PM, Tsutomu Itoh wrote:
>> On 2014/06/17 8:52, Chris Mason wrote:
>>> On 06/16/2014 07:28 PM, Tsutomu Itoh wrote:
>>>> Hi Chris,
>>>>
>>>> On 2014/06/17 2:56, Chris Mason wrote:
>>>>> On 06/16/2014 02:35 AM, Tsutomu Itoh wrote:
>>>>>> I encountered soft lockup when executing 'xfstests btrfs/042' on 3.16-rc1.
>>>>>>
>>>>>
>>>>> Did we recover, or was it stuck forever?
>>>>
>>>> The following messages are repeatedly output.
>>>> And stuck forever.
>>>>
>>>> [ 1147.942181] BUG: soft lockup - CPU#0 stuck for 23s! [kworker/u25:4:5189]
>>>> [ 1147.967175] BUG: soft lockup - CPU#3 stuck for 23s! [kworker/u25:9:5194]
>>>> [ 1147.979172] BUG: soft lockup - CPU#4 stuck for 23s! [kworker/u25:15:5200]
>>>> [ 1147.991169] BUG: soft lockup - CPU#5 stuck for 23s! [kworker/u25:7:5192]
>>>> [ 1148.064153] BUG: soft lockup - CPU#6 stuck for 23s! [kworker/u26:3:3182]
>>>
>>> Can you please capture a stack trace from all the cpus?
> 
> Very strange, please try to reproduce again, I'll dig through things here.

I can reproduce it easily in my environment.

Thanks,
Tsutomu

==========
Message from syslogd@luna at Jun 17 11:06:33 ...
 kernel:[  560.076282] BUG: soft lockup - CPU#0 stuck for 22s! [kworker/u25:1:193]

Message from syslogd@luna at Jun 17 11:06:33 ...
 kernel:[  560.076283] BUG: soft lockup - CPU#1 stuck for 22s! [kworker/u25:3:3174]

Message from syslogd@luna at Jun 17 11:06:33 ...
 kernel:[  560.101276] BUG: soft lockup - CPU#3 stuck for 22s! [kworker/u25:4:3175]

Message from syslogd@luna at Jun 17 11:06:33 ...
 kernel:[  560.113274] BUG: soft lockup - CPU#4 stuck for 22s! [kworker/u25:6:3177]

Message from syslogd@luna at Jun 17 11:06:33 ...
 kernel:[  560.125271] BUG: soft lockup - CPU#5 stuck for 22s! [kworker/u25:5:3176]



