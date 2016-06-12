Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f53.google.com ([209.85.213.53]:33889 "EHLO
	mail-vk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751242AbcFLGsI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 12 Jun 2016 02:48:08 -0400
Received: by mail-vk0-f53.google.com with SMTP id t129so16346125vka.1
        for <linux-btrfs@vger.kernel.org>; Sat, 11 Jun 2016 23:48:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <pan$dc991$bc4b5712$73c16333$5c108126@cox.net>
References: <CAMPo9spCUSEwMBhGWcr1iX0ny28e52GYMO4D=eug-MZaWB0iEQ@mail.gmail.com>
 <pan$dc991$bc4b5712$73c16333$5c108126@cox.net>
From: =?UTF-8?B?QmVhcmNhdCDFnsOhbmRvcg==?= <bearcatsandor@gmail.com>
Date: Sun, 12 Jun 2016 00:47:26 -0600
Message-ID: <CAMPo9srkVgJkBqmH6LoTuEyBj6yP-=HX6QR6HTFrfr+zQPyLvw@mail.gmail.com>
Subject: Re: Files seen by some apps and not others
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thank you for that info Ducan! I did the restore on the whole drive
and it errored out on me. I'll try the restore on some key files (audo
mostly) and see what i can get off of it.

Is there a fix for the bad tree block error, which seems to be the
root (pun intended) of all this?

On Sat, Jun 11, 2016 at 8:18 PM, Duncan <1i5t5.duncan@cox.net> wrote:
> Bearcat Şándor posted on Sat, 11 Jun 2016 13:54:44 -0600 as excerpted:
>
>> I'm about to try a btrfs restore to see what it can do for me. Any
>> pointers or help here? I don't want to fsck things up further.
>
> FWIW, btrfs restore doesn't write anything at all to the filesystem it's
> restoring from -- it's read-only in that regard -- so you really don't
> have to worry about it screwing up a filesystem further.
>
> But by the same token, btrfs restore may not do what you think it does.
> It doesn't try to fix the filesystem.  Rather, it's a way to try to
> salvage anything you can off a filesystem that won't mount, or, as it
> would be used here, that will mount but where files aren't showing up
> properly so you can't just copy them elsewhere using normal means.  It
> writes the files it can salvage to some other filesystem, which of course
> means that whatever filesystem you're writing the files to must have
> enough room for the files to be written.
>
> Also note the various restore options.  In particular, the restore
> metadata option must be used if you want to restore the same ownership,
> permissions and timestamp information.  Otherwise, restore simply writes
> the files as the user you're running it as (root), using the current
> umask.  Similarly, if you want to restore symlinks and extended
> attributes, there's options for that, otherwise they aren't restored.
>
> And you won't necessarily be wanting to restore snapshots, as you should
> have backups if needed for the history, and are likely most worried about
> the current version of the files, so snapshots aren't restored unless you
> use the appropriate option.
>
> Given that the filesystem is still mounted and most files are apparently
> still readable normally, you may want to copy off what you can that way,
> and only restore specific files using btrfs restore.  Or you may not have
> room on the destination filesystem to restore everything, and will need
> to pick only the most important stuff to restore.  That's where the
> pattern-match option comes in.
>
> What I did here when I used restore (I had backups of course but they
> weren't current) was use the metadata and symlinks restore options, and
> simply restored everything.
>
> Note that if a particular directory has a lot of files, restore will
> begin to think that it's looping to much and that it's stuck.  It'll
> prompt you to continue, and may prompt a *LOT*.  Here I have multiple
> independent small filesystems, so it wasn't a big deal, but you may need
> to experiment with automating the "yes" if your filesystem is huge
> (piping the output of the yes command to stdin, for instance, or similar
> sysadmin prompt automation tricks).  A number of folks have mentioned
> that and requested a way to say "yes, really all, don't ask again", an
> option that btrfs restore unfortunately doesn't have yet.
>
> --
> Duncan - List replies preferred.   No HTML msgs.
> "Every nonfree program has a lord, a master --
> and if you use the program, he is your master."  Richard Stallman
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Bearcat M. Şándor
Feline Soul Systems LLC
Voice: 872.CAT.SOUL (872.228.7685)
