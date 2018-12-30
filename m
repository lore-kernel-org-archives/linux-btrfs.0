Return-Path: <SRS0=9xGW=PH=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5880C43387
	for <linux-btrfs@archiver.kernel.org>; Sun, 30 Dec 2018 05:48:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8BCB121019
	for <linux-btrfs@archiver.kernel.org>; Sun, 30 Dec 2018 05:48:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725999AbeL3Fqo (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 30 Dec 2018 00:46:44 -0500
Received: from [195.159.176.226] ([195.159.176.226]:44360 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1725942AbeL3Fqm (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 30 Dec 2018 00:46:42 -0500
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-3@m.gmane.org>)
        id 1gdTtk-0001m4-03
        for linux-btrfs@vger.kernel.org; Sun, 30 Dec 2018 06:44:27 +0100
X-Injected-Via-Gmane: http://gmane.org/
To:     linux-btrfs@vger.kernel.org
From:   Duncan <1i5t5.duncan@cox.net>
Subject: Re: Undelete files
Date:   Sun, 30 Dec 2018 05:44:21 +0000 (UTC)
Message-ID: <pan$bb7e2$c0ed97b9$f1837c46$82edfe21@cox.net>
References: <CAMrg+aRiTuesnBYx=UxQBXLSDXXwFOAKuFtGcwB6ZebQgycCXQ@mail.gmail.com>
        <pan$b27cb$1e0679f9$7f3c174e$d11713c1@cox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@blaine.gmane.org
User-Agent: Pan/0.146 (Hic habitat felicitas; e65ba1502)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Duncan posted on Sun, 30 Dec 2018 04:11:20 +0000 as excerpted:

> Adrian Bastholm posted on Sat, 29 Dec 2018 23:22:46 +0100 as excerpted:
> 
>> Hello all,
>> Is it possible to undelete files on BTRFS ? I just deleted a bunch of
>> folders and would like to restore them if possible.
>> 
>> I found this script
>> https://gist.github.com/Changaco/45f8d171027ea2655d74 but it's not
>> finding stuff ..
> 
> That's an undelete-automation wrapper around btrfs restore...
> 
>> ./btrfs-undelete /dev/sde1 ./foto /home/storage/BTRFS_RESTORE/
>> Searching roots...
>> Trying root 389562368... (1/70)
>> ...
>> Trying root 37339136... (69/70)
>> Trying root 30408704... (70/70)
>> Didn't find './foto'
> 
> That script is the closest thing to a direct undelete command that btrfs
> has.  However, there's still some chance...
> 
> ** IMPORTANT **  If you still have the filesystem mounted read-write,
> remount it read-only **IMMEDIATELY**, because every write reduces your
> chance at recovering any of the deleted files.
> 
> (More in another reply, but I want to get this sent with the above
> ASAP.)


First a question:  Any chance you have a btrfs snapshot of the deleted 
files you can mount and recover from?  What about backups?

Note that a number of distros using btrfs have automated snapshotting 
setup, so it's possible you have a snapshot with the files safely 
available, and don't even know it.  Thus the snapshotting question (more 
on backups below).  It could be worth checking...


Assuming no snapshot and no backup with those files...

Disclaimer:  I'm not a dev, just a btrfs user and list regular myself.  
Thus, the level of direct technical help I can give is limited, and much 
of what remains is more what to do different to prevent a next time, tho 
there's some additional hints about the current situation further down...


Well the first thing in this case to note is the sysadmin's (yes, that's 
you... and me, and likely everyone here: [1]) first rule of backups:  The 
true value of data isn't defined by any arbitrary claims, but by the 
number of backups of that data it is considered valuable enough to have.  
Thus, in the most literal way possible, not having a backup is simply 
defining the data as not worth the time/trouble/hassle to make one, and 
not having a second and third and... backup is likewise, simply defining 
the value of the data as not worth that one more level of backup.  
(Likewise, not having an /updated/ backup is simply defining the value of 
data in the delta between the current working copy and the last backup as 
of trivial value, because as soon as it's worth more than the time/
trouble/resources required to update the backup, by definition, the 
backup will be updated in accordance with the value of the data in that 
delta.)

