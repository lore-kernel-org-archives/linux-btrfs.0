Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:59128 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755191Ab3KLThh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Nov 2013 14:37:37 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1VgJmJ-0003q1-EY
	for linux-btrfs@vger.kernel.org; Tue, 12 Nov 2013 20:37:35 +0100
Received: from dyndsl-080-228-178-141.ewe-ip-backbone.de ([80.228.178.141])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 12 Nov 2013 20:37:35 +0100
Received: from hurikhan77+btrfs by dyndsl-080-228-178-141.ewe-ip-backbone.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 12 Nov 2013 20:37:35 +0100
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77+btrfs@gmail.com>
Subject: Re: btrfsck errors is it save to fix?
Date: Tue, 12 Nov 2013 20:37:57 +0100
Message-ID: <llcala-j7c.ln1@hurikhan77.spdns.de>
References: <52742B59.3060405@friedels.name> <CAE5mzvijfSOi9dP0MWCMd6=R5MW3bhabote4QYmFnqNEerDifw@mail.gmail.com> <5274BEC8.5060804@friedels.name> <52780E20.8020405@friedels.name> <CAE5mzvgrKqrv3LpmiF6iUK=GYsnGOQnSwLTM0dSfBE8ZP-4AuA@mail.gmail.com> <5279E581.4000700@friedels.name> <527BE712.40304@friedels.name> <pan$2f107$ddc92f2a$30381770$58497a03@cox.net> <527DF34B.2030309@friedels.name> <52812AAA.1080106@friedels.name> <3j78la-3nn.ln1@hurikhan77.spdns.de> <pan$9db1e$bf9333c2$543d2730$1c706b4d@cox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Duncan <1i5t5.duncan@cox.net> schrieb:

>> 100 is I_ERR_FILE_EXTENT_DISCOUNT. I'm not sure what kind of problem
>> this indicates but btrfsck does not seem to fix this currently - it just
>> detects it.
> 
> Interesting...

I wish it were documented what it technically means and what implications 
each error could have, so one could infer its severity from it. But I could 
not find anything, just source code which seems to only detect these errors. 
Btrfsck looks like its purpose is to fix internal tree structures but not 
inode errors.

>> BTW, my first impression was that "errors 400" means something like "400
>> errors" - but that is just a hex bitmask which shows what errors have
>> been found. So "errors 100" is just _one_ bit set, thus only _one_
>> error.
> 
> Same impression here, tho I did wonder at the conveniently even number of
> errors...  Perhaps "errors" should be retermed "error-mask" or some such,
> to make the meaning clearer?

Of course the numbers are even because they are powers of two:

  * error no. 1 is "errors 1" (2^0)
  * error no. 2 is "errors 2" (2^1)
  * error no. 3 is "errors 4" (2^2)
  * error no. 4 is "errors 8" (2^3)
  * error no. 5 is "errors 10" (...)
  * error no. 6 is "errors 20"
  * ... 40, 80, 100, 400, 800, 1000, 2000

If one or more distinct errors are found in an inode, the numbers are simply 
added (as hex code), so if you don't have error no. 1, numbers are always 
even - that's the nature of a bit mask. If I would happen to have error no. 
3, 5, and 6 in an inode, this would result in "errors 34" (0x4 + 0x10 + 
0x20).

>> You can use "btrfs subvolume list" to identify which subvolume 4444 is
>> and maybe recreate it or just delete it if it is disposable. The errors
>> should be gone then. That won't work for subvolume 256, however, for it
>> being the root subvolume obviously.
> 
> FWIW, that's only one set of _four_ errors total, listed twice, once for
> each subvolume (which here is very likely a snapshot), they apply to.
> The duplicate inode numbers on each "root" are a clue.
> 
> So while removing subvolume 4444 would kill the second listing of errors,
> it wouldn't change the fact that there's four errors there; it'd only
> remove the second, duplicate listing since that snapshot would no longer
> exist.

Oh, good pointer. That is probably true. I actually did not think of that 
possibility when I was writing that post.

>> The last of the quoted errors, by pure guessing, probably indicates a
>> problem with the space cache. But I think you already tried discarding
>> it. Did you run btrfsck right after discarding it without regenerating
>> the space cache? Does it still show that error then?
> 
> Is that even possible?  According to the wiki, the clear_cache mount
> option is supposed to clear it, but it doesn't disable the option, which
> remains enabled, and regeneration would start immediately.  The
> nospace_cache option should disable it, but I'm not sure if it's
> persistent across multiple mount cycles or not.  (I know the space_cache
> option is documented as persistent, and in fact, I never even had to
> enable it here, that was the kernel default when I first mounted my btrfs
> filesystems, but I don't know if nospace_cache toggles the persistence
> too, or just disables it for that mount.)

Possible? Yes. Although I did not implicitly mention it, you would combine 
"clear_cache" and "nospace_cache" - that should do the trick. Then unmount 
and check.

> [In case it's not clear, I'm simply an admin testing btrfs on my systems
> too.  I've been on-list for several months now, but I'm not a dev and
> have no knowledge of the code itself, only what I've read on the wiki and
> list, and my own experience.]

I second that. I use btrfs just on my private desktop PC, evaluating it, and 
I'm quite happy with it. But it still has many bugs which mostly occur 
during IO stress so I would not trust it any server data yet because servers 
exposed to internet access are mostly not controllable in the sense of what 
stress is put at them. But I'm eagerly looking forward to the possibilities 
it will offer for server systems - some time in the future.

Until then, I'm a linux server administrator, maintaining some systems for a 
hosting company, running XFS on them (which proved almost unbreakable), 
analysing problematic system behavior and all this stuff, and have some 
background in kernel-near, low-level, and application programming - the 
latter being probably the best reason for being on this list.

Regards,
Kai

