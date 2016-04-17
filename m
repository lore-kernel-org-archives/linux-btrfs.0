Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:45002 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752205AbcDQDiF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 16 Apr 2016 23:38:05 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1ardX7-0000X6-DS
	for linux-btrfs@vger.kernel.org; Sun, 17 Apr 2016 05:38:01 +0200
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 17 Apr 2016 05:38:01 +0200
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 17 Apr 2016 05:38:01 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs-send -c fails: reproduction case
Date: Sun, 17 Apr 2016 03:37:55 +0000 (UTC)
Message-ID: <pan$e62d1$6feab589$fd8edd30$267b2a04@cox.net>
References: <57129BB1.8020802@za3k.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Zachary Vance posted on Sat, 16 Apr 2016 13:08:17 -0700 as excerpted:

> Reproduction case after running into the same problem as Paride
> Legovini:
> http://article.gmane.org/gmane.comp.file-systems.btrfs/48706/match=send

[As a btrfs user and list-regular with a personal use-case that doesn't 
include send/receive, I generally skip posts on that topic, leaving them 
for those with more direct experience.  Except... the above thread didn't 
seem to get /any/ replies except from others with the same problem, and 
while you just posted yours a few hours ago, yours hasn't either so far.  
But while I don't follow send/receive /that/ closely and could be wrong, 
I did happen to read this one and think I know the problem, so...]

> To recap, the basic problem is that you can get into a state where
> "btrfs-send -c" fails for a subvolume, with "ERROR: parent determination
> failed for 9622".
> 
> I'm pretty sure this isn't the intended behavior, and it's certainly
> preventing me from copying my backups right now. If someone could
> confirm on a **completely** fresh system I'd appreciate it.
> 
> [root@burn ~]# sudo btrfs sub create m
> Create subvolume './m'
> [root@burn ~]# sudo btrfs sub create m/a
> Create subvolume 'm/a'
> [root@burn ~]# sudo btrfs sub create m/b
> Create subvolume 'm/b'

OK, at this point you have created the following structure, with all 
three subvolumes created under user root's home dir as the working 
directory [view using a monospace font, as commonly used at the CLI,
auto-rewrapping disabled]:

/root/		(pwd and there originally)
     |
     + m/	(/root/m, new subvolume)
     |  |
     |  + a/	(/root/m/a, new subvolume)
     |  |
     |  + b/	(/root/m/b, new subvolume)
     |
    ...         (to be filled in below)

> [root@burn ~]# sudo btrfs sub snapshot m/a -r a
> Create a readonly snapshot of 'm/a' in './a'
> [root@burn ~]# sudo btrfs sub snapshot m/b -r b
> Create a readonly snapshot of 'm/b' in './b'

OK, you created snapshots of /root/m/a and /root/m/b, with the structure 
now looking like this:

/root/       (pwd and there originally)
     |
     + m/    (/root/m, new subvolume)
     |  |
     |  + a/ (/root/m/a, new subvolume)
     |  |
     |  + b/ (/root/m/b, new subvolume)
     |
     + a/    (/root/a, ro snap of /root/m/a, which is its parent)
     |
     + b/    (/root/b, ro snap of /root/m/b, which is its parent)

> [root@burn ~]# sudo btrfs sub delete m/a
> Delete subvolume (no-commit): '/root/m/a'
> [root@burn ~]# sudo btrfs sub delete m/b
> Delete subvolume (no-commit): '/root/m/b'
> [root@burn ~]# sudo btrfs sub delete m
> Delete subvolume (no-commit): '/root/m'

OK, now you delete the parent subvolumes and the subvolume that contained 
them, leaving:

/root/       (pwd and there originally)
     |
     + a/    (/root/a, ro snap of (now deleted) /root/m/a, no parent left)
     |
     + b/    (/root/b, ro snap of (now deleted) /root/m/b, no parent left)

> [root@burn ~]# sudo btrfs send -c a b >/dev/null
> At subvol b ERROR: parent determination failed for 9622

AFAIK, that's entirely expected, because there /is/ no parent now to 
incrementally send against -- you deleted the parents and can no longer 
incrementally send against them.

Instead, at this point you have to do a full (non-incremental) send, 
since there's nothing to match against as the parent for an incremental 
send.


However, what I believe you /wanted/ to do is something like this, 
assuming monthly snapshots to make it easy:

