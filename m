From: Maciej Marcin Piechotka <uzytkownik2@gmail.com>
Subject: Re: kernel BUG at fs/btrfs/inode.c:2299
Date: Mon, 19 Sep 2011 02:44:41 +0200
Message-ID: <1316393087.5713.1.camel@picard>
References: <1314582311.2724.4.camel@picard>
	 <4E5C82E8.9090400@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: linux-btrfs@vger.kernel.org
To: miaox@cn.fujitsu.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E5C82E8.9090400@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 2011-08-30 at 14:27 +0800, Miao Xie wrote:
> > 
> > Unfortunately it results in freeze of system and I cannot give more
> > details. Sometimes it happens not from fcron but then it does not result
> > in freeze (???).
> 
> Could you give me the method to reproduce it?
> 
> Thanks
> Miao

Sorry for spamming in this thread but I'm trying to post my findings in
hope that somebody will understand what's going on.

Recent crash gave some valuable information IMHO:

 1. I started the autocompletion of path in zsh
 2. At some point the zsh hanged. In ps the process was listed as
runnable
 3. Any access to root volume (the one that zsh was trying to readdir)
finished in hang.
 4. I was able to access the child volume (/home)
 5. After some time the bug is hit. At this time strange things happens
(screen freeze etc.). I guess that there is some strange interaction
between KMS, X and now-hanged composite manager

Next time it happend (also during listing root directory of volume 0) I
observed the following thing - I can log out and unmount home but the
volume 0 remains busy and cannot be unmounted.

Things to consider:

 - It is not enabled/disabled by any mount option
 - Is it triggered when the parent volume (say volume 0) and child
volume are both mounted?
 - Which case is it failing (I've tried to add printk but I cannot find
the option in printk to print u64)
 - Why it happens only during night?

Regards

