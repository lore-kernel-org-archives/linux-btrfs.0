Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail2.fujitsu.co.jp ([164.71.1.135]:45792 "EHLO
	fgwmail2.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751429AbaFQEwn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 Jun 2014 00:52:43 -0400
Received: from kw-mxoi2.gw.nic.fujitsu.com (unknown [10.0.237.143])
	by fgwmail2.fujitsu.co.jp (Postfix) with ESMTP id 1CD343EE0B3
	for <linux-btrfs@vger.kernel.org>; Tue, 17 Jun 2014 13:52:42 +0900 (JST)
Received: from s3.gw.fujitsu.co.jp (s3.gw.nic.fujitsu.com [10.0.50.93])
	by kw-mxoi2.gw.nic.fujitsu.com (Postfix) with ESMTP id 179A6AC0A09
	for <linux-btrfs@vger.kernel.org>; Tue, 17 Jun 2014 13:52:41 +0900 (JST)
Received: from m1000.s.css.fujitsu.com (m1000.s.css.fujitsu.com [10.240.81.136])
	by s3.gw.fujitsu.co.jp (Postfix) with ESMTP id B094F1DB803B
	for <linux-btrfs@vger.kernel.org>; Tue, 17 Jun 2014 13:52:40 +0900 (JST)
Message-ID: <539FC98D.9080605@jp.fujitsu.com>
Date: Tue, 17 Jun 2014 13:52:29 +0900
From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
MIME-Version: 1.0
To: Chris Mason <clm@fb.com>
CC: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [3.16-rc1] BUG: soft lockup - CPU#0 stuck for 23s! [kworker/u25:4:5189]
References: <539E9026.1020406@jp.fujitsu.com> <539F2FEA.1060809@fb.com> <539F7D8E.9010608@jp.fujitsu.com> <539F8351.3010700@fb.com> <539F846A.4080608@jp.fujitsu.com> <539F9006.4090109@fb.com> <539FA395.5050704@jp.fujitsu.com> <539FB0AE.7010404@jp.fujitsu.com>
In-Reply-To: <539FB0AE.7010404@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2014/06/17 12:06, Tsutomu Itoh wrote:
> On 2014/06/17 11:10, Tsutomu Itoh wrote:
>> On 2014/06/17 9:47, Chris Mason wrote:
>>> On 06/16/2014 07:57 PM, Tsutomu Itoh wrote:
>>>> On 2014/06/17 8:52, Chris Mason wrote:
>>>>> On 06/16/2014 07:28 PM, Tsutomu Itoh wrote:
>>>>>> Hi Chris,
>>>>>>
>>>>>> On 2014/06/17 2:56, Chris Mason wrote:
>>>>>>> On 06/16/2014 02:35 AM, Tsutomu Itoh wrote:
>>>>>>>> I encountered soft lockup when executing 'xfstests btrfs/042' on 3.16-rc1.
>>>>>>>>
>>>>>>>
>>>>>>> Did we recover, or was it stuck forever?
>>>>>>
>>>>>> The following messages are repeatedly output.
>>>>>> And stuck forever.
>>>>>>
>>>>>> [ 1147.942181] BUG: soft lockup - CPU#0 stuck for 23s! [kworker/u25:4:5189]
>>>>>> [ 1147.967175] BUG: soft lockup - CPU#3 stuck for 23s! [kworker/u25:9:5194]
>>>>>> [ 1147.979172] BUG: soft lockup - CPU#4 stuck for 23s! [kworker/u25:15:5200]
>>>>>> [ 1147.991169] BUG: soft lockup - CPU#5 stuck for 23s! [kworker/u25:7:5192]
>>>>>> [ 1148.064153] BUG: soft lockup - CPU#6 stuck for 23s! [kworker/u26:3:3182]
>>>>>
>>>>> Can you please capture a stack trace from all the cpus?
>>>
>>> Very strange, please try to reproduce again, I'll dig through things here.
>>
>> I can reproduce it easily in my environment.
> 

3.16-rc1 is slower than 3.15. And, 3.16-rc1 sometimes hang up.

===============
- 3.15

WARNING! - Btrfs v3.14.2-50-gea6501b IS EXPERIMENTAL
WARNING! - see http://btrfs.wiki.kernel.org before using

Turning ON incompat feature 'extref': increased hardlink limit per file to 65536
adding device /dev/sdc6 id 2
fs created label (null) on /dev/sdb4
        nodesize 16384 leafsize 16384 sectorsize 4096 size 65.19GiB
Btrfs v3.14.2-50-gea6501b

FSTYP         -- btrfs
PLATFORM      -- Linux/x86_64 luna 3.15.0
MKFS_OPTIONS  -- /dev/sdc5
MOUNT_OPTIONS -- /dev/sdc5 /test6

btrfs/042 2s ... 1s
Ran: btrfs/042
Passed all 1 tests

FSTYP         -- btrfs
PLATFORM      -- Linux/x86_64 luna 3.15.0
MKFS_OPTIONS  -- /dev/sdc5
MOUNT_OPTIONS -- /dev/sdc5 /test6

btrfs/042 1s ... 2s
Ran: btrfs/042
Passed all 1 tests

...
...

---------------

- 3.16-rc1

WARNING! - Btrfs v3.14.2-50-gea6501b IS EXPERIMENTAL
WARNING! - see http://btrfs.wiki.kernel.org before using

Turning ON incompat feature 'extref': increased hardlink limit per file to 65536
adding device /dev/sdc6 id 2
fs created label (null) on /dev/sdb4
        nodesize 16384 leafsize 16384 sectorsize 4096 size 65.19GiB
Btrfs v3.14.2-50-gea6501b

FSTYP         -- btrfs
PLATFORM      -- Linux/x86_64 luna 3.16.0-rc1
MKFS_OPTIONS  -- /dev/sdc5
MOUNT_OPTIONS -- /dev/sdc5 /test6

btrfs/042 2s ... 6s
Ran: btrfs/042
Passed all 1 tests

FSTYP         -- btrfs
PLATFORM      -- Linux/x86_64 luna 3.16.0-rc1
MKFS_OPTIONS  -- /dev/sdc5
MOUNT_OPTIONS -- /dev/sdc5 /test6

btrfs/042 6s ...

[  160.167530] BUG: soft lockup - CPU#1 ...
===============