Thus, the fact that we're assuming no backup now means that that we 
already defined the data as of trivial value, not worth the time/trouble/
resources necessary to make even a single backup.

Which means no matter what the loss or why, hardware, software or 
"wetware" failure (the latter aka fat-fingering, as here), or even 
disaster such as flood or fire, when it comes to our data we can *always* 
rest easy, because we *always* save what was of most value, either the 
data if we defined it as such by the backups we had of it, or the time/
trouble/resources that would have otherwise gone into the backup, if we 
judged the data to be of lower value than that one more level of backup.

Which means there's a strict limit to the value of the data possibly 
lost, and thus a strict limit to the effort we're likely willing to put 
into recovery after that data loss risk factor appears to have evaluated 
to 1, before the recovery effort too becomes not worth the trouble.  
After all, if it /was/ worth the trouble, it would have also been worth 
the trouble to do that backup in the first place, and the fact that we 
don't have it means it wasn't worth that trouble.

At least for me, looking at it from this viewpoint significantly lowers 
my stress during disaster recovery situations.  There's simply not that 
much at risk, nor can there be, even in the event of losing 
"everything" (well, data-wise anyway, hardware, or for that matter, my 
life and/or health, family and friends, etc, unfortunately that's not as 
easy to backup as data!) to a fire or the like, since if there was more 
at risk, there's be backups (offsite backups in the fire/flood sort of 
case) we could fall back on should it come to that.


That said, before-the-fact, it's an unknown risk-factor, while after-the-
fact, that previously unknown risk-factor has evaluated to 100% chance of 
(at least apparent) data loss!  It's actually rather likely that will 
change the calculation to some extent, making it worth at least /some/ 
effort at restoration, even if in practice that effort is limited by the 
value of the time taken for it against the value of the already declared 
of relatively limited value data.


OK, now we can assume it's worth at least some limited effort to try to 
recover... and that we've already exhausted our best chances, for 
deletion mistakes, setting immutable to prevent the deletion in the first 
place, at least the easy-restore backups, btrfs snapshots, the automated 
btrfs-undelete script...  Now things get significantly less likely to 
succeed and significantly more effort to try...

If it's still worth going further given the limited chance at success and 
higher effort on one hand against the already defined as strictly limited 
value of the data on the other...

You can try running btrfs restore manually, giving you a better chance at 
recovery due to better control of things that undelete script automates 
away.

There's the btrfs-restore manpage as a first information resource for 
that.

At a higher technical level, there's a page on the wiki that describes 
the process of trying to find older filesystem roots and checking them to 
see if they are any good, then if they look good, feeding them to btrfs 
restore.  However, the undelete script already automates this to some 
extent, and if you're beyond that into doing it manually, not only are 
you getting rather technical, but the chances of successful recovery go 
down dramatically.  But they're still not zero, so it's possible you'll 
find it worth trying, tho honestly, given the already declared to be of 
limited value data and the low chances of success, I'd seriously question 
whether it's worth going this far.

https://btrfs.wiki.kernel.org/index.php/Restore

If that too fails, then we're getting into extreme territory.  You're 
looking at the possibility of getting a dev directly involved, and/or 
doing direct data scraping, either yourself, or sending it to a data 
recovery company and paying big money for it.  This *really* isn't going 
to be worth it for most people, and it's almost certainly not worth it 
for anyone observing the above data valuation and backups rule, but when 
it comes to humans there's always a few for virtually anything you can 
think of, thus the existence of such companies in the the first place.

---
[1] Sysadmin:  I use this term in the wide/literal sense of anyone, home 
user with a single system or professional with a thousand systems, it 
doesn't matter, literally with the responsibility of administering their 
system, in this context, basically anyone who can't simply go ask their 
admin to restore from the admin's backups, who thus has the 
responsibility of administering the system themselves.  Which in practice 
means anyone likely to be posting such questions here, as well as many 
who unfortunately couldn't even get that far, as they've simply never 
taken the responsibility seriously enough to bother learning how, or to 
bother studying the filesystem they chose to entrust the safety of their 
data to.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

