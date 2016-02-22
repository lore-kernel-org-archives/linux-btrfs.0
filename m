Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f172.google.com ([209.85.223.172]:35399 "EHLO
	mail-io0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755029AbcBVN3c (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 22 Feb 2016 08:29:32 -0500
Received: by mail-io0-f172.google.com with SMTP id g203so176487101iof.2
        for <linux-btrfs@vger.kernel.org>; Mon, 22 Feb 2016 05:29:32 -0800 (PST)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <1456142520.3587.3.camel@ubuntu.com>
References: <20160220210903.GA3182@carbon.home>
	<20160220224050.GA10864@carbon.home>
	<56CA61CC.7010703@cn.fujitsu.com>
	<20160222072659.GC17243@carbon.ljdarc.local>
	<CAL3q7H7Ty4R8dQO=MWayn3xzROjRub7uzuGVdM7zMCfU0As1Eg@mail.gmail.com>
	<1456142520.3587.3.camel@ubuntu.com>
Date: Mon, 22 Feb 2016 13:29:31 +0000
Message-ID: <CAL3q7H7hhaDQ3e2oCW96iwr6NPww-57e9b675oQ-MY6EVTrVQA@mail.gmail.com>
Subject: Re: [Question]: Contributing to btrfs
From: Filipe Manana <fdmanana@gmail.com>
To: Simon Quigley <tsimonq2@ubuntu.com>
Cc: Philippe Loctaux <phil@philippeloctaux.com>,
        Qu Wenruo <quwenruo@cn.fujitsu.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Feb 22, 2016 at 12:02 PM, Simon Quigley <tsimonq2@ubuntu.com> wrote:
>> 1) You don't learn anything by doing them. You don't learn nothing
>> about btrfs internals, filesystems in general, kernel programming in
>> general, general programming in C, etc. It ends up being only a waste
>> of time for you;
>
> It is useful for one reason. If you would like to get used to the workflow of kernel development,

No, that's silly. Generating a patch file and sending it to the
mailing list is very trivial. There's not much to learn there.
Certainly you don't need to send around 10 whitespace/style patches
for that. 1 is enough to "test the waters". And most people learn that
by observing others for a while too.

> this seems to be useful for a lot of people. In fact, Linus himself has encouraged this.

Whitespace/style patches I doubt. He probably encourages for small
cleanup/optimizations as the first patch, like he did recently at
https://lkml.org/lkml/2015/9/15/919. That's something that requires
some thinking and understanding. Now running checkpatch and fix its
warnings, doesn't require any skill at all.
What were you planning? Sending more 100 patches, each one to fix a
different style issue for each function? There's probably hundreds or
thousands more style/whitespace "issues" to fix in btrfs alone.

Just think about what you want to accomplish. It's normal to not know
what do initially, I think everyone goes through that phase, specially
if not employed to work on btrfs (or whatever project interests you).
Just read code, find issues in it, make changes for your own testing,
read bug reports and performance issue reports here in the list and in
kernel's bugzilla - some bugs might be easy to fix, other might
require very deep knowledge of the internals or no one figured out yet
how to reproduce. Or run xfstests and filesystem stress testing tools
to find problems (there's plenty of races, deadlocks, etc that happen
often and no one knows about them yet). Over time you'll find plenty
of things to do, that make you learn a lot and do something useful for
users and other developers.




-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
