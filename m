Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from resqmta-po-11v.sys.comcast.net ([96.114.154.170]:41528 "EHLO
	resqmta-po-11v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752108AbaJTRhc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 20 Oct 2014 13:37:32 -0400
Message-ID: <54454858.8010802@pobox.com>
Date: Mon, 20 Oct 2014 10:37:28 -0700
From: Robert White <rwhite@pobox.com>
MIME-Version: 1.0
To: russell@coker.com.au
CC: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: strange 3.16.3 problem
References: <201410181454.19375.russell@coker.com.au> <54426C16.5030206@pobox.com> <201410191041.42013.russell@coker.com.au>
In-Reply-To: <201410191041.42013.russell@coker.com.au>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 10/18/2014 04:41 PM, Russell Coker wrote:
> On Sun, 19 Oct 2014, Robert White <rwhite@pobox.com> wrote:
>> On 10/17/2014 08:54 PM, Russell Coker wrote:
>>> # find . -name "*546"
>>> ./1412233213.M638209P10546
>>> # ls -l ./1412233213.M638209P10546
>>> ls: cannot access ./1412233213.M638209P10546: No such file or directory
>>>
>>> Any suggestions?
>>
>> Does "ls -l *546" show the file to exist? e.g. what happens if you use
>> the exact same wildcard in the ls command as you used in the find?
>
> # ls -l *546
> ls: cannot access 1412233213.M638209P10546: No such file or directory
>
> That gives the same result as find, the shell matches the file name but then
> ls can't view it.
>
> lstat64("1412233213.M638209P10546", 0x9fab0c8) = -1 ENOENT (No such file or
> directory)
>
>  From strace, the lstat64 system call fails.

Okay, from the strace output the shell _is_ finding the file in the 
directory read and expand (readdir) pass. That is "*546" is being 
expanded to the full file name text "1412233213.M638209P10546" but then 
the actual operation fails because the name is apparently not associated 
with anything.

So what pass of scrub or btrfsck checks directory connectedness? Does 
that pass give your file system a clean bill of health?

Also you said that you are using a 32bit user space "copied from another 
server" under a 64bit kernel. Is the "ls" command a 32 bit executable then?

What happens if you stop the Xen domain for the mail server and then 
mount the disks into a native 64bit environment and then ls the file name?

I ask because the man page for lstat64 says its a "wrapper" for the 
underlying system call (fstatat64). It is not impossible that you might 
have a case where the wrapper is failing inside glibc due to some 32/64 
bit conversion taking place.

Since you copied the entire 32bit environment from another (older?) 
server there may be some nonsense happening where the two interfaces meet.

I'd check the file system against a native 64bit kernel and user-space 
next. Possibly from a distro CD if necessary, just to isolate the 
potential file system causes from the user-space causes. If the native 
64bit environment fails then its a fs issue, if the natvie 64bit 
operations work, then its a userspace problem and you win the fun of 
remaking the mail server from scratch.


