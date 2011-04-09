From: Calvin Walton <calvin.walton@kepstin.ca>
Subject: Re: wrong values in "df" and "btrfs filesystem df"
Date: Sat, 09 Apr 2011 12:36:34 -0400
Message-ID: <1302366997.19697.3.camel@nayuki>
References: <BjW+GU4y1uB@helmut.hullen.de>
	 <20110409091141.GE5301@carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: helmut@hullen.de, linux-btrfs@vger.kernel.org
To: Hugo Mills <hugo-lkml@carfax.org.uk>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110409091141.GE5301@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, 2011-04-09 at 10:11 +0100, Hugo Mills wrote:
> On Sat, Apr 09, 2011 at 08:25:00AM +0200, Helmut Hullen wrote:
> > Hallo, linux-btrfs,
> > 
> > First I create an array of 2 disks with
> > 
> >   mkfs.btrfs -d raid0 -m raid1 /dev/sdb1 /dev/sdd1
> > 
> > and mount it at /srv/MM.
> > 
> > Then I fill it with about 1,6 TByte.
> > And then I add /dev/sde1 via
> > 
> >   btrfs device add /dev/sde1 /srv/MM
> >   btrfs filesystem balance /srv/MM
> >     (it run about 20 hours)
> > 
> > Then I work on it, copy some new files, delete some old files - all  
> > works well. Only
> > 
> >   df /srv/MM
> >   btrfs filesystem df /srv/MM
> > 
> > show some completely wrong values:

>    It's not wrong -- it simply doesn't mean what you think it does. :)
> 
>    The total value in the output of "btrfs fi df" is the total space
> allocated to block groups. As the filesystem needs more space, it
> will allocate more block groups from the available raw storage pool,
> and the number will go up.
> 
>    This is explained on the wiki at [1].

And I just drew up a picture which I think should help explain it a bit,
too: http://www.kepstin.ca/dump/btrfs-alloc.png

If I can figure out how to add images to the btrfs wiki, and find a good
place to put it, do you think this would be a helpful addition?

> [1] https://btrfs.wiki.kernel.org/index.php/FAQ#Why_does_df_show_incorrect_free_space_for_my_RAID_volume.3F

-- 
Calvin Walton <calvin.walton@kepstin.ca>

