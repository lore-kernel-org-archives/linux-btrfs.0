Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oa0-f47.google.com ([209.85.219.47]:37648 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161032Ab3FUNOw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 21 Jun 2013 09:14:52 -0400
Received: by mail-oa0-f47.google.com with SMTP id m1so9521738oag.34
        for <linux-btrfs@vger.kernel.org>; Fri, 21 Jun 2013 06:14:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20130621113040.4477.83994@localhost.localdomain>
References: <alpine.DEB.2.00.1306110841550.15858@cobra.newdream.net>
 <20130618163706.GC19183@localhost.localdomain> <loom.20130618T190955-784@post.gmane.org>
 <20130621011137.4477.1347@localhost.localdomain> <CAKuK5J3TBDNgHJ_YUWupB4rO_ixG0LnZFE=K5Uo5Wbo=76rT+A@mail.gmail.com>
 <20130621113040.4477.83994@localhost.localdomain>
From: Jon Nelson <jnelson@jamponi.net>
Date: Fri, 21 Jun 2013 08:14:32 -0500
Message-ID: <CAKuK5J3+93oEzncUg6QHma91RgD28k=Gv3nvDbCCzU5GvcKM0A@mail.gmail.com>
Subject: Re: hang on 3.9, 3.10-rc5
To: Chris Mason <chris.mason@fusionio.com>
Cc: Jon Nelson <jnelson+btrfs@jamponi.net>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jun 21, 2013 at 6:30 AM, Chris Mason <chris.mason@fusionio.com> wrote:
> Quoting Jon Nelson (2013-06-20 21:46:46)
>> Is this what you are looking for?
>> After this, the CPU gets "stuck" and I have to reboot.
>>
>>
>> [360491.932226] ------------[ cut here ]------------
>> [360491.932261] kernel BUG at
>> /home/abuild/rpmbuild/BUILD/kernel-desktop-3.9.6/linux-3.9/fs/btrfs/ctree.c:1144!
>
> Aha, this is not a hang but a crash.  I know the end result is the same
> (you push the reset button) but for a crash we always want to see this
> oops message.

In my case, "pick a file, any file". I randomly choose a file, and
this most recent time I chose $HOME/.config/Clementine/jamendo.db.

> I'll try to reproduce (and check out the bugzilla too).  Do you have>
> -chris
> compression on?

I don't have compression on:

/blah/blah on / type btrfs (rw,relatime,ssd,space_cache,enospc_debug)

But those mount opts don't seem to matter.
I checked out the bugzilla entry, it sure looks similar!


--
Jon
Software Blacksmith
