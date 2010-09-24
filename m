From: Goffredo Baroncelli <kreijack@gmail.com>
Subject: Re: cannot resize (grow) fs
Date: Fri, 24 Sep 2010 19:08:50 +0200
Message-ID: <201009241908.50351.kreijack@libero.it>
References: <i7hdlm$13j$1@dough.gmane.org> <AANLkTiksuBxGMGuzgpx4eFeajhDRoGxwoodCdhCPr4q2@mail.gmail.com> <i7hlne$13j$2@dough.gmane.org>
Reply-To: kreijack@libero.it
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <i7hlne$13j$2@dough.gmane.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Friday, 24 September, 2010, Lubos Kolouch wrote:
> Sebastian 'gonX' Jensen, Fri, 24 Sep 2010 09:37:02 +0200:
> 
> > On 24 September 2010 07:41, Lubos Kolouch <lubos.kolouch@gmail.com>
> > wrote:
> >> Hello,
> >>
> >> I added disk to raid5 array on one of the backup hosts, running btrfs.
> >>
> >> So on /dev/md2 I have plenty of space now.
> >>
> >> However when I run
> >>
> >> btrfs filesystem resize max  /dev/md2
> >>
> >> I get
> >>
> >> Resize '/dev/md2' of 'max'
> >> ERROR: unable to resize '/dev/md2'
> >>
> >> The same result when I try resize +1g.
> >>
> >> strace gives me http://paste.pocoo.org/show/266523/
> >>
> >> Any ideas why and how can I extend the filesystem to fill the whole
> >> volume?
> >>
> >> Thank you
> >>
> >> Lubos
> >>
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-btrfs"
> >> in the body of a message to majordomo@vger.kernel.org More majordomo
> >> info at  http://vger.kernel.org/majordomo-info.html
> >>
> >>
> > Hi Lubos,
> > 
> > Firstly if I understood the documentation right, you have to specify the
> > mount point rather than the drive itself. Secondly, I posted about this
> > issue a while ago. It seems that it will only extend the filesystem on
> > the hard drive that has devid 1. If you do not have any drives with
> > devid 1 (e.g because you removed it), you can't resize your drive.
> > 
> > I hope this is something that the btrfs developers will look into ASAP,
> > because as it is now, resizing the FS on RAID arrays is impossible.
> > 
> > Regards,
> > Sebastian J.
> 
> Hi Sebastian
> 
> Thank you - unfortunately when I specify the mount point, the result is 
> the same.
> 
> The drive has devid 3, I was (forced by failure) playing with the drives
> quite a lot.
> 
> Seems like I am hitting all the nice issues with btrfs :)
> 
> Lubos
> 
> Lubos

Try

# btrfs filesystem resize <devid>:max

where <devid> is the devid to be resized as show by the command btrfs 
filesystem show.

In my test machine the device which was grows was /dev/ubdf (devid == 4):

$ sudo bin/btrfs filesystem show
Label: none  uuid: 4b241855-8d98-4fa9-a548-e502786a96fe
        Total devices 3 FS bytes used 28.00KB
        devid    3 size 600.00MB used 167.00MB path /dev/ubde
        devid    2 size 600.00MB used 167.00MB path /dev/ubdd
        devid    4 size 700.00MB used 64.00MB path /dev/ubdf

$ cat /proc/partitions 
major minor  #blocks  name
[..]
  98       48     614400 ubdd
  98       64     614400 ubde
  98       80     819200 ubdf

$ sudo bin/btrfs files res 4:max /mnt/test/
Resize '/mnt/test/' of '4:max'

$ sudo bin/btrfs filesystem show
Label: none  uuid: 4b241855-8d98-4fa9-a548-e502786a96fe
        Total devices 3 FS bytes used 28.00KB
        devid    3 size 600.00MB used 167.00MB path /dev/ubde
        devid    2 size 600.00MB used 167.00MB path /dev/ubdd
        devid    4 size 800.00MB used 64.00MB path /dev/ubdf


BTW there is a bug: if no <devid> is passed, the kernel has to grow the first 
available devid and not the devid==1.

regards
G.Baroncelli


> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


-- 
gpg key@ keyserver.linux.it: Goffredo Baroncelli (ghigo) <kreijack@inwind.it>
Key fingerprint = 4769 7E51 5293 D36C 814E  C054 BF04 F161 3DC5 0512
