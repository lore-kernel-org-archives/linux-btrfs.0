Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f171.google.com ([209.85.213.171]:33550 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750957AbcBDMxk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 4 Feb 2016 07:53:40 -0500
Received: by mail-ig0-f171.google.com with SMTP id rs20so14042176igc.0
        for <linux-btrfs@vger.kernel.org>; Thu, 04 Feb 2016 04:53:39 -0800 (PST)
Subject: Re: btrfs-progs and btrfs(8) inconsistencies
To: Martin Steigerwald <martin@lichtvoll.de>, Moviuro <moviuro@gmail.com>
References: <CAM=f9=V-7hbjGLzWUxbynsoJdP-NexEoaTJ3GJJxn3gBYsW1BA@mail.gmail.com>
 <56B2AA51.80908@cn.fujitsu.com>
 <CAM=f9=X5BU0N4iueXtVf4y5SAxrnMQgtgbrsx0Gbc8W6SEspMg@mail.gmail.com>
 <1724218.nF6PTv1Cei@merkaba>
Cc: Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <56B349BE.30003@gmail.com>
Date: Thu, 4 Feb 2016 07:53:18 -0500
MIME-Version: 1.0
In-Reply-To: <1724218.nF6PTv1Cei@merkaba>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-02-04 05:14, Martin Steigerwald wrote:
> Am Donnerstag, 4. Februar 2016, 09:57:54 CET schrieb Moviuro:
>>> Although personally I like to let all the backward compatibility
>>> things go hell, but that's definitely not how things work. :(
>>>
>>> 2) End-user taste.
>>> Some end-users like such info as feedback of success.
>>> Of course other users like it act as silent as possible.
>>
>> I'm pretty sure that's... not the case. Almost everything on GNU/Linux
>> is silent. cd(1) is silent, cp(1) is silent, rm(1)...
>> What they all have though is a -v|--verbose switch.
>
> The various mkfs commands are not. Not one of them I know of. Additionally
> each one gives a different output.
This is kind of understandable, it's an inherently destructive 
operation, and the information they spit out is almost always useful. 
On top of that, except for certain very specific usage, you don't run 
mkfs every day, while it's a lot more likely that you use btrfs 
subvolume commands with a high regularity.  There are also a number of 
mkfs commands that let you silence the output without using shell 
redirection, which is a good thing.
>
> pvcreate, vgcreate, lvcreate and as well as the remove commands and probably
> other LVM commands are not (no one could argue, that from their ideas they
> come from HP/UX, but thats a Unix as well):
>
> merkaba:~> lvcreate -L 1G -n bla sata
>    Logical volume "bla" created.
The output from lvcreate really isn't useful for the same reasons that 
the output fro btrfs subvolume create isn't.  If the command isn't 
returning an error message, then it is implied that it succeeded, in 
which case it is not providing anything that wasn't already known unless 
you choose to not specify a LV name.  The fact that there is no way to 
make these commands silent short of redirection is a design flaw IMHO, 
not something we should be looking at seriously as a good example.
>
> And I think, not testing right now, that also mdadm is not silent on creating
> a softraid.
Again, this is a destructive operation, and you get useful information, 
and you can silence it with a command-line switch.
>
> So while I agree with you that regular shell commands (coreutils, util-linux)
> are silent on success usually this does not appear to be the case with storage
> related commands in GNU/Linux.
>
> I don´t have a clear oppinion about it other than I´d like to see some
> standard too. coreutils / util-linux both them to have some kind of standard,
> although not necessarily the same standard I bet. And I am not sure whether it
> is documented somewhere.
The general convention across most UNIX utilities is to print basic info 
about what's going on for complex operations (hence, LVM commands print 
info, but cp and rm don't) so that the user has some idea of progress. 
When -v or --verbose is specified, print lots of info (some commands 
allow multiple levels of verbosity, either with an argument to -v or by 
repeating it).  When -q or --quiet is specified, print almost nothing 
except errors (and possibly nothing at all, in which case errors get 
reported via the exit code).

There are many places that BTRFS doesn't follow this or is inconsistent 
internally.  We have no -q option on anything I can find.  We print out 
information for comparatively trivial operations (like creating a 
subvolume, which is a single ioctl, unlike lvcreate which involves at a 
minimum writing to disk and then calling dmsetup (lvcreate could still 
provide better info though)).  We have inconsistencies in how we handle 
management operations (scrub is asynchronous with the option to run in 
the foreground, balance is forced synchronous and can only be made 
asynchronous by methods external to BTRFS, but both have almost the same 
command syntax and both are kernel based operations).

As of right now, I see a few things to be addressed:
1) Add a -q option that makes commands only output stuff if there's an 
error.
2) Improve consistency (scrub/balance is just one example, there are 
other places where we are inconsistent).
3) Possibly get rid of the message on subvolume create (If a script is 
depending on that output, then it is not well written.  The output 
provides nothing the script shouldn't already know, and we give proper 
return codes for errors.  It should be expected still that output may 
change given the state of BTRFS.).
4) Possibly get rid of the message on subvolume delete (It provides no 
useful information at all, and it has no option to not error out on non 
existence of a subvolume.  In addition, the same arguments as for create 
apply here too.).
