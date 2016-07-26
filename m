Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:64289 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753583AbcGZKpz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Jul 2016 06:45:55 -0400
Subject: Re: [PATCH RFC] btrfs: send: Disable clone detection
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, fdmanana@gmail.com
References: <20160725071959.28107-1-quwenruo@cn.fujitsu.com>
 <CAL3q7H7sbHH16nFextVEwY_zYHyKhpSQE7phm687Viuq5U0k6A@mail.gmail.com>
 <8893545f-3a01-d1ac-517f-6536539dc69b@cn.fujitsu.com>
 <CAL3q7H46wzBB0w3iBb9B_1Zu2yRKp27LyFSXHVuEnaq861FKGQ@mail.gmail.com>
 <a23115e4-baa8-69cf-cfb5-721cb1bef944@cn.fujitsu.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <11559332-5676-2283-d82a-f89fa7617dc5@gmx.com>
Date: Tue, 26 Jul 2016 18:45:31 +0800
MIME-Version: 1.0
In-Reply-To: <a23115e4-baa8-69cf-cfb5-721cb1bef944@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Some typo fixes:

On 07/26/2016 06:04 PM, Qu Wenruo wrote:
>
>
> At 07/26/2016 05:28 PM, Filipe Manana wrote:
>> On Tue, Jul 26, 2016 at 1:57 AM, Qu Wenruo <quwenruo@cn.fujitsu.com>
>> wrote:
>>>
>>>
>>> At 07/25/2016 09:48 PM, Filipe Manana wrote:
>>>>
>>>> On Mon, Jul 25, 2016 at 8:19 AM, Qu Wenruo <quwenruo@cn.fujitsu.com>
>>>> wrote:
[snipped]
>
> And without the test of dedupe(inband or out-of-band), we know how long
> the problem will still exist?

"we know" -> "who knows"

>

> So other ones cares it so much that no one even send out a test case?

"cares" -> "care"

> One extent shared by 1024 times, and all belongs to one file extent.
> And on the other hand, it's shared by 2 files, 512 times respectively.

2 files -> 2 subvolumes.

Thanks,
Qu
