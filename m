Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:19067 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751056AbbEFJbR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 May 2015 05:31:17 -0400
Message-ID: <5549DF66.5090900@cn.fujitsu.com>
Date: Wed, 6 May 2015 17:31:18 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: Chris Murphy <lists@colorremedies.com>
CC: Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        <anonymous_temp_mail@yahoo.co.jp>
Subject: Re: btrfs-progs 4.0 breaks btrfs fi show?
References: <CAJCQCtR7ZT6vt06fbw3sh9sQxufsck=v2J+HJKz2DLFxR9q8RQ@mail.gmail.com>	<5549CCD8.2010000@cn.fujitsu.com> <CAJCQCtT0ff8fVrMQ7rrgW1VFkiBL+f_upGOUZ7DY65N62jAsBQ@mail.gmail.com>
In-Reply-To: <CAJCQCtT0ff8fVrMQ7rrgW1VFkiBL+f_upGOUZ7DY65N62jAsBQ@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Maybe the default kernel probe routine has some problem?

Would you please try 'btrfs fi show <device>' to test the offline
probe routine?
Also, did you update your kernel and didn't reboot?

P.S. Add CC to one of my personal mail address to this case.

Thanks,
Qu

-------- Original Message  --------
Subject: Re: btrfs-progs 4.0 breaks btrfs fi show?
From: Chris Murphy <lists@colorremedies.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Date: 2015年05月06日 17:27

>
> On May 6, 2015 2:12 AM, "Qu Wenruo" <quwenruo@cn.fujitsu.com
> <mailto:quwenruo@cn.fujitsu.com>> wrote:
>  >
>  > Would you please give some detail of your problem?
>  > Like the options and arguments.
>
> I usually use it without arguments, but with 4.0 the arguments don't matter.
>
> # btrfs fi show
> btrfs-progs v4.0
> # btrfs fi show /
> btrfs-progs v4.0
>
> I get nothing else.
>
> Chris Murphy
>
