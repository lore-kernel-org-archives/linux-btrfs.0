From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Btrfs v0.14 Released
Date: Fri, 2 May 2008 08:40:44 +0200 (CEST)
Message-ID: <alpine.LNX.1.10.0805020837490.6463@fbirervta.pbzchgretzou.qr>
References: <200804291601.32945.chris.mason@oracle.com> <c24352ca0805010939q31f743aev17cc7f98d2ad0c71@mail.gmail.com> <481A14BA.9090305@canonical.com> <200805011517.55698.chris.mason@oracle.com> <481A1BB9.8050109@canonical.com> <481A23AB.1020302@suse.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Tim Gardner <tim.gardner@canonical.com>,
	Chris Mason <chris.mason@oracle.com>,
	jeffschroeder@computer.org, linux-fsdevel@vger.kernel.org,
	kernel-team@lists.ubuntu.com, linux-kernel@vger.kernel.org,
	linux-btrfs@vger.kernel.org, John Johansen <jjohansen@suse.de>
To: Jeff Mahoney <jeffm@suse.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <481A23AB.1020302@suse.com>
List-ID: <linux-btrfs.vger.kernel.org>


On Thursday 2008-05-01 22:10, Jeff Mahoney wrote:

>>>> Couldn't you #ifdef based on CONFIG_SECURITY_APPARMOR ? This ought to
>>>> work for Hardy. However the next development kernel (Intrepid) does not
>>>> have the APPARMOR patches, so just knowing that its an UBUNTU kernel is
>>>> not specific enough.
>>>
>>> I've been assuming the apparmor patches change remove_suid even when they are 
>>> not enabled in the config.
>> 
>> Lets get Kees involved. He developed the patch set for Hardy. I would
>> hope that if CONFIG_SECURITY_APPARMOR=n then the source would default to
>> its normal state.
>
>remove_suid() isn't the only change AppArmor makes to the VFS interface.
>It's pretty invasive and requires that dentries are passed with a
>companion vfsmount in most cases. Putting #ifdefs around all that code
>would make the problem worse, not better.

An alternative approach, and IMHO better suited, is to:

	make -C ${kdir} all I_HAZ_AN_APPARMOR=1

with this Makefile

	ifneq (${I_HAZ_AN_APPARMOR},)
	EXTRA_CFLAGS += -DHAZ_APPARMOR
	endif

This works very well for kmp-rpms, which are tied to a specific
distro, sometimes kernel, anyway.
