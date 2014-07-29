Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp.domeneshop.no ([194.63.252.54]:52385 "EHLO
	smtp.domeneshop.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753407AbaG2PHj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Jul 2014 11:07:39 -0400
Message-ID: <53D7B8B3.8000701@skagestad.org>
Date: Tue, 29 Jul 2014 17:07:31 +0200
From: =?ISO-8859-1?Q?Torbj=F8rn?= <lists@skagestad.org>
MIME-Version: 1.0
To: bo.li.liu@oracle.com
CC: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: BTRFS hang with 3.16-rc5 (and also with 3.16-rc4)
References: <1984661.CMGGdWA6Ux@merkaba> <1809953.ithLVmijbn@merkaba> <53D11F2B.1070008@fb.com> <53D1E260.6080708@skagestad.org> <20140725092800.GC25859@localhost.localdomain> <53D22FD4.2070806@skagestad.org> <53D23AF1.9010704@skagestad.org> <53D24166.7030208@skagestad.org> <20140728100059.GB29285@localhost.localdomain> <53D62FD7.6010205@skagestad.org> <20140729095139.GA3947@localhost.localdomain>
In-Reply-To: <20140729095139.GA3947@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 07/29/2014 12:18 PM, Liu Bo wrote:
> On Mon, Jul 28, 2014 at 01:11:19PM +0200, Torbjørn wrote:
>> On 28. juli 2014 12:00, Liu Bo wrote:
>> <snip>
>>> This seems to be incomplete(Looks like dmesg has reached its buffer size limit),
>>> does /var/log/message have the whole stack info?
>>>
>>> thanks,
>>> -liubo
>> Hi,
>>
>> Complete log was over 40MB. I uploaded everything from boot until
>> "blocked for 120 seconds" started to appear.
>> If you want all the trailing log as well, let me know.
>>
>> https://gist.github.com/anonymous/7958d8917967f727f324
> Sorry...still don't get why it's locked up, io_ctl_prepare_pages() has several
> callers, and they are properly released from the code level.  And the warnings
> printed in the log belong to other btrfs partitions, not the hanged btrfs one,
> and we're still not able to know which one holds the free space cache inode page.
>
> Maybe we'd better resort to a bisect between 3.14 and 3.15(I know it'd be a lot
> of time though).
>
> Here, doing rsync on compress=lzo full btrfs never hit that problem, shrug...
>
> thanks,
> -liubo
>
>> --
>> Torbjørn
That's too bad.

My reproducer is not 100% guaranteed to trigger the hang, so doing a 
bisect might lead us to some innocent commit.
I have run the rsync + snapshot job several times here now, and no hang.

--
Torbjørn
