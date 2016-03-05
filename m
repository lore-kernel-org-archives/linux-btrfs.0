Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from scarab.smoula.net ([83.240.14.6]:54678 "EHLO scarab.smoula.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753628AbcCEM3r (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 5 Mar 2016 07:29:47 -0500
Received: from localhost (localhost.localdomain [127.0.0.1])
	by scarab.smoula.net (Postfix) with ESMTP id D0AAF462C563
	for <linux-btrfs@vger.kernel.org>; Sat,  5 Mar 2016 13:29:43 +0100 (CET)
Received: from scarab.smoula.net ([127.0.0.1])
	by localhost (scarab.smoula.net [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id Q-d9bNcU3dOt for <linux-btrfs@vger.kernel.org>;
	Sat,  5 Mar 2016 13:29:42 +0100 (CET)
Received: from [IPv6:2001:470:5950:dead::d0d0] (interceptor-native.smoula.net [IPv6:2001:470:5950:dead::d0d0])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by scarab.smoula.net (Postfix) with ESMTPSA id 56B68462C55E
	for <linux-btrfs@vger.kernel.org>; Sat,  5 Mar 2016 13:29:42 +0100 (CET)
Subject: Re: ENOSPC while creating snapshot
References: <c2e396477401f3441bdc364456b399f4@smoula.net>
 <20160305034910.576d2230@natsu> <pan$297ce$3e554bcd$6c1aeaa$9eef485a@cox.net>
 <CAL3q7H5KQYHWeAfMQgLnffQdb6yU_-3jiGg8LfnU=f2cD0o09Q@mail.gmail.com>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
From: =?UTF-8?B?TWFydGluIE1seW7DocWZ?= <nexus@smoula.net>
Message-ID: <56DAD133.3090101@smoula.net>
Date: Sat, 5 Mar 2016 13:29:39 +0100
MIME-Version: 1.0
In-Reply-To: <CAL3q7H5KQYHWeAfMQgLnffQdb6yU_-3jiGg8LfnU=f2cD0o09Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 5.3.2016 11:46, Filipe Manana wrote:
> On Sat, Mar 5, 2016 at 2:09 AM, Duncan <1i5t5.duncan@cox.net> wrote:
>> Roman Mamedov posted on Sat, 05 Mar 2016 03:49:10 +0500 as excerpted:
>>
>>> As you use the nodatacow mount option, this seems to be another case of
>>> http://www.spinics.net/lists/linux-btrfs/msg51276.html
>>> http://www.spinics.net/lists/linux-btrfs/msg51819.html
>>>
>>> and is fixed by https://patchwork.kernel.org/patch/7967161/
>>>
>>> Unfortunately the bug is known since the start of the 4.4 series and the
>>> patch is out for 2 months, but it didn't get included into even 4.4.4
>>> released recently. You have to apply it by yourself and recompile the
>>> kernel.
>>
>> Tho AFAIK it should be in 4.5, which is getting close to release, so if
>> you prefer to run 4.5-rcX to applying the patch yourself, that should
>> work as well.
>
> No, it's not in any 4.5-rc.
> It's in the integration branch for 4.6, however.
Thank you all for your help. Now I'm on 4.5.0-rc6-mainline with pointed 
patch and issue seems to be resolved.

Thank you for your time!

--
Martin
