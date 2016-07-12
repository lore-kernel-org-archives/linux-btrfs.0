Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f172.google.com ([209.85.220.172]:33532 "EHLO
	mail-qk0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750780AbcGLSZl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Jul 2016 14:25:41 -0400
Received: by mail-qk0-f172.google.com with SMTP id p74so21993318qka.0
        for <linux-btrfs@vger.kernel.org>; Tue, 12 Jul 2016 11:25:40 -0700 (PDT)
Received: from [191.9.212.201] (rrcs-70-62-41-24.central.biz.rr.com. [70.62.41.24])
        by smtp.gmail.com with ESMTPSA id v4sm1117535qkh.28.2016.07.12.11.25.38
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 12 Jul 2016 11:25:38 -0700 (PDT)
Subject: Re: [PATCH] btrfs-progs: add option to run balance as daemon
To: linux-btrfs@vger.kernel.org
References: <20160621151659.32157-1-ahferroin7@gmail.com>
 <20160711072612.GA1417185@mother.pipebreaker.pl>
 <63dba99e-cf1c-63f5-bee6-548270b7a653@gmail.com>
 <20160711165822.GB1417185@mother.pipebreaker.pl>
 <adc6bbe4-48d8-27d2-468f-7e7816ae96cf@gmail.com>
 <pan$74d1e$3fac5c54$6a613f6$6e9626ab@cox.net>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <f4a6d543-0196-ebd1-70ce-baa2ba610bd4@gmail.com>
Date: Tue, 12 Jul 2016 14:25:31 -0400
MIME-Version: 1.0
In-Reply-To: <pan$74d1e$3fac5c54$6a613f6$6e9626ab@cox.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-07-12 11:22, Duncan wrote:
> Austin S. Hemmelgarn posted on Tue, 12 Jul 2016 08:25:24 -0400 as
> excerpted:
>
>> As far as daemonization, I have no man-page called daemon in section
>> seven, yet I have an up-to-date upstream copy of the Linux man pages. My
>> guess is that this is a systemd man page, which in turn means it does a
>> bunch of stuff that's only needed for system services on systemd based
>> systems.
>
> Your guess would appear to be correct, as my systemd package includes a
> daemon manpage, here (gentoo).
OK, in that case, what that page will list is the requirements for a 
daemon which runs under systemd.  That's _way_ more than what's needed 
for a regular daemon, and IIRC, some of the things systemd requires will 
cause issues on non-systemd systems (for those who use Gentoo or build 
their own software, this is why so many things have systemd support 
optional, many things haven't been written to choose at runtime).

For reference, the de-fact standard method of daemonization on UNIX is 
generally:
1. Perform any config parsing and similar and exit if it fails.
2. fork()
3. setsid() in the child process
4. fork() in the child process
5. chdir("/") in the new child process (this shouldn't need to have it's 
return code checked, if it fails, you almost certainly have bigger 
issues to deal with).
6. Close stdin, stdout, and stderr in the new child process
7. Open stdin, stdout, and stderr to whatever you want (usually 
/dev/null unless logging is being done).
8. Optionally provide verification from the first child that the second 
child is still running, then exit the first child process.
9. Optionally provide verification from the parent process that the 
first child exited with out indicating errors, then exit.

Item 1 is to allow for verbose error info to be returned if something 
that can be done in the foreground fails.  Items 2 and 3 set up a 
session leader process which would get re-parented to init if it's 
parent exited.  Item 4 makes sure the daemon isn't a session leader, 
which means it will never have a controlling terminal again (this is the 
bit that the glibc implementation of daemon(3) doesn't do).  Item 5 
frees up the previous working directory so that it isn't referenced by 
the daemon directly, and thus can be unmounted or removed (this isn't 
strictly necessary, but it's considered good practice).  Item 6 ensures 
that the daemon has no controlling terminal (so it doesn't get hit by 
SIGHUP or similar things accidentally). Item 7 is not 100% necessary, 
but is also considered good practice (especially if the code is only 
optionally run as a daemon).  Items 8 and 9 are generally considered 
good practice, but are less commonly used in simple daemons than other 
options.

As stated in a previous e-mail, there are two rather obvious options 
which I chose not to use here:
1. libdaemon
2. daemon(3)
Additionally, libbsd also has a daemon() function.  I chose to not use 
daemon(3) because it has issues as implemented by glibc (it skips step 4 
above, which has potentially problematic implications).  I chose not to 
use libdaemon or libbsd because those would add another dependency, 
which is not a good thing for a low-level maintenance tool.

As far as this particular implementation I did, I've got items 2-7. 
Item 1 is equivalent to command-line parsing, which is mostly done at 
this point.  I plan to do items 8 and 9, but don't really have the time 
to code them right now.
>
> As for the general debate, while I'm a systemd user, I definitely support
> it remaining optional, which means things need to work without it, too.
I'm glad to hear some one else feels this way, although I'm not 
surprised it's another Gentoo user :).

