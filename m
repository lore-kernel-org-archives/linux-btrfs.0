Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qg0-f53.google.com ([209.85.192.53]:33029 "EHLO
	mail-qg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750746AbbGaEK2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 31 Jul 2015 00:10:28 -0400
Received: by qged69 with SMTP id d69so38520379qge.0
        for <linux-btrfs@vger.kernel.org>; Thu, 30 Jul 2015 21:10:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <55BADEC4.3020409@cn.fujitsu.com>
References: <CAJ3TwYQXqUZiKhYc5rciTmvGX1RLkHnkQb5SSYAJ7AD+kbudag@mail.gmail.com>
	<55BADEC4.3020409@cn.fujitsu.com>
Date: Thu, 30 Jul 2015 21:10:27 -0700
Message-ID: <CAJ3TwYS_C9LDU4ffsqtih3Rus6HREuA+gkb0kPpV_JNSyL4Bmg@mail.gmail.com>
Subject: Re: mount btrfs takes 30 minutes, btrfs check runs out of memory
From: John Ettedgui <john.ettedgui@gmail.com>
Cc: =?UTF-8?B?4oCcbGludXgtYnRyZnNAdmdlci5rZXJuZWwub3Jn4oCd?=
	<linux-btrfs@vger.kernel.org>,
        georgi-georgiev-btrfs@japannext.co.jp
Content-Type: text/plain; charset=UTF-8
To: unlisted-recipients:; (no To-header on input)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 30, 2015 at 7:34 PM, Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:
>
>
> Hi John,
> Thanks for the trace output.
You are welcome, thank you for looking at it!
>
> But it seems that, your root partition is also btrfs, causing a lot of btrfs
> trace from your systemd journal.
>
Oh yes sorry about that.
I actually have 3 partition in btrfs, the problematic one being the
only big one.
> Would you mind re-collecting the ftrace without such logging system caused
> btrfs trace?
Sure, how would I do that?
This is my first time using ftrace.
>
> BTW, although I'm not quite familiar with ftrace, would you please consider
> collect ftrace with function_graph tracer?
Sure, how would I do that one as well?
(I'll look these up in the meantime, I just want to make sure to not
give you something not useful again).
> That would help a lot to find which takes the most time.
> But it may trace too much things and maybe hard to read.
>
> Thanks,
> Qu

Great, thank you!
