Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f41.google.com ([209.85.214.41]:35274 "EHLO
	mail-it0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751709AbcFULaN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 21 Jun 2016 07:30:13 -0400
Received: by mail-it0-f41.google.com with SMTP id g127so15474901ith.0
        for <linux-btrfs@vger.kernel.org>; Tue, 21 Jun 2016 04:30:12 -0700 (PDT)
Subject: Re: Is "btrfs balance start" truly asynchronous?
To: Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
References: <f68639e5a41343c04fa4d76f3fb14370@www.centurion.link>
 <pan$7df97$9174e96e$7848d28b$295d4358@cox.net>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <bc9cdbdf-060b-e903-0c74-c2b6f1f92077@gmail.com>
Date: Tue, 21 Jun 2016 07:24:24 -0400
MIME-Version: 1.0
In-Reply-To: <pan$7df97$9174e96e$7848d28b$295d4358@cox.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-06-21 04:55, Duncan wrote:
> Dmitry Katsubo posted on Mon, 20 Jun 2016 18:33:54 +0200 as excerpted:
>
>> Dear btfs community,
>>
>> I have added a drive to existing raid1 btrfs volume and decided to
>> perform balancing so that data distributes "fairly" among drives. I have
>> started "btrfs balance start", but it stalled for about 5-10 minutes
>> intensively doing the work. After that time it has printed something
>> like "had to relocate 50 chunks" and exited. According to drive I/O,
>> "btrfs balance" did most (if not all) of the work, so after it has
>> exited the job was done.
>>
>> Shouldn't "btrfs balance start" do the operation in the background?
>
> From the btrfs-balance (8) manpage (from btrfs-progs-4.5.3):
>
> start [options] <path>
>     start the balance operation according to the specified filters,
>     no filters will rewrite the entire filesystem. The process runs
>     in the foreground.
>
>
> So the balance start operation runs in the foreground, but as explained
> elsewhere in the manpage, the balance is interruptible by unmount and
> will automatically restart after a remount.  It can also be paused and
> resumed or canceled with the appropriate btrfs balance subcommands.
>
FWIW, there was some talk a while back about possibly providing an 
option to run balance in the background.  If I end up finding the time, 
I may write a patch for this (userland only, I'm not interested in 
mucking around with the kernel side of things, and it's fully possible 
to do this just using libc functions), as it's something I'd rather like 
to have myself, as the current method of using job control in a shell 
doesn't really work in some circumstances (for example, you can't easily 
start a balance on a remote system via a ssh command, which is the 
specific use case I have).
