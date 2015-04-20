Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f50.google.com ([209.85.218.50]:34990 "EHLO
	mail-oi0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752312AbbDTD3E convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 19 Apr 2015 23:29:04 -0400
Received: by oign205 with SMTP id n205so114748361oig.2
        for <linux-btrfs@vger.kernel.org>; Sun, 19 Apr 2015 20:29:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAMsr+YEB2+vb3XirwNYe4y6mWOKJuZhKgekPvNQqQdcP4irPGw@mail.gmail.com>
References: <CAMsr+YEB2+vb3XirwNYe4y6mWOKJuZhKgekPvNQqQdcP4irPGw@mail.gmail.com>
Date: Mon, 20 Apr 2015 11:29:03 +0800
Message-ID: <CAMsr+YGdCnWSdNsh9Tfy6pKdu242zv1cR43mLq8_T7XjDaR5HQ@mail.gmail.com>
Subject: Re: The FAQ on fsync/O_SYNC
From: Craig Ringer <craig@2ndquadrant.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

While the discussion on -C was interesting, I'm really interested in
btrfs's fsync() behaviour, per the original post:

On 19 April 2015 at 21:20, Craig Ringer <craig@2ndquadrant.com> wrote:
> Hi all
>
> I'm looking into the advisability of running PostgreSQL on BTRFS, and
> after looking at the FAQ there's something I'm hoping you could
> clarify.
>
> The wiki FAQ says:
>
> "Btrfs does not force all dirty data to disk on every fsync or O_SYNC
> operation, fsync is designed to be fast."
>
> Is that wording intended narrowly, to contrast with ext3's nasty habit
> of flushing *all* dirty blocks for the entire file system whenever
> anyone calls fsync() ? Or is it intended broadly, to say that btrfs's
> fsync won't necessarily flush all data blocks (just metadata) ?
>
> Is that statement still true in recent BTRFS versions (3.18, etc)?
>
>
> PostgreSQL (and any other transactional database) absolutely requires
> that there be a system call that will provide a hard guarantee that
> all dirty blocks for a given file are on durable storage. In the case
> of data-integrity-significant metadata operations it has to be able to
> get the same guarantee on metadata too.
>
> The documentation for fsync says that:
>
>        fsync() transfers ("flushes") all modified in-core data of (i.e., modi‐
>        fied  buffer cache pages for) the file referred to by the file descrip‐
>        tor fd to the disk device (or other permanent storage device)  so  that
>        all  changed information can be retrieved even after the system crashed
>        or was rebooted.  This includes writing  through  or  flushing  a  disk
>        cache  if  present.   The call blocks until the device reports that the
>        transfer has completed.  It also flushes metadata  information  associ‐
>        ated with the file (see stat(2)).
>
>
> so I'm hoping that the FAQ writer was just comparing with ext3, and
> that btrfs's fsync() fully flushes all dirty blocks and metadata for a
> file or directory. (I haven't had a chance to do any testing on a
> machine with slow flushes to see yet, or any plug-pull testing).
>
>
> Also on the FAQ:
>
> https://btrfs.wiki.kernel.org/index.php/FAQ#What_are_the_crash_guarantees_of_overwrite-by-rename.3F
>
> it might be a good idea to recommend that applications really should
> fsync() the directory if they want a crash safety guarantee, and that
> doing so (hopefully?) won't flush dirty file blocks, just directory
> metadata.
>
> --
>  Craig Ringer                   http://www.2ndQuadrant.com/
>  PostgreSQL Development, 24x7 Support, Training & Services



-- 
 Craig Ringer                   http://www.2ndQuadrant.com/
 PostgreSQL Development, 24x7 Support, Training & Services
