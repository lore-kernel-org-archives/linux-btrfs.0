Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f176.google.com ([209.85.213.176]:33920 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751505AbcBVKra (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 22 Feb 2016 05:47:30 -0500
Received: by mail-ig0-f176.google.com with SMTP id g6so83443476igt.1
        for <linux-btrfs@vger.kernel.org>; Mon, 22 Feb 2016 02:47:30 -0800 (PST)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <20160222072659.GC17243@carbon.ljdarc.local>
References: <20160220210903.GA3182@carbon.home>
	<20160220224050.GA10864@carbon.home>
	<56CA61CC.7010703@cn.fujitsu.com>
	<20160222072659.GC17243@carbon.ljdarc.local>
Date: Mon, 22 Feb 2016 10:47:29 +0000
Message-ID: <CAL3q7H7Ty4R8dQO=MWayn3xzROjRub7uzuGVdM7zMCfU0As1Eg@mail.gmail.com>
Subject: Re: [Question]: Contributing to btrfs
From: Filipe Manana <fdmanana@gmail.com>
To: Philippe Loctaux <phil@philippeloctaux.com>
Cc: Qu Wenruo <quwenruo@cn.fujitsu.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Feb 22, 2016 at 7:26 AM, Philippe Loctaux
<phil@philippeloctaux.com> wrote:
> On Mon, Feb 22, 2016 at 09:18:04AM +0800, Qu Wenruo wrote:
>> https://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git
>> For branch, normally I use 'integration-X.X' as base for kernel development.
>>
>> And for btrfs-progs,
>> https://github.com/kdave/btrfs-progs.git devel
>
> Allright, I'll work from these repos!
>
> Is it fine if I work from Linus's repo?
> Will my patches get rejected if I do so?

If you want to contribute and do something useful for others and
yourself, just don't keep sending these patches to fix
whitespace/style issues reported by checkpatch.
Think about it:

1) You don't learn anything by doing them. You don't learn nothing
about btrfs internals, filesystems in general, kernel programming in
general, general programming in C, etc. It ends up being only a waste
of time for you;

2) You're not offering any benefit to users - not fixing a bug, not
adding a new feature, not doing any performance/efficiency
improvement, not making the code more reliable, etc;

3) You're not offering a benefit for other developers either, like
doing a cleanup that simplifies a complex algorithm for example.

If you care so much about the whitespace/style issues, just fix them
while doing a useful change as mentioned above that happens to touch
the same code.
It takes time to read and understand code, it can be a big investment
of time, but it ends up being worth it. There's plenty of bug reports
and performance issues in the mailing list or bugzilla, so there's no
shortage of things to do.

Same advice applies to any other kernel subsystem or open source
project in general. Also before jumping into such a storm of useless
patches, observe first what a community does for at least a month, and
learn from other contributors - what they do, how they do it, the flow
of development and releases, etc. Don't rush into a sending patch just
for the sake of sending it and having your name in the git history.

Hope it helps.


>
> --
> Philippe Loctaux
> phil@philippeloctaux.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
