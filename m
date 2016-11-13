Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:56597 "EHLO
        mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752903AbcKMPGl (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 13 Nov 2016 10:06:41 -0500
Date: Sun, 13 Nov 2016 07:06:30 -0800
From: Marc MERLIN <marc@merlins.org>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: David Sterba <dsterba@suse.com>, Hugo Mills <hugo@carfax.org.uk>,
        linux-btrfs@vger.kernel.org
Message-ID: <20161113150629.qiz3r6no3snrufuu@merlins.org>
References: <20161108003950.GD13371@merlins.org>
 <63a1964d-f8df-413d-c088-20163f824e3d@cn.fujitsu.com>
 <20161108010600.GE13371@merlins.org>
 <977bbf2a-5d9f-f5aa-084c-4ca1d891eb72@cn.fujitsu.com>
 <20161108152429.GC24297@merlins.org>
 <f17792e9-498a-4ff0-2cc5-674ae10a01ad@cn.fujitsu.com>
 <20161109020519.GN13371@merlins.org>
 <20161111034805.svs33jawobogpzrc@merlins.org>
 <f9757f37-ab2b-87d8-3f72-80dcc968f6e8@cn.fujitsu.com>
 <20161112031708.aylnevv657w2x3dg@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20161112031708.aylnevv657w2x3dg@merlins.org>
Subject: Re: when btrfs scrub reports errors and btrfs check --repair does not
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Nov 11, 2016 at 07:17:08PM -0800, Marc MERLIN wrote:
> On Fri, Nov 11, 2016 at 11:55:21AM +0800, Qu Wenruo wrote:
> > It seems to be orphan inodes.
> > Btrfs doesn't remove all the contents of an inode at rm time.
> > It just unlink the inode and put it into a state called orphan inodes.(Can't
> > be referred from any directory).
> 
> BTRFS warning (device dm-6): checksum error at logical 269783928832 on dev /dev/mapper/crypt_bcache2, sector 529035272, root 17564, inode 1225897, offset 20480: path resolving failed with ret=-2
> BTRFS warning (device dm-6): checksum error at logical 269783932928 on dev /dev/mapper/crypt_bcache2, sector 529035280, root 17564, inode 1225897, offset 24576: path resolving failed with ret=-2
>  
> Do you mean I should be using find /mnt/mnt -inum ?
> Well, how about that, you're right:
> gargamel:/mnt/mnt/DS2/backup# find /mnt/mnt -inum 1225897
> /mnt/mnt/DS2/backup/debian64_rw.20160713_03:21:57/gandalfthegreat/20120409/home/merlin/public_html/mirrors/rwf/vfrcharts/x9y678z6.jpg
> So basically the breakage in my filesystem is enough that the backlink
> from the inode to the pathname is gone? That's not good :-/

Mmmn, been doing find -inum, deleting hits, running scrub, and then
scrub still fails with more, and now I'm seeing this;

gargamel:~# find /mnt/mnt -inum 1225897

/mnt/mnt/DS2/backup/ubuntu_rw.20160713_03:25:42/gandalfthegrey/20100718/var/local/www/Pix/albums/Trips/200509_Malaysia/500_KapalaiIsland/BestOf/33_Diving-Dive5-2_139.jpg
/mnt/mnt/DS2/backup/debian64_ro.20160720_02:58:38/gandalfthegreat/20120409/home/merlin/public_html/mirrors/rwf/vfrcharts/x9y678z6.jpg
/mnt/mnt/DS2/backup/debian64_ro.20160720_02:58:38/gandalfthegreat/20120409/home/merlin/public_html/mirrors/rwf/vfrcharts/x9y679z6.jpg
(...)
/mnt/mnt/DS2/backup/debian64_rw.20160727_02:59:03/gandalfthegreat/20120409/home/merlin/public_html/mirrors/rwf/vfrcharts/x9y678z6.jpg
/mnt/mnt/DS2/backup/debian64_rw.20160727_02:59:03/gandalfthegreat/20120409/home/merlin/public_html/mirrors/rwf/vfrcharts/x9y679z6.jpg
/mnt/mnt/DS2/backup/debian64_rw.20160727_02:59:03/gandalfthegreat/20120409/home/merlin/public_html/mirrors/rwf/vfrcharts/x9y81z9.jpg

And then I see this:
gargamel:~# ls -li /mnt/mnt/DS2/backup/ubuntu_rw.20160713_03:25:42/gandalfthegrey/20100718/var/local/www/Pix/albums/Trips/200509_Malaysia/500_KapalaiIsland/BestOf/33_Diving-Dive5-2_139.jpg /mnt/mnt/DS2/backup/debian64_ro.20160720_02:58:38/gandalfthegreat/20120409/home/merlin/public_html/mirrors/rwf/vfrcharts/x9y678z6.jpg /mnt/mnt/DS2/backup/debian64_ro.20160720_02:58:38/gandalfthegreat/20120409/home/merlin/public_html/mirrors/rwf/vfrcharts/x9y679z6.jpg /mnt/mnt/DS2/backup/debian64_rw.20160727_02:59:03/gandalfthegreat/20120409/home/merlin/public_html/mirrors/rwf/vfrcharts/x9y678z6.jpg /mnt/mnt/DS2/backup/debian64_rw.20160727_02:59:03/gandalfthegreat/20120409/home/merlin/public_html/mirrors/rwf/vfrcharts/x9y679z6.jpg /mnt/mnt/DS2/backup/debian64_rw.20160727_02:59:03/gandalfthegreat/20120409/home/merlin/public_html/mirrors/rwf/vfrcharts/x9y81z9.jpg
1225897 -rw-r--r-- 5 merlin merlin 13794 Jan  7  2012 /mnt/mnt/DS2/backup/debian64_ro.20160720_02:58:38/gandalfthegreat/20120409/home/merlin/public_html/mirrors/rwf/vfrcharts/x9y678z6.jpg
1225898 -rw-r--r-- 5 merlin merlin 13048 Jan  7  2012 /mnt/mnt/DS2/backup/debian64_ro.20160720_02:58:38/gandalfthegreat/20120409/home/merlin/public_html/mirrors/rwf/vfrcharts/x9y679z6.jpg
1225897 -rw-r--r-- 5 merlin merlin 13794 Jan  7  2012 /mnt/mnt/DS2/backup/debian64_rw.20160727_02:59:03/gandalfthegreat/20120409/home/merlin/public_html/mirrors/rwf/vfrcharts/x9y678z6.jpg
1225898 -rw-r--r-- 5 merlin merlin 13048 Jan  7  2012 /mnt/mnt/DS2/backup/debian64_rw.20160727_02:59:03/gandalfthegreat/20120409/home/merlin/public_html/mirrors/rwf/vfrcharts/x9y679z6.jpg
1225913 -rw-r--r-- 5 merlin merlin 15247 Jan  7  2012 /mnt/mnt/DS2/backup/debian64_rw.20160727_02:59:03/gandalfthegreat/20120409/home/merlin/public_html/mirrors/rwf/vfrcharts/x9y81z9.jpg
1225897 lrwxrwxrwx 1 merlin merlin    35 Aug  1  2010 /mnt/mnt/DS2/backup/ubuntu_rw.20160713_03:25:42/gandalfthegrey/20100718/var/local/www/Pix/albums/Trips/200509_Malaysia/500_KapalaiIsland/BestOf/33_Diving-Dive5-2_139.jpg -> ../33_Diving/BestOf/Dive5-2_139.jpg

So first:
a) find -inum returns some inodes that don't match
b) but argh, multiple files (very different) have the same inode number, so finding
files by inode number after scrub flagged an inode bad, isn't going to work :(

At this point, I'm starting to lose patience (and running out of time),
so I'm going to wipe this filesystem after I hear back from you, but
basically scrub and repair and still not up to what they should be IMO
(as per my previous comment):
One should be able to fully repair an unclean filesystem with check --repair, and scrub should
give me things I can either fix by hand (delete the corrupt file) or
that check --repair would fix, and neither is true here.

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
