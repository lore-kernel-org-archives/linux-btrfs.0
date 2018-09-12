Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tty0.vserver.softronics.ch ([91.214.169.36]:32862 "EHLO
        fe1.digint.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727859AbeILUDW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 12 Sep 2018 16:03:22 -0400
Subject: Re: [RFC PATCH 0/6] btrfs-progs: build distinct binaries for specific
 btrfs subcommands
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>, linux-btrfs@vger.kernel.org
References: <20180829172409.18064-1-axel@tty0.ch>
 <42587df6-1be3-e42e-3c85-fa356786ba65@gmail.com>
 <a3876ea3-17aa-d08a-2c0f-4b6904e9853a@tty0.ch>
 <6cc12bf1-5990-e19d-6a81-b11ba41cf784@gmail.com>
From: Axel Burri <axel@tty0.ch>
Message-ID: <5d13d2b2-a72e-c65b-9a6b-a63158bfd000@tty0.ch>
Date: Wed, 12 Sep 2018 16:58:24 +0200
MIME-Version: 1.0
In-Reply-To: <6cc12bf1-5990-e19d-6a81-b11ba41cf784@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 30/08/2018 19.23, Austin S. Hemmelgarn wrote:
> On 2018-08-30 13:13, Axel Burri wrote:
>> On 29/08/2018 21.02, Austin S. Hemmelgarn wrote:
>>> On 2018-08-29 13:24, Axel Burri wrote:
>>>> This patch allows to build distinct binaries for specific btrfs
>>>> subcommands, e.g. "btrfs-subvolume-show" which would be identical to
>>>> "btrfs subvolume show".
>>>>
>>>>
>>>> Motivation:
>>>>
>>>> While btrfs-progs offer the all-inclusive "btrfs" command, it gets
>>>> pretty cumbersome to restrict privileges to the subcommands [1].
>>>> Common approaches are to either setuid root for "/sbin/btrfs" (which
>>>> is not recommended at all), or to write sudo rules for each
>>>> subcommand.
>>>>
>>>> Separating the subcommands into distinct binaries makes it easy to set
>>>> elevated privileges using capabilities(7) or setuid. A typical use
>>>> case where this is needed is when it comes to automated scripts,
>>>> e.g. btrbk [2] [3] creating snapshots and send/receive them via ssh.
>>> Let me start by saying I think this is a great idea to have as an
>>> option, and that the motivation is a particularly good one.
>>>
>>> I've posted my opinions on your two open questions below, but there's
>>> two other comments I'd like to make:
>>>
>>> * Is there some particular reason that this only includes the commands
>>> it does, and _hard codes_ which ones it works with?  if we just do
>>> everything instead of only the stuff we think needs certain
>>> capabilities, then we can auto-generate the list of commands to be
>>> processed based on function names in the C files, and it will
>>> automatically pick up any newly added commands.  At the very least, it
>>> could still parse through the C files and look for tags in the comments
>>> for the functions to indicate which ones need to be processed this way.
>>> Either case will make it significantly easier to add new commands, and
>>> would also better justify the overhead of shipping all the files
>>> pre-generated (because there would be much more involved in
>>> pre-generating them).
>>
>> It includes the commands that are required by btrbk. It was quite
>> painful to figure out the required capabilities (reading kernel code and
>> some trial and error involved), and I did not get around to include
>> other commands yet.
> Yeah, I can imagine that it was not an easy task.  I've actually been
> thinking of writing a script to scan the kernel sources and assemble a
> summary of the permissions checks performed by each system call and
> ioctl so that stuff like this is a bit easier, but that's unfortunately
> way beyond my abilities right now (parsing C and building call graphs is
> not easy no matter what language you're doing it with).
>>
>> I like your idea of adding some tags in the C files, I'll try to
>> implement this, and we'll see what it gets to.
> Something embedded in the comments is likely to be the easiest option in
> terms of making sure it doesn't break the regular build.  Just the
> tagging in general would be useful as documentation though.
> 
> It would be kind of neat to have the list of capabilities needed for
> each one auto-generated from what it calls, but that's getting into some
> particularly complex territory that would likely require call graphs to
> properly implement.

After some more iterations I came up with a generic "Makefile only"
version of this patchset. The new version does not need generated
c-files, and matches entry point declarations as well as additional tags
(for fscaps declaration or future enhancements) in all "cmds-*.c" files.

See new thread: "[RFC PATCH v2 0/4] btrfs-progs: build distinct binaries
for specific btrfs subcommands"


>>
>>> * While not essential, it would be really neat to have the `btrfs`
>>> command detect if an associated binary exists for whatever command was
>>> just invoked, and automatically exec that (possibly with some
>>> verification) instead of calling the command directly so that desired
>>> permissions are enforced.  This would mitigate the need for users to
>>> remember different command names depending on execution context.
>>
>> Hmm this sounds a bit too magic for me, and would probably be more
>> confusing than useful. It would mean than running "btrfs" as user would
>> work when splitted commands are available, and would not work if not.
> It would also mean scripts would not have to add special handling for
> the case of running as a non-root user and seeing if the split commands
> actually exist or not (and, for that matter, would not have to directly
> depend on having the split commands at all), and that users would not
> need to worry about how to call BTRFS based on who they were running as.
>  Realistically, I'd expect the same error to show if the binary isn't
> available as if it's not executable, so that it just becomes a case of
> 'if you see this error, re-run the same thing as root and it should work'.
>>
>>>>
>>>>
>>>> Description:
>>>>
>>>> Patch 1 adds a template as well as a generator shell script for the
>>>> splitted subcommands.
>>>>
>>>> Patch 2 adds the generated subcommand source files.
>>>>
>>>> Patch 3-5 adds a "install-splitcmd-setcap" make target, with different
>>>> approaches (either hardcoded in Makefile, or more generically by
>>>> including "Makefile.install_setcap" generated by "splitcmd-gen.sh").
>>>>
>>>>
>>>> Open Questions:
>>>>
>>>> 1. "make install-splitcmd-setcap" installs the binaries with hardcoded
>>>> group "btrfs". This needs to be configurable (how?). Another approach
>>>> would be to not set the group at all, and leave this to the user or
>>>> distro packaging script.
>>> Leave it to the user or distro.  It's likely to end up standardized on
>>> the name 'btrfs', but it should be agnostic of that.
>>>>
>>>> 2. Instead of the "install-splitcmd-setcap" make target, we could
>>>> introduce a "configure --enable-splitted-subcommands" option, which
>>>> would simply add all splitcmd binaries to the "all" and "install"
>>>> targets without special treatment, and leave the setcap stuff to the
>>>> user or distro packaging script (at least in gentoo, this needs to be
>>>> specified using the "fcaps" eclass anyways [5]).
>>> A bit of a nitpick, but 'split' is the proper past tense of the word
>>> 'split', it's one of those exceptions that English has all over the
>>> place.  Even aside from that though, I think `separate` sounds more
>>> natural for the configure option, or better yet, just make it
>>> `--enable-fscaps` like most other packages do.
>>>
>>> That aside, I think having a configure option is the best way to do
>>> this, it makes it very easy for distro build systems to handle it
>>> because this is what they're used to doing anyway.  It also makes it a
>>> bit easier on the user, because it just becomes `make` to build
>>> whichever version you want installed.
> 
