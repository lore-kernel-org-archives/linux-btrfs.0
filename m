Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f51.google.com ([74.125.82.51]:38272 "EHLO
	mail-wm0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753411AbcDFWIz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 Apr 2016 18:08:55 -0400
Received: by mail-wm0-f51.google.com with SMTP id u206so63402635wme.1
        for <linux-btrfs@vger.kernel.org>; Wed, 06 Apr 2016 15:08:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <pan$20f45$63875276$ec725eab$c0dca8d1@cox.net>
References: <CAFKQ2BsxWYejWOPMCw5JuF-SXM03-papUu6LXM5KBNKthxAPxg@mail.gmail.com>
	<pan$20f45$63875276$ec725eab$c0dca8d1@cox.net>
Date: Wed, 6 Apr 2016 18:08:53 -0400
Message-ID: <CAFKQ2BucABTGrm9eybdC6j8fJOsfzLing7GfGaU=Jd9zUZV2wA@mail.gmail.com>
Subject: Re: unable to mount btrfs pool even with -oro,recovery,degraded,
 unable to do 'btrfs restore'
From: Ank Ular <ankular.anime@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Apr 6, 2016 at 5:02 PM, Duncan <1i5t5.duncan@cox.net> wrote:
> Ank Ular posted on Wed, 06 Apr 2016 11:34:39 -0400 as excerpted:
>
>> I am currently unable to mount nor recover data from my btrfs storage
>> pool.
>>

> With four devices behind by (fortunately only) 26 transactions, and
> luckily all at the same transaction/generation number, you're likely
> beyond what the recovery mount option can deal with (I believe upto three
> transactions, tho it might be a few more in newer kernels), and obviously
> from your results, beyond what btrfs restore can deal with automatically
> as well.
>
> There is still hope via btrfs restore, but you have to feed it more
> information than it can get on its own, and while it's reasonably likely
> that you can get that information and as a result a successful restore,
> the process of finding the information and manually verifying that it's
> appropriately complete is definitely rather more technical than the
> automated process.  If you're sufficiently technically inclined (not at a
> dev level, but at an admin level, able to understand technical concepts
> and make use of them on the command line, etc), your chances at recovery
> are still rather good.  If you aren't... better be getting out those
> backups.
>
> There's a page on the wiki that describes the general process, but keep
> in mind that the tools continue to evolve and the wiki page may not be
> absolutely current, so what it describes might not be exactly what you
> get, and you may have to do some translation between the current tools
> and what's on the wiki.  (Actually, it looks like it is much more current
> than it used to be, but I'm not sure whether all parts of the page have
> been updated/rewritten or not.)
>
> https://btrfs.wiki.kernel.org/index.php/Restore
>
> You're at the "advanced usage" point as the automated method didn't work.
>
> The general idea is to use the btrfs-find-root command to get a list of
> previous roots, their generation number (aka transaction ID, aka transid),
> and their corresponding byte number (bytenr).  The bytenr is the value
> you feed to btrfs restore, via the -t option.
>
> I'd start with the 625039 generation/transid that is the latest on the
> four "behind" devices, hoping that the other devices still have it intact
> as well.  Find the corresponding bytenr via btrfs-find-root, and feed it
> to btrfs restore via -t.  But not yet in a live run!!
>
> First, use -t and -l together, to get a list of the tree-roots available
> at that bytenr.  You want to pick a bytenr/generation that still has its
> tree roots intact as much as possible.  Down near the bottom of the page
> there's a bit of an explanation of what the object-IDs mean.  The low
> number ones are filesystem-global and are quite critical.  256 up are
> subvolumes and snapshots.  If a few snapshots are missing no big deal,
> tho if something critical is in a subvolume, you'll want either it or a
> snapshot of it available to try to restore from.
>
> Once you have a -t bytenr candidate with ideally all of the objects
> intact, or as many as possible if not all of them, do a dry-run using the
> -D option.  The output here will be the list of files it's trying to
> recover and thus may be (hopefully is, with a reasonably populated
> filesystem) quite long.  But if it looks reasonable, you can use the same
> -t bytenr without the -D/dry-run option to do the actual restore.  Be
> sure to use the various options restoring metadata, symlinks, extended
> attributes, snapshots, etc, if appropriate.
>
> Of course you'll need enough space to restore to as well.  If that's an
> issue, you can use the --path-regex option to restore the most important
> stuff only.  There's an example on the page.
>
>
> If that's beyond your technical abilities or otherwise doesn't work, you
> may be able to use some of the advanced options of btrfs check and btrfs
> rescue to help, but I've never tried that myself and you'll be better off
> with help from someone else, because unlike restore, which doesn't write
> to the damaged filesystem the files are being restored from and thus
> can't damage it further, these tools and options can destroy any
> reasonable hope of recovery if they aren't used with appropriate
> knowledge and care.
>
> --
> Duncan - List replies preferred.   No HTML msgs.

I did read this page: https://btrfs.wiki.kernel.org/index.php/Restore

But, not understanding the meaning of much of the terminology, I
didn't "get it".

Your explanation makes the page much clearer. I do need one
clarification. I'm assuming
that when I issue the command:

   btrfs-find-root /dev/sdb

it doesn't actually matter which device I use and that, in theory, any
of the 20 devices should yield the same listing.

By the same token, when I issue the command:

   btrfs restore -t n /dev/sdb /mnt/restore

any of the 20 devices would work equally well.

I want to be clear on this because this will be the first time I
attempt using 'btrfs restore'. While I think I understand what
is supposed to happen now, there is nothing like experience to make
that 'understanding' more solid. I just want to be
sure I haven't confused myself before I do something more or less irrevocable.

Fortunately, I neither use sub-volumes nor snapshots since nearly all
of the files are static in nature.

As far as backups go, we're talking about a home server/workstation.
While I used to go through an excruciating budget
battle every year on a professional level in my usually futile fight
for disaster recovery planning funding, my personal
budget is much, nuch more limited.

Of the 53T currently in limbo, about ~6-8T are on several hundreds of
DVDs. About 10T are on the hard drives of the
my prior system which needs a replacement motherboard. {I had rsynced
the data to a new build system just before imminent
 failure}. Most of the rest can be re-collected from a variety of
still existing sources as I still have the file names and link
locations
on a separate file system. My 'disaster recovery plans' assume
patience, a limited budget and knowing where everything
came from originally. Backups are a completely different issue. My
backup planning won't be complete for another 12
or so since it essentially means building a duplicate system. Since my
budget funding is limited, my duplicate system
is happening piecemeal every other month or so.

I do understand both backups {having implemented real time transaction
journal-ling to tape combined with weekly 'dd'
copies to tape, monthly full backups with 6 month retention
yada-yada-yada} and disaster recovery planning. Been there.
Done that. Save my ___ multiple times.

The crux is always funding.

Naturally, using 'btrfs restore' successfully will go a long ways
towards shortening the recovery process.

It will be about a week before I can begin since I need to acquire the
restore destination storage first.

Thank you for explaining the process.
