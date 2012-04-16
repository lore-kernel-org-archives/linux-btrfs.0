From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs mount flags
Date: Mon, 16 Apr 2012 03:20:53 +0000 (UTC)
Message-ID: <pan.2012.04.16.03.20.53@cox.net>
References: <jjul59-m49.ln1@hurikhan.ath.cx>
	<t0ho59-rjd.ln1@hurikhan.ath.cx> <pan.2012.04.15.05.53.30@cox.net>
	<201204151200.31568.Martin@lichtvoll.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Martin Steigerwald posted on Sun, 15 Apr 2012 12:00:31 +0200 as excerpted:

> No cc - instead of whats habit on this list - as you prefer list
> replies.
> 
> Am Sonntag, 15. April 2012 schrieb Duncan:
>> I believe there's a current report of a performance regression due to
>> the  space cache [but] the expectation is a fix by 3.4 release[.]
>> [A]t least people with existing btrfs filesystems might
>> want to hold off on enabling that option for the moment, if they're
>> running the 3.4-rcs, but by 3.4 release, it'll hopefully be fine.
> 
> Maybe a fix will be in some rc candidate before 3.4 release.

I just did a git-pull and see the commit fixing the space-cache bug made 
it for 3.4-rc3.  So the space-cache mount option should be good to go, 
now.  Of course btrfs being a development/experimental filesystem, 
there's other bugs in process, but that's normal state for current 
maturity.  This one's fixed, anyway.

> Maybe an update wiki page could serve as input for additions to mount
> Manpage. Or a special btrfs mount options manpage. I would be willing to
> help with that as time permits.

Both would probably be useful.

The mount (8) manpage isn't likely to be reliably current on btrfs for 
some time, as btrfs is simply developing too rapidly at this point for 
the general-purpose mount docs to keep up.  So btrfs-tools shipping a 
mount.btrfs manpage or whatever could be quite useful if it's kept 
updated, of course the nice thing about manpages being that they're 
generally usable without a net connection.

But the wiki page with the mount options should be kept updated as well.  
Since it's there already and simply needs upkeep, that'd be the cheaper 
alternative for the moment, and an online reference for people to read if 
they don't have btrfs-tools installed locally is as useful as a local 
manpage reference for those with it local but no net. =:^)

As for updating the wiki... I really should get a login for it so I 
can...  (I didn't see the usual edit links when not logged in.  Not that 
I blame whoever's running it.  This isn't wikipedia and keeping up with 
the spam, etc, would be a serious problem if registration wasn't 
required.)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

