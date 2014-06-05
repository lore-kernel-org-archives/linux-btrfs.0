Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qa0-f54.google.com ([209.85.216.54]:49102 "EHLO
	mail-qa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751790AbaFEHuy (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 5 Jun 2014 03:50:54 -0400
Received: by mail-qa0-f54.google.com with SMTP id j15so870395qaq.13
        for <linux-btrfs@vger.kernel.org>; Thu, 05 Jun 2014 00:50:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <pan$765af$b28af9a8$903ce16b$940baf34@cox.net>
References: <CAEezp7uMXA3t8-GDVcVzx9An+hPBZmynYZ-wUXzhJuP93czs1w@mail.gmail.com>
	<pan$765af$b28af9a8$903ce16b$940baf34@cox.net>
Date: Thu, 5 Jun 2014 09:50:53 +0200
Message-ID: <CAEezp7sahY+hcKpu=aLA0T81UWjujRoxP465jBmQrr31ESB2qg@mail.gmail.com>
Subject: Re: Very slow filesystem
From: Igor M <igork20@gmail.com>
To: Duncan <1i5t5.duncan@cox.net>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thanks for explanation. I did read wiki, but didn't see this mentioned.
I saw mentioned 'nodatacow' mount option, but this disables
compression and I need compression.
Also I was wrong about files size, files can go to 70GB.
But data to this big tables is only appended, it's never deleted. So
no rewrites should be happening.
Also I see now that after some initial files (which are under 1GB) and
are rewritten/modifed a lot, it's very slow,
but other files where data is only appended it's more or less normal speed.
So it seems to be fragmentation.
For. ex. for one file that reading is slow (800M) filefrag reports
63282 extents and for ex. 8G file that only have 9 extents read speed
is normal.
I'll put freqently modified files in directory with NOCOW attribute.
Thanks.

On Thu, Jun 5, 2014 at 5:05 AM, Duncan <1i5t5.duncan@cox.net> wrote:
> Igor M posted on Thu, 05 Jun 2014 00:15:31 +0200 as excerpted:
>
>> Why btrfs becames EXTREMELY slow after some time (months) of usage ?
>> This is now happened second time, first time I though it was hard drive
>> fault, but now drive seems ok.
>> Filesystem is mounted with compress-force=lzo and is used for MySQL
>> databases, files are mostly big 2G-8G.
>
> That's the problem right there, database access pattern on files over 1
> GiB in size, but the problem along with the fix has been repeated over
> and over and over and over... again on this list, and it's covered on the
> btrfs wiki as well, so I guess you haven't checked existing answers
> before you asked the same question yet again.
>
> Never-the-less, here's the basic answer yet again...
>
> Btrfs, like all copy-on-write (COW) filesystems, has a tough time with a
> particular file rewrite pattern, that being frequently changed and
> rewritten data internal to an existing file (as opposed to appended to
> it, like a log file).  In the normal case, such an internal-rewrite
> pattern triggers copies of the rewritten blocks every time they change,
> *HIGHLY* fragmenting this type of files after only a relatively short
> period.  While compression changes things up a bit (filefrag doesn't know
> how to deal with it yet and its report isn't reliable), it's not unusual
> to see people with several-gig files with this sort of write pattern on
> btrfs without compression find filefrag reporting literally hundreds of
> thousands of extents!
>
> For smaller files with this access pattern (think firefox/thunderbird
> sqlite database files and the like), typically up to a few hundred MiB or
> so, btrfs' autodefrag mount option works reasonably well, as when it sees
> a file fragmenting due to rewrite, it'll queue up that file for
> background defrag via sequential copy, deleting the old fragmented copy
> after the defrag is done.
>
> For larger files (say a gig plus) with this access pattern, typically
> larger database files as well as VM images, autodefrag doesn't scale so
> well, as the whole file must be rewritten each time, and at that size the
> changes can come faster than the file can be rewritten.  So a different
> solution must be used for them.
>
> The recommended solution for larger internal-rewrite-pattern files is to
> give them the NOCOW file attribute (chattr +C) , so they're updated in
> place.  However, this attribute cannot be added to a file with existing
> data and have things work as expected.  NOCOW must be added to the file
> before it contains data.  The easiest way to do that is to set the
> attribute on the subdir that will contain the files and let the files
> inherit the attribute as they are created.  Then you can copy (not move,
> and don't use cp's --reflink option) existing files into the new subdir,
> such that the new copy gets created with the NOCOW attribute.
>
> NOCOW files are updated in-place, thereby eliminating the fragmentation
> that would otherwise occur, keeping them fast to access.
>
> However, there are a few caveats.  Setting NOCOW turns off file
> compression and checksumming as well, which is actually what you want for
> such files as it eliminates race conditions and other complex issues that
> would otherwise occur when trying to update the files in-place (thus the
> reason such features aren't part of most non-COW filesystems, which
> update in-place by default).
>
> Additionally, taking a btrfs snapshot locks the existing data in place
> for the snapshot, so the first rewrite to a file block (4096 bytes, I
> believe) after a snapshot will always be COW, even if the file has the
> NOCOW attribute set.  Some people run automatic snapshotting software and
> can be taking snapshots as often as once a minute.  Obviously, this
> effectively almost kills NOCOW entirely, since it's then only effective
> on changes after the first one between shapshots, and with snapshots only
> a minute apart, the file fragments almost as fast as it would have
> otherwise!
>
> So snapshots and the NOCOW attribute basically don't get along with each
> other.  But because snapshots stop at subvolume boundaries, one method to
> avoid snapshotting NOCOW files is to put your NOCOW files, already in
> their own subdirs if using the suggestion above, into dedicated subvolumes
> as well.  That lets you continue taking snapshots of the parent subvolume,
> without snapshotting the the dedicated subvolumes containing the NOCOW
> database or VM-image files.
>
> You'd then do conventional backups of your database and VM-image files,
> instead of snapshotting them.
>
> Of course if you're not using btrfs snapshots in the first place, you can
> avoid the whole subvolume thing, and just put your NOCOW files in their
> own subdirs, setting NOCOW on the subdir as suggested above, so files
> (and further subdirs, nested subdirs inherit the NOCOW as well) inherit
> the NOCOW of the subdir they're created in, at that creation.
>
> Meanwhile, it can be noted that once you turn off COW/compression/
> checksumming, and if you're not snapshotting, you're almost back to the
> features of a normal filesystem anyway, except you can still use the
> btrfs multi-device features, of course.  So if you're not using the multi-
> device features either, an alternative solution is to simply use a more
> traditional filesystem (like ext4 or xfs, with xfs being targeted at
> large files anyway, so for multi-gig database and VM-image files it could
> be a good choice =:^) for your large internal-rewrite-pattern files,
> while potentially continuing to use btrfs for your normal files, where
> btrfs' COW nature and other features are a better match for the use-case,
> than they are for gig-plus internal-rewrite-pattern files.
>
> As I said, further discussion elsewhere already, but that's the problem
> you're seeing along with a couple potential solutions.
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
