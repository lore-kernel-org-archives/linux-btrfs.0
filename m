From: Chris Mason <chris.mason@oracle.com>
Subject: Re: New btrfsck status
Date: Thu, 10 Feb 2011 07:17:10 -0500
Message-ID: <1297340143-sup-3602@think>
References: <AANLkTinu_29idVYvudG=E6VaxwqQoN2YEi57-RPk3dkF@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Ben Gamari <bgamari@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <AANLkTinu_29idVYvudG=E6VaxwqQoN2YEi57-RPk3dkF@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from Ben Gamari's message of 2011-02-09 21:52:20 -0500:
> Hey all,
> 
> Over the last several months there have been many claims regarding the
> release of the rewritten btrfsck. Unfortunately, despite numerous
> claims that it will be released Real Soon Now(c), I have yet to see
> even a repository with preliminary code. Did I miss an announcement?
> There is something to be said for "release early, release often." Is
> there a timeline for getting btrfsck into some sort of usable form?

Yes, but its still real soon now.  I've been at about 90% done since
Christmas.  It would have been out last week but I've been chasing a
debugging a very difficult corruption under load.

I finally found a race in btrfs causing the corruption and now I'm back
on fsck full time again.

-chris
