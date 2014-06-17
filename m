Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:56656 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751160AbaFQAly (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 16 Jun 2014 20:41:54 -0400
Message-ID: <539F9006.4090109@fb.com>
Date: Mon, 16 Jun 2014 20:47:02 -0400
From: Chris Mason <clm@fb.com>
MIME-Version: 1.0
To: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
CC: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [3.16-rc1] BUG: soft lockup - CPU#0 stuck for 23s! [kworker/u25:4:5189]
References: <539E9026.1020406@jp.fujitsu.com> <539F2FEA.1060809@fb.com> <539F7D8E.9010608@jp.fujitsu.com> <539F8351.3010700@fb.com> <539F846A.4080608@jp.fujitsu.com>
In-Reply-To: <539F846A.4080608@jp.fujitsu.com>
Content-Type: text/plain; charset="ISO-2022-JP"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 06/16/2014 07:57 PM, Tsutomu Itoh wrote:
> On 2014/06/17 8:52, Chris Mason wrote:
>> On 06/16/2014 07:28 PM, Tsutomu Itoh wrote:
>>> Hi Chris,
>>>
>>> On 2014/06/17 2:56, Chris Mason wrote:
>>>> On 06/16/2014 02:35 AM, Tsutomu Itoh wrote:
>>>>> I encountered soft lockup when executing 'xfstests btrfs/042' on 3.16-rc1.
>>>>>
>>>>
>>>> Did we recover, or was it stuck forever?
>>>
>>> The following messages are repeatedly output.
>>> And stuck forever.
>>>
>>> [ 1147.942181] BUG: soft lockup - CPU#0 stuck for 23s! [kworker/u25:4:5189]
>>> [ 1147.967175] BUG: soft lockup - CPU#3 stuck for 23s! [kworker/u25:9:5194]
>>> [ 1147.979172] BUG: soft lockup - CPU#4 stuck for 23s! [kworker/u25:15:5200]
>>> [ 1147.991169] BUG: soft lockup - CPU#5 stuck for 23s! [kworker/u25:7:5192]
>>> [ 1148.064153] BUG: soft lockup - CPU#6 stuck for 23s! [kworker/u26:3:3182]
>>
>> Can you please capture a stack trace from all the cpus?

Very strange, please try to reproduce again, I'll dig through things here.

-chris