/root/              (pwd and there originally)
     |
     + m/           (/root/m, subdir or subvol, doesn't matter)
     |  |
     |  + a/        (/root/m/a, subvolume to be snapshotted)
     |  |
     |  + b/        (/root/m/b, subvolume to be snapshotted)
     |
     + s2016.01/    (subdir or subvol containing January's snaps)
     |         |
     |         + a/ (ro snap of /root/m/a)
     |         |
     |         + b/ (ro snap of /root/m/b)
     |
     + s2016.02/    (subdir or subvol containing February's snaps)
     |         |
     |         + a/ (ro snap of /root/m/a)
     |         |
     |         + b/ (ro snap of /root/m/b)
     |
     + s2016.03/    (subdir or subvol containing March's snaps)
     |         |
     |         + a/ (ro snap of /root/m/a)
     |         |
     |         + b/ (ro snap of /root/m/b)
     |
    ...             (more snapshots added as time goes on...)

The thing to note here is that snapshots following the first one can also 
point at that first snapshot as a parent, since it's a snapshot of that 
subvolume at an earlier point.  It's actually that relationship which 
incremental send uses, sending the difference between the two snapshots 
of the same subvolume, taken at different times.

Now, the first snapshots, created and sent in January in this example, 
would need to be a full send, to create the same reference on the 
receiving end as on the sending end.

February's snapshots could then be sent as incrementals from January's, 
provided January's hadn't been deleted on either side yet, since both the 
send and receive sides have to have the same reference for an incremental 
send/receive to work.

You'd then have a choice.  After you had February's snapshots safely on 
both sides, you could if you want delete January's on one or both sides, 
in which case you would have to use February's snaps as the reference for 
March's incremental send/receive.  Alternatively, if you kept January's 
snaps on both ends, you could point March's -p reference at either 
January's or February's snap, or even use -c twice, referencing both 
January's and February's.

The strategy you use would depend on whether you want or need to delete 
snapshots to keep them within a reasonably manageable number (say a few 
hundred per snapshotted subvolume, under 2000 total per filesystem), and 
assuming you do, whether you are content keeping only the last snapshot 
as a reference for the next one (parent of Febuary's snap for March, 
March's snap for April, etc), or whether you want to keep a single 
reference on both sides (perhaps with the intermediate incrementals kept 
on one side just in case) and use incrementals from it, say using January 
as the reference for the entire year, so the number of changes and size 
of the send grows over the course of the year.

If however at any time you either delete all snaps on one side or the 
other, or delete different ones on each side so they no longer have any 
snaps in common, then you have to do a full send the next time, as 
there's no longer a common reference on both sides.  Of course that 
applies separately to the a and b snaps.

Tho of course you can delete the working subvolumes /root/m/a and/or 
/root/m/b, any time you want, as long as you're willing to lose the 
changes since the last snapshot was made.  You can then create a new read-
write snapshot from one of your read-only snapshots, calling the new read-
write snapshot /root/m/a or /root/m/b again, in effect rolling back to 
the state at the time of the snapshot.

So what's the difference between -p (parent) and -c (clone-source)?

You can point send at only one parent, and it's pretty strictly defined 
as an earlier snapshot of the same subvolume that's still on both sides.  
This is less flexible than clone-src, but by being stricter, less 
metadata has to actually be sent and received.

Clone-sources, meanwhile, are more flexible and less strict, but you pay 
for that in the amount of metadata sent, so they will tend to be larger 
if you use only one -c in place of the -p that you could have used 
instead.  What clone-sources do allow for, however, is coverage of cases 
where you might have, for example, moved files from one subvolume to 
another, where both subvolumes were previously snapshotted, with common 
snapshots available as references on both ends.  In this case, you'll 
likely want to use the same parent (unless you actually moved /most/ of 
the files, in which case you might want to use the new location as the 
parent), while pointing -c at the second snapshot as well, since it 
actually contained some of the files previously contained in the parent 
location.  As long as there's just one -p and both it and all -c 
snapshots are available for reference on both sides, send can take 
advantage of this, and while it'll send additional metadata for non-
parent -c snapshots, it still won't have to send the actual data, since 
it can simply point to the -c snapshot reference instead.

Of course the send/receive flow is one-way -- receive can't send anything 
back to send to tell it to send the whole file after all, the reference 
send tried to make doesn't exist on the receive side yet.  That is why 
the referenced snapshots, both -p AND -c referenced snapshots, must 
already exist on BOTH sides.  If the don't exist on both sides or if the 
snapshots are changed (it's possible to set/unset the read-only property, 
so you could unset it, make a change, then set it again, tho that change 
would break any attempt to use it as a -p reference and may break -c 
references, tho AFAIK in the latter case it'd only break if the specific 
thing referenced had changed) on one or both sides, then the send may 
succeed, but the receive fail as the reference send made doesn't match 
what receive sees on its side.

Bottom line, the first send must always be a full send, and after that, 
incremental sends can only be used as long as you have the same previous -
p and -c snapshots to reference on both sides.  Don't delete (or change) 
your reference unless you either (a) never plan to use it as a send 
reference again, or (b) are willing to do a full non-incremental send/
receive the next time, to recreate that reference.

Does that make more sense now, or were you actually already doing it that 
way and still getting the errors, and just didn't say so, or did I just 
confuse you even further (hopefully not!)?

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

