Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f195.google.com ([209.85.223.195]:33623 "EHLO
	mail-io0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932923AbcGLMZf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Jul 2016 08:25:35 -0400
Received: by mail-io0-f195.google.com with SMTP id y195so903908iod.0
        for <linux-btrfs@vger.kernel.org>; Tue, 12 Jul 2016 05:25:34 -0700 (PDT)
Subject: Re: [PATCH] btrfs-progs: add option to run balance as daemon
To: Tomasz Torcz <tomek@pipebreaker.pl>, linux-btrfs@vger.kernel.org
References: <20160621151659.32157-1-ahferroin7@gmail.com>
 <20160711072612.GA1417185@mother.pipebreaker.pl>
 <63dba99e-cf1c-63f5-bee6-548270b7a653@gmail.com>
 <20160711165822.GB1417185@mother.pipebreaker.pl>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <adc6bbe4-48d8-27d2-468f-7e7816ae96cf@gmail.com>
Date: Tue, 12 Jul 2016 08:25:24 -0400
MIME-Version: 1.0
In-Reply-To: <20160711165822.GB1417185@mother.pipebreaker.pl>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-07-11 12:58, Tomasz Torcz wrote:
> On Mon, Jul 11, 2016 at 07:17:28AM -0400, Austin S. Hemmelgarn wrote:
>> On 2016-07-11 03:26, Tomasz Torcz wrote:
>>> On Tue, Jun 21, 2016 at 11:16:59AM -0400, Austin S. Hemmelgarn wrote:
>>>> Currently, balance operations are run synchronously in the foreground.
>>>> This is nice for interactive management, but is kind of crappy when you
>>>> start looking at automation and similar things.
>>>
>>>   It can be done with simplest systemd unit file:
>>> btrfs-balance@.service:
>>> ---
>>> [Unit]
>>> Description=btrfs balance for %I
>>>
>>> [Service]
>>> ExecStart=/usr/bin/btrfs balance start %I
>>> ExecStop=/usr/bin/btrfs balance cancel %I
>>> ---
>>>
>>>   It automates quite nicely and needs no additional code.
>>>
>> It's also entirely dependent on a couple of things:
>> 1. You're running systemd (not everyone is, I'm certainly not).
>
>   So instead of using widespread, tested code, you re-implement
> parts of it.  BTW, your patch for daemonizing does only 5 steps
> out of 15 described in man 7 daemon.
Sysvinit is more widely tested and used than systemd has ever been. 
Systemd's been around for only a few years, sysvinit has been around for 
decades.  I'm not going to add a dependency on something that's just 
popular for the moment, especially when that thing is such a point of 
contention for so many people.

As far as daemonization, I have no man-page called daemon in section 
seven, yet I have an up-to-date upstream copy of the Linux man pages. 
My guess is that this is a systemd man page, which in turn means it does 
a bunch of stuff that's only needed for system services on systemd based 
systems.  The method I used, in a slightly different form (most people 
use if instead of switch), is pretty much identical to what's been done 
since before SVR4 for daemonization.  In theory, I could use libdaemon, 
but that adds a new dependency.  In theory I could use the daemon() 
function from unistd.h, but the implementation in glibc doesn't work 
correctly (it only forks once).  This doesn't do special handling for 
systemd monitoring, because it doesn't need to.  It's not a system 
service, it's just a background process.
>
>> 2. You're only dealing with the local system.
>>
>> The type of situation I'm thinking of is dealing with non-local systems.
>> For example, running something like this:
>> ssh user@remotehost btrfs balance start --background /
>> Keeping the SSH connection open for the duration of the balance has issues
>> for some people (may close without keep-alive set, uses network bandwidth
>> with keep-alive set, many people who are hosted have bandwidth quotas
>> still), and it's extremely useful to have the option to fire and forget.
>
>   I don't get the local part.  Right now, when using above unit you can
>
> ssh user@remotehost systemctl start btrfs-balance@-
>
> (or even
> systemctl -H user@remotehost start btrfs-balance@-)
>
>  and balance for / runs in background on target host. With clean
> environment, logs being captured, locking against multiple
> startups and so on. Right now, without any additional code.
****************************************
*EXCEPT THAT NOT EVERYONE USES SYSTEMD!*
****************************************

Why do you fail to get that simple fact?

I'm not changing my init system just to add functionality that should 
already exist in btrfs-progs.  The fact that the balance ioctl is 
synchronous was a poor design choice, and we need to provide the option 
to work around that independent of what our users are running.  There's 
been enough interest from other people that it should be obvious that 
people want this _in_ btrfs-progs.  The point is to not _need_ anything 
else to do this.
