Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qg0-f44.google.com ([209.85.192.44]:35993 "EHLO
	mail-qg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751074AbbHDCbd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 3 Aug 2015 22:31:33 -0400
Received: by qgeh16 with SMTP id h16so102072089qge.3
        for <linux-btrfs@vger.kernel.org>; Mon, 03 Aug 2015 19:31:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJ3TwYTd_8-uwn-osNsf6UAuxGvoJCeWmxWYNHmzXoF_+yrABA@mail.gmail.com>
References: <CAJ3TwYQXqUZiKhYc5rciTmvGX1RLkHnkQb5SSYAJ7AD+kbudag@mail.gmail.com>
	<55BADEC4.3020409@cn.fujitsu.com>
	<CAJ3TwYRN+1tJY+paz=qZT0_XP=r9CcTKbBgX_kZRFOWj8vSK=w@mail.gmail.com>
	<55BAFEF9.1070107@cn.fujitsu.com>
	<CAJ3TwYR5g-JhjmGnZUXqLXc7qV1_=AN5_6sj54JQODbtgG9Aag@mail.gmail.com>
	<55BB0A39.1050208@cn.fujitsu.com>
	<CAJ3TwYS+yL8Tk8d3uigpXrfD+dcn2G4tWwbF7jcB=BCDZqs6+g@mail.gmail.com>
	<CAJ3TwYQc3d5R6r+tjY9mxUzptWA_MktUbZeaQebmNRBuqB7zYA@mail.gmail.com>
	<55C017E7.40704@cn.fujitsu.com>
	<CAJ3TwYTd_8-uwn-osNsf6UAuxGvoJCeWmxWYNHmzXoF_+yrABA@mail.gmail.com>
Date: Mon, 3 Aug 2015 19:31:32 -0700
Message-ID: <CAJ3TwYQN4w4qj4FWiSmRsQ4-oxVWDH4vsu3b7=HqB2cCS5jpcQ@mail.gmail.com>
Subject: Re: mount btrfs takes 30 minutes, btrfs check runs out of memory
From: John Ettedgui <john.ettedgui@gmail.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Aug 3, 2015 at 6:55 PM, John Ettedgui <john.ettedgui@gmail.com> wrote:
> On Mon, Aug 3, 2015 at 6:39 PM, Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:
>>
>> Oh, you were using trace-cmd, that's why the data is so huge.
> Oh, I thought it was just automating the work for me, but without any
> sort of impact.
>>
>> I was originally hoping you just copy the trace file, which is human
>> readable and not so huge.
> If you mean something like the ouput of trace-cmd report, it was
> actually bigger than the dat files (about twice the size) that's why I
> shared the dats instead.
> If you want the reports instead I'll gladly share them.
In case it helps here are the reports instead of the dats:
https://mega.co.nz/#!FwpwHQyL!m0dQHSfQSNGzw9yUwJ6l0eb7Mzta0pOSAf1JHDZ1zfo
https://mega.co.nz/#!B1JgXLxZ!oI1bm0RyhqFbkCWnT95GNKohGozmvqxgJDSUtVdo77s

I guess once compressed the size difference is meaningless

Thanks,
John
