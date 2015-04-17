Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fed1rmfepi204.cox.net ([68.230.241.149]:36429 "EHLO
	fed1rmfepi204.cox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751506AbbDQDkR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 16 Apr 2015 23:40:17 -0400
Received: from eastrmimpo306 ([68.230.241.238]) by eastrmfepo102.cox.net
          (InterMail vM.8.01.05.15 201-2260-151-145-20131218) with ESMTP
          id <20150417032244.GVPJ21735.eastrmfepo102.cox.net@eastrmimpo306>
          for <linux-btrfs@vger.kernel.org>;
          Thu, 16 Apr 2015 23:22:44 -0400
Date: Thu, 16 Apr 2015 20:24:29 -0700
From: Duncan <1i5t5.duncan@cox.net>
To: Dan Merillat <dan.merillat@gmail.com>
Cc: BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs-progs: have restore set atime/mtime
Message-ID: <20150416202429.36706e57@ws>
In-Reply-To: <GqKV1q00y3iShQZ01qKkzm>
References: <553046DA.7090809@gmail.com>
	<pan$9774f$be540432$25bcbd9d$e84db021@cox.net>
	<GqKV1q00y3iShQZ01qKkzm>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 16 Apr 2015 22:19:46 -0400
Dan Merillat <dan.merillat@gmail.com> wrote:

[Reordered to standard list quote/reply-in-context order.]

> On Thu, Apr 16, 2015 at 9:09 PM, Duncan <1i5t5.duncan@cox.net> wrote:
> > Dan Merillat posted on Thu, 16 Apr 2015 19:33:46 -0400 as excerpted:
> >
> >> The inode is already found, use the data and make restore
> >> friendlier.
> >
> > Unless things have changed recently, restore doesn't even restore
> > user/ group ownership, let alone permissions. [...] It simply
> > creates the files it restores as the owner/group it is run as
> > (normally root), using standard umask rules, I believe.
> >
> > So if you're going to have it start restoring metadata at all,
> > might as well have it do ownership/perms too, if it can.  Otherwise
> > atime/mtime are hardly worth bothering with.

> That's not a bad idea.  In my case it was all owned by the same user
> (media storage) so the only thing of interest was the timestamps.
> 
> I can whip up a patch to do that as well.

That would be much appreciated. =:^)

Last time I had to do a restore I had a backup, but it was a bit older
than I would have liked.  As a result, once I realized
ownership/perms metadata wasn't restored, it was simple enough to
quick-hack a script to check each restored file against the backup, and
where the file existed in both, do a chown and chmod using
--reference=$bakfile.  That left only the new-since-backup files, which
were few enough and obvious enough I could fix them manually.

If I'd have not had a backup (if a bit dated), I'd have obviously been
even *more* thankful for restore, and probably would have done
arbitrary chown/chmod and simply had more manual fixes to do, but I'd
have surely been swearing rather more in the process.

So patching restore to "just work", restoring all metadata
possible (of course it won't always be possible, we /are/ assuming a
likely heavily damaged btrfs if we're resorting to restore, so it's
not always going to be possible), would be a huge improvement.

BTW, symlinks too.  At least back then (I think about a year ago, quite
some changes since then), restore entirely skipped symlinks.
I'm not a coder but I assumed that was because that was entirely
metadata, and all it was restoring was data.  So I had to manually
recreate all my symlinks too.  If that could be patched at the same
time, I'm sure it'd make a lot of folks happy! =:^)  Obviously, if
you're resorting to restore, you take what you can get, and I /was/
happy with what I got, if a bit disappointed at the same time, but the
more it's possible to get...

IMO, getting all that in btrfs restore would surely make for a
milestone btrfs-progs release. =:^)

-- 
Duncan - No HTML messages please; they are filtered as spam.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman
