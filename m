Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f44.google.com ([209.85.160.44]:56544 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082AbaFEDWu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 4 Jun 2014 23:22:50 -0400
Received: by mail-pb0-f44.google.com with SMTP id rq2so447828pbb.17
        for <linux-btrfs@vger.kernel.org>; Wed, 04 Jun 2014 20:22:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <pan$765af$b28af9a8$903ce16b$940baf34@cox.net>
References: <CAEezp7uMXA3t8-GDVcVzx9An+hPBZmynYZ-wUXzhJuP93czs1w@mail.gmail.com>
	<pan$765af$b28af9a8$903ce16b$940baf34@cox.net>
Date: Thu, 5 Jun 2014 10:22:49 +0700
Message-ID: <CAG1y0seEWf0RqDuJgG3Jx9iz-yPLh8piQ00dMAQ9aPLeCEp3vA@mail.gmail.com>
Subject: Re: Very slow filesystem
From: "Fajar A. Nugraha" <list@fajar.net>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

(resending to the list as plain text, the original reply was rejected
due to HTML format)

On Thu, Jun 5, 2014 at 10:05 AM, Duncan <1i5t5.duncan@cox.net> wrote:
>
> Igor M posted on Thu, 05 Jun 2014 00:15:31 +0200 as excerpted:
>
> > Why btrfs becames EXTREMELY slow after some time (months) of usage ?
> > This is now happened second time, first time I though it was hard drive
> > fault, but now drive seems ok.
> > Filesystem is mounted with compress-force=lzo and is used for MySQL
> > databases, files are mostly big 2G-8G.
>
> That's the problem right there, database access pattern on files over 1
> GiB in size, but the problem along with the fix has been repeated over
> and over and over and over... again on this list, and it's covered on the
> btrfs wiki as well

Which part on the wiki? It's not on
https://btrfs.wiki.kernel.org/index.php/FAQ or
https://btrfs.wiki.kernel.org/index.php/UseCases

> so I guess you haven't checked existing answers
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


If COW and rewrite is the main issue, why don't zfs experience the
extreme slowdown (that is, not if you have sufficient free space
available, like 20% or so)?

-- 
Fajar
