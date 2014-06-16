Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail.fujitsu.co.jp ([164.71.1.133]:51893 "EHLO
	fgwmail.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751771AbaFPXaD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 16 Jun 2014 19:30:03 -0400
Received: from kw-mxauth.gw.nic.fujitsu.com (unknown [10.0.237.134])
	by fgwmail.fujitsu.co.jp (Postfix) with ESMTP id 322D73EE0C8
	for <linux-btrfs@vger.kernel.org>; Tue, 17 Jun 2014 08:30:01 +0900 (JST)
Received: from s2.gw.fujitsu.co.jp (s2.gw.nic.fujitsu.com [10.0.50.92])
	by kw-mxauth.gw.nic.fujitsu.com (Postfix) with ESMTP id 352B7AC05DB
	for <linux-btrfs@vger.kernel.org>; Tue, 17 Jun 2014 08:30:00 +0900 (JST)
Received: from m1001.s.css.fujitsu.com (m1001.s.css.fujitsu.com [10.240.81.139])
	by s2.gw.fujitsu.co.jp (Postfix) with ESMTP id E2C1C1DB8038
	for <linux-btrfs@vger.kernel.org>; Tue, 17 Jun 2014 08:29:59 +0900 (JST)
Message-ID: <539F7D8E.9010608@jp.fujitsu.com>
Date: Tue, 17 Jun 2014 08:28:14 +0900
From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
MIME-Version: 1.0
To: Chris Mason <clm@fb.com>
CC: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [3.16-rc1] BUG: soft lockup - CPU#0 stuck for 23s! [kworker/u25:4:5189]
References: <539E9026.1020406@jp.fujitsu.com> <539F2FEA.1060809@fb.com>
In-Reply-To: <539F2FEA.1060809@fb.com>
Content-Type: text/plain; charset=ISO-2022-JP
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Chris,

On 2014/06/17 2:56, Chris Mason wrote:
> On 06/16/2014 02:35 AM, Tsutomu Itoh wrote:
>> I encountered soft lockup when executing 'xfstests btrfs/042' on 3.16-rc1.
>>
> 
> Did we recover, or was it stuck forever?

The following messages are repeatedly output.
And stuck forever.

[ 1147.942181] BUG: soft lockup - CPU#0 stuck for 23s! [kworker/u25:4:5189]
[ 1147.967175] BUG: soft lockup - CPU#3 stuck for 23s! [kworker/u25:9:5194]
[ 1147.979172] BUG: soft lockup - CPU#4 stuck for 23s! [kworker/u25:15:5200]
[ 1147.991169] BUG: soft lockup - CPU#5 stuck for 23s! [kworker/u25:7:5192]
[ 1148.064153] BUG: soft lockup - CPU#6 stuck for 23s! [kworker/u26:3:3182]

Thanks,
Tsutomu


