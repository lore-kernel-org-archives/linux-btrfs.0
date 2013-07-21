Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:42591 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751101Ab3GUWCU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 21 Jul 2013 18:02:20 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1V11hm-0004Ce-PY
	for linux-btrfs@vger.kernel.org; Mon, 22 Jul 2013 00:02:14 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 22 Jul 2013 00:02:14 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 22 Jul 2013 00:02:14 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: autodefrag by default, was: Lots of harddrive chatter
Date: Sun, 21 Jul 2013 22:01:55 +0000 (UTC)
Message-ID: <pan$7e18b$b2c36a61$b1f22c8c$6c61ba6e@cox.net>
References: <ksf42h$suu$1@ger.gmane.org> <
	pan$3c802$83940fc4$86279b1e$4ddf0e4e@cox.net> <
	09A15D35-4874-4650-93F1-1E151076C498@colorremedies.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris Murphy posted on Sun, 21 Jul 2013 10:20:48 -0600 as excerpted:

> On Jul 21, 2013, at 4:38 AM, Duncan <1i5t5.duncan@cox.net> wrote:
>> 
>> What I'd suggest is to turn on the btrfs autodefrag mount option, and
>> to do it *BEFORE* you start installing stuff on the filesystem.
> 
> Is there a good reason why autodefrag is not a default mount option?

Well, there's the obvious, that btrfs is still in development, lacking 
such things as the ability to set such options by default using btrfs-
tune, and likely with the question of what should be the defaults still 
unresolved for many cases.

Autodefrag can also negatively affect performance especially if it's not 
on from the beginning, AND at least at one point earlier in btrfs 
evolution (I'm not sure if it's fixed now or not), the performance for 
very large and often written into files such as virtual-machine images 
and large databases was bad, since it could mean constantly rewriting 
entire large files instead of just the smaller changing pieces of them, 
thereby being a performance killer for that type of job load.

>>  I believe
>> it's a known issue that a number of distro installers (what arch does
>> I'm not sure) tend to fragment their files pretty badly right off the
>> bat if you let them.  This would happen if they write data into an
>> existing file, perhaps because they install a package and then
>> customize the config files, or if they don't write whole files at once.
>>  And a lot of btrfs installs don't turn on the autodefrag option when
>> they do thet first auto-
>> mount to install stuff.
> 
> Some installer teams are understandably reluctant to use non-default
> mount options.

It's worth keeping in mind the bigger picture, tho, that in the case of 
btrfs they're using a still in development filesystem (even if it's not 
the default, the fact that so few people come here unaware of the wiki or 
btrfs status as a development filesystem IMO indicates that installers 
aren't including the warnings about making such even non-default choices 
that they arguably should be including) where all recommendations are to 
be ready for loss of data should it occur, as it's a definitely more 
likely possibility than it should be with a stable filesystem.  With that 
in mind, playing with non-default mount options seems rather trivial by 
comparison.

Still, the previously mentioned constantly written large vm/db file use-
case is a big one these days, and with the general purpose installation 
often not having dedicated partitions for such things (btrfs subvolumes 
don't yet allow per-subvolume setting of such options)...

But for the generally much different use-case of a system volume where 
all the system binaries and config is stored, autodefrag makes a lot of 
sense to enable by default.

Or installers could simply be better about not writing into existing 
files in the installation in the first place, so people could turn it on 
right after installation and not have to worry about existing 
fragmentation.  But... installing to btrfs is really a reasonably new 
situation, and I'd guess "best practices" are still evolving just as the 
filesystem itself is.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

