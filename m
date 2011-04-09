From: Calvin Walton <calvin.walton@kepstin.ca>
Subject: Re: wrong values in "df" and "btrfs filesystem df"
Date: Sat, 09 Apr 2011 13:26:38 -0400
Message-ID: <1302370000.23240.10.camel@nayuki>
References: <BjX0k26y1uB@helmut.hullen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: linux-btrfs@vger.kernel.org
To: helmut@hullen.de
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <BjX0k26y1uB@helmut.hullen.de>
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, 2011-04-09 at 19:05 +0200, Helmut Hullen wrote:
> >>> Then I work on it, copy some new files, delete some old files - all
> >>> works well. Only
> >>>
> >>>   df /srv/MM
> >>>   btrfs filesystem df /srv/MM
> >>>
> >>> show some completely wrong values:

> > And I just drew up a picture which I think should help explain it a
> > bit, too: http://www.kepstin.ca/dump/btrfs-alloc.png
> 
> Nice picture. But it doesn't solve the problem that I need a reliable  
> information about the free/available space. And I prefer asking with  
> "df" for this information - "df" should work in the same way for all  
> filesystems.

The problem is that the answer to the seemingly simple question: "How
much more data can I put onto this filesystem?" gets pretty hard with
btrfs.

Your case is one of the simpler ones - To calculate the remaining space
for files, you take the unused allocated data space (light blue on my
picture), add the unallocated space (white), divide by the raid mode
redundancy, and subtract some percentage (this is only an estimate, of
course...) of that unallocated space for the additional metadata
overhead.

Now imagine the case where your btrfs filesystem has files stored in
multiple raid modes: e.g. some files are raid5, others raid0.
The amount of data you can write to the filesystem then depends on how
you write the data!

You might be able to fit 64gb if you use raid0, but only 48gb with
raid5; and only 16gb with raid1!

There isn't a single number that btrfs can report which does what you
want.

-- 
Calvin Walton <calvin.walton@kepstin.ca>

