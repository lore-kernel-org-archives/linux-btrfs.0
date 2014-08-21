Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:34211 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754086AbaHULLS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Aug 2014 07:11:18 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: Shriramana Sharma <samjnaa@gmail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Significance of high number of mails on this list?
Date: Thu, 21 Aug 2014 13:11:12 +0200
Message-ID: <2217061.yFV10mnZWq@merkaba>
In-Reply-To: <CAH-HCWVZPNkc7ycsL4jH0i6niVU3nqZiB2MLD6CfP85FckAg7g@mail.gmail.com>
References: <CAH-HCWVZPNkc7ycsL4jH0i6niVU3nqZiB2MLD6CfP85FckAg7g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello!

Am Donnerstag, 21. August 2014, 08:52:52 schrieb Shriramana Sharma:
> Hello. People on this list have been kind enough to reply to my
> technical questions. However, seeing the high number of mails on this
> list, esp with the title PATCH, I have a question about the
> development itself:
> 
> Is this just an indication of a vibrant user/devel community [*] and
> healthy development of many new nice features to eventually come out
> in stable form later, or are we still at the fixing rough edges stage?
> IOW what is the proportion of commits adding new features to those
> stabilising/fixing features?

Oh, well, sometimes I can guess from the patch descriptions whether this is 
more of a fix or more of a feature. And on what I see in the last week or do 
its mostly stabilization and fixing work. Also the last pull request was more 
about fixes.

Which is good, since fixes help to stabilize BTRFS further.

> [* Since there is no separate btrfs-users vs brtfs-dev I'm not able to
> gauge this difference either. i.e. if there were a dedicated -dev list
> I might not be alarmed by a high number of mails indicating fast
> development.]

Why would that make a difference?
 
> Mostly I have read like "BTRFS is mostly stable but there might be a
> few corner cases as yet unknown since this is a totally new generation
> of FSs". But still given the volume of mails here I wanted to ask...
> I'm sorry I realize I'm being a bit vague but I'm not sure how to
> exactly express what I'm feeling about BTRFS right now...

Well, I do not really get what you are after. What is your *intention*?

Do you want to try out BTRFS? Do you want to use BTRFS in production use? Do 
you want to use BTRFS on a desktop, laptop, server? What BTRFS features do you 
want to use? Just a plain volume or RAID 1 and so on…

On any account if you plan to use BTRFS I strongly recommend to be subscribed 
to this mailing list and be willing to deal with issues.

There are hangs reported happening on 3.15 and 3.16 in space full situations. 
I long thought 3.14 would be safe, but there have been problem reports as 
well.

That said, none of my BTRFS filesystems corrupted itself so far. I have a 
slight glitch on /home BTRFS RAID 1 I was not yet able to repair, but 
scrubbing tells me my data is good. And at keeping stored data fine and healthy 
all of my BTRFS installations have been good at. According to scrubbing I 
never ever lost a single byte on *any* BTRFS drive. Except a BTRFS RAID 0 over 
16 or 18 SAS disks which went completely bust quite some time ago, but first 
this could have been a hardware issue and second maybe btrfs-zero-log I wasn´t 
aware of could have helped.

I close with a summary on where I use BTRFS right now:

- my main laptop is except for /boot completely BTRFS, partly RAID 1 on two 
SSDs, partly single drived. It is BTRFS since I got it. So more than 3 years. 
RAID 1 since four months or so. I used snapshots manually there, but as the 
lockups seem to happen more easily as BTRFS fills up more quickly, I didn´t. I 
think I will use snapshots again now I am testing some patches to fix those 
lockups.

- my old music laptop was BTRFS except for /boot for years.

- I just moved my new music laptop /home to BTRFS as well, / and /boot are 
Ext4. I did you by restoring from backup instead of using btrfs-convert

- I have two large external eSATA HDDs which are BTRFS as well. One since more 
than a year. I use snapshots manuelly there to hold old backups. Still doing 
backup by rsync so far.

- I recently moved part of my server VM onto BTRFS with several subvolumes. 
/home and /srv are on it already. /home with maildir stuff and /srv with 
owncloud data storage. I will be moving /var soon as well, I think. I use 
snapshots manually there.

Many of my BTRFS file system is not all of them use lzo compression. All use 
space_cache. Most of them use big metadata and skinny extents and ext ref for 
more hardlinks as well.

So while BTRFS seems to keep already stored data safe for me very reliably, I 
do have issues with reliability during runtime on *some* BTRFS setups, mostly 
those where the trees of BTRFS easily allocate all of the volume, so somewhat 
heavily used *and* somewhat space constrained setups, where automatic tree 
rebalancing would be helpful. These require manual maintenance for now from 
time to time.


I know some are using btrfs send and receive already as well. I didn´t yet got 
to set it up. Also see the nice slides by Marc Merlin.

http://www.phoronix.com/scan.php?page=news_item&px=MTc2Njk

http://events.linuxfoundation.org/sites/events/files/slides/Btrfs.pdf

Thanks,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
