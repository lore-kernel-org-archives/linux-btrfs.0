Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.162]:60761 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750809Ab3AGOgk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 7 Jan 2013 09:36:40 -0500
Message-ID: <50EADD74.9020401@die-jansens.de>
Date: Mon, 07 Jan 2013 15:36:36 +0100
From: Arne Jansen <lists@die-jansens.de>
MIME-Version: 1.0
To: bo.li.liu@oracle.com
CC: Kiran Patil <kirantpatil@gmail.com>, linux-btrfs@vger.kernel.org
Subject: Re: Open for contribution towards xfstests for btrfs
References: <CANT588vv8xYNWGBSZUDu0vui2ZH4QqL7tvQX8zOGof7nucC6_Q@mail.gmail.com> <CANT588tZd8y3G0jZD3Ti-nHexk1jwmD-fJP1f1bttFP8kyEgqg@mail.gmail.com> <20130107130135.GA7600@liubo>
In-Reply-To: <20130107130135.GA7600@liubo>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 07.01.2013 14:01, Liu Bo wrote:
> On Mon, Jan 07, 2013 at 03:48:43PM +0530, Kiran Patil wrote:
>> Hello,
>>
>> We have a team of 5 students who would like to contribute to btrfs
>> filesystem testing using xfstests.
>>
>> Is there space for them to contribute?
> 
> xfstests is lacking of testcases targetting for btrfs send/recieve,
> you may be interested in it.

There is even a basis for that already, we have a testsuite for the
zfs send -> btrfs receive feature at

git://git.kernel.org/pub/scm/linux/kernel/git/arne/far-progs.git

see test.pl. It can also already be used to test btrfs send ->
btrfs receive.

-Arne

> 
> thanks,
> liubo
> 
>>
>> If yes, to whom do they need to keep in touch for guidance.
>>
>> Thank you,
>> Kiran Patil (Director)
>> Green Turtles Technologies, INDIA.
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

