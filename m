From: Thomas Bellman <bellman@nsc.liu.se>
Subject: Re: Rename+crash behaviour of btrfs - nearly ext3!
Date: Tue, 18 May 2010 16:47:48 +0200
Message-ID: <4BF2A894.60204@nsc.liu.se>
References: <4BF18525.8080904@gmail.com> <20100517193652.GC8635@think>	<4BF1DBCD.7060208@gmail.com> <20100518003032.GK8635@think>	<20100518005926.GM8635@think> <4BF28225.2000908@gmail.com>	<20100518131304.GX8635@think> <0339xpl4pp.fsf@msgid.viggen.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <0339xpl4pp.fsf@msgid.viggen.net>
List-ID: <linux-btrfs.vger.kernel.org>

On 05/18/10 15:28, Oystein Viggen wrote:

> * [Chris Mason]
>
>> I'm more than open to discussion on this one, but I don't see how:
>>
>> rm -f foo2
>> dd if=/dev/zero of=foo bs=1M count=1000
>> mv foo foo2
>>
>> Should be expected to write 1GB of data.
>
> IIRC, the answer you're looking for is "it did with ext3 in the default
> data=ordered mode".  Combine that with the ext3 data=ordered fsync()
> escalation where (again IIRC) fsync() tended to force a full sync() of
> the file system, and it's not that difficult to see why someone would
> program with the expectation above.
>
> Anyway, there's still a question of if a new file system should emulate
> the quirks of the old file system (read: be bug compatible), or if you
> can just expect to be popular enough that userspace adapts to the new
> order and lets you do The Right Thing instead.

So what *is* the right thing?  What kind of API should userspace have?
If the obvious thing for an application programmer to do is wrong, and
the right thing requires going through more hoops, that will ensure
that the majority of applications will be buggy.  We should strive
to make it easy to get things right.

It's easy for the kernel, and the filesystem, to just ask the userspace
programmers to jump through the hoops, and declare those programs that
don't to be broken.

On the other hand, if you go *too* far in absolving applications of
responsibility for making things safe, you would end up making all
filesystem operations synchronous, and that obviously hurts performance
in big ways.  So we need some kind of compromise, and where that
compromise should end up being, I don't really have the answer to.
It's just that I feel that often only the kernel programmers view is
represented here.


The pattern of writing to a file and then changing its name *without*
overwriting an existing file, is quite common when you write files to
a spool directory, and have another program that picks up files from
that directory and processes them.  You

     fd = open("foo4711.tmp", O_CREAT|O_EXCL|O_RDWR);
     write(fd, "data", strlen("data"));
     close(fd);
     link("foo4711.tmp", "foo4711");
     unlink("foo4711.tmp");

(And note that careful programs don't use rename() here, because that
would risk clobbering a file some other process has written, and instead
use link()+unlink().  And I really wish a "safe_rename()" syscall that
didn't clobber existing files existed.)

The programs I personally have written that did this, also had an fsync()
there, because I received data from another system and didn't want to ACK
until I knew it was safely on disk at my end.  But I am a fairly careful
programmer.


Note that in my previous life I was a userspace programmer, and in my
current life I'm a sysadmin.  I'm speaking as an interrested user of
Btrfs, not as a kernel programmer.


	/Thomas Bellman
