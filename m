Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f45.google.com ([209.85.214.45]:36184 "EHLO
	mail-it0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750852AbcGMRAC (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 13 Jul 2016 13:00:02 -0400
Received: by mail-it0-f45.google.com with SMTP id f6so25751716ith.1
        for <linux-btrfs@vger.kernel.org>; Wed, 13 Jul 2016 09:59:37 -0700 (PDT)
Subject: Re: [PATCH] btrfs-progs: add option to run balance as daemon
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
References: <20160621151659.32157-1-ahferroin7@gmail.com>
 <20160713163853.GO10595@twin.jikos.cz>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <8d330077-e39a-50fa-6b05-aff0f5f075aa@gmail.com>
Date: Wed, 13 Jul 2016 12:59:33 -0400
MIME-Version: 1.0
In-Reply-To: <20160713163853.GO10595@twin.jikos.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-07-13 12:38, David Sterba wrote:
> On Tue, Jun 21, 2016 at 11:16:59AM -0400, Austin S. Hemmelgarn wrote:
>> Currently, balance operations are run synchronously in the foreground.
>> This is nice for interactive management, but is kind of crappy when you
>> start looking at automation and similar things.
>
> Yeah, people have been complaining about the lack of backgrounding
> support over the time.
TBH, I actually understand why it was implemented the way it was in the 
first place, it's a lot easier to work with something running in the 
foreground, and having the ability to run in the background adds 
complexity, so blocking like it does currently makes sense for an 
initial implementation.  Beyond the initial implementation, I don't 
think it's bothered anyone enough that they wanted to fix it themselves.
>
>> This patch adds an option to `btrfs balance start` to tell it to
>> daemonize prior to running the balance operation, thus allowing us to
>> preform balances asynchronously.  The two biggest use cases I have for
>> this are starting a balance on a remote server without establishing a
>> full shell session, and being able to background the balance in a
>> recovery shell (which usually has no job control) so I can still get
>> progress information.
>>
>> Because it simply daemonizes prior to calling the balance ioctl, this
>> doesn't actually need any kernel support.
>
> We could also add the kernel support, but this would need to extend the
> ioctl flags. Unfortunatelly older kernels would ignore it and always let
> balance run in foreground (due to lack of checks for the known flags).
> So at the moment forking a process seems to be an option.
Ideally, I'd like to see kernel support for this too so that tools that 
want to manage it don't need to spawn a thread or fork a new process 
just to run it in the background.  That said, it's a lot quicker to 
implement in userspace, and we'd need such an implementation anyway to 
support old kernels.
>
>> Signed-off-by: Austin S. Hemmelgarn <ahferroin7@gmail.com>
>> ---
>> This works as is, but there are two specific things I would love to
>> eventually fix but don't have the time to fix right now:
>> * There is no way to get any feedback from the balance operation.
>
> Does this mean that 'btrfs balance status' is not sufficient? Or I don't
> understand what you mean.
`btrfs balance status` calls still work.  What I was referring to is the 
lack of the usual 'Done, had to relocate X out of Y chunks.' output on 
completion.  I probably should have worded this differently in retrospect.

As mentioned below though, in an ideal situation, this would have the 
ability to log the results, but doing that the right way is more code 
than I'm willing to deal with for a first pass at this.
>
>> * Because of how everything works, trying to start a new balance with
>>   --background while one iw already running won't return an error but
>>   won't queue or start a new balance either.
>>
>> The first one is more a utility item than anything else, and probably
>> would not be hard to add.  Ideally, it should be output to a user
>> specified file, and this should work even for a normal foreground balance.
>>
>> The second is very much a UX issue, but can't be easily sovled without
>> doing some creative process monitoring from the parrent processes.
>
> Currently, starting a second balance will return immediatelly with "in
> progress" message, this is returned by the balance iotctl itself. In
> this case it would be the child process and communicating it back would
> need a pipe or somesuch. But, the parent can check the balance status by
> itself, before calling fork, right? Unless I'm missing something, this
> should address your concerns.
What I had been thinking was just having the parent wait and see that 
the child is still running after a short time (100ms maybe), or has 
exited with a 0 exit status.  I'm hesitant to add an extra ioctl just to 
check if a balance is running because of TOCTOU races, I'd rather have 
it deterministically start the balance or not based solely on the 
balance ioctl, especially since fork() is expensive enough to make such 
a race rather easy to hit).  Hopefully, I'll have some time in the near 
future to do an updated version that properly handles this.

