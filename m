Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f177.google.com ([209.85.223.177]:36658 "EHLO
	mail-io0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751189AbcFBKFv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 2 Jun 2016 06:05:51 -0400
Received: by mail-io0-f177.google.com with SMTP id k19so28176087ioi.3
        for <linux-btrfs@vger.kernel.org>; Thu, 02 Jun 2016 03:05:51 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <20160602100321.GA20887@jeknote.loshitsa1.net>
References: <CAL3q7H6R=Sii-Qn3G7ZL5d4vT33jj-MZOF92fH7T-QHjHSNtow@mail.gmail.com>
	<CAL3q7H71v-U+hAKyscCd4ShckoKapFEEQn=3xS1d2M4u9KAEZQ@mail.gmail.com>
	<alpine.DEB.2.10.1605261506540.25778@dispatch>
	<CAL3q7H67b3JNMogY5DS4X3JTLQEugB4E48kjLx6fE69VwXGpDQ@mail.gmail.com>
	<20160602100321.GA20887@jeknote.loshitsa1.net>
Date: Thu, 2 Jun 2016 11:05:50 +0100
Message-ID: <CAL3q7H7FpwMnLded9aCrt3EhFiAG5y67k2jrKjvZbn4V=rT+uQ@mail.gmail.com>
Subject: Re: Device replace issues and disabling it until they are solved
From: Filipe Manana <fdmanana@gmail.com>
To: Yauhen Kharuzhy <yauhen.kharuzhy@zavadatar.com>
Cc: Scott Talbert <scott.talbert@hgst.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 2, 2016 at 11:03 AM, Yauhen Kharuzhy
<yauhen.kharuzhy@zavadatar.com> wrote:
> On Fri, May 27, 2016 at 10:43:47AM +0100, Filipe Manana wrote:
>> > Hi Filipe,
>>
>> Hi Scott,
>>
>> >
>> > Does your recent patch set (from May 20) address all of these issues?
>>
>> Yes.
>
> Tested, RAID5/6 still produces a plenty of 'failed to rebuild valid
> logical NNNNNN" messages after two consecutive device replaces. So,
> replace is still not usable for RAID5/6. And it is very slow in
> comparison with 'device add && balance device remove missing' sequence
> (4x slower).

Right. There's missing code for raid5/6 I believe. I didn't care about
that, nor will in the near future at least.
The set of problems I tried to solve were generic and unrelated to any
specific raid mode.

>
> --
> Yauhen Kharuzhy



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
