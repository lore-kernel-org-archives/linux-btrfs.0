Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from know-smtprelay-omc-6.server.virginmedia.net ([80.0.253.70]:37512
	"EHLO know-smtprelay-omc-6.server.virginmedia.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752964AbcCNXD6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 14 Mar 2016 19:03:58 -0400
Received: from phoenix.vfire (localhost [127.0.0.1])
	by phoenix.vfire (8.14.9/8.14.5) with ESMTP id u2EN3qW3011696
	for <linux-btrfs@vger.kernel.org>; Mon, 14 Mar 2016 23:03:52 GMT
Received: (from pete@localhost)
	by phoenix.vfire (8.14.9/8.14.5/Submit) id u2EN3qo3011695
	for linux-btrfs@vger.kernel.org; Mon, 14 Mar 2016 23:03:52 GMT
Date: Mon, 14 Mar 2016 23:03:52 GMT
Message-Id: <201603142303.u2EN3qo3011695@phoenix.vfire>
From: pete@petezilla.co.uk
To: linux-btrfs@vger.kernel.org
Subject: Re: Snapshots slowing system
In-Reply-To: pan$b315b$51883804$dab51362$72285105@cox.net
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

>pete posted on Sat, 12 Mar 2016 13:01:17 +0000 as excerpted:

>> I hope this message stays within the thread on the list.  I had email
>> problems and ended up hacking around with sendmail & grabbing the
>> message id off of the web based group archives.

>Looks like it should have as the reply-to looks right, but at least on 
>gmane's news/nntp archive of the list (which is how I read and reply), it 
>didn't.  But the thread was found easily enough.

Found out what had happened.  I think I had a quota full issue at my hosting
provider, I suspect bounce messages caused majordomo to unsubscribe me, the
very week I asked a quesiton.

Thanks for the huge response, and thanks also to Boris.

>>>>I wondered whether you had elimated fragmentation, or any other known
>>>>gotchas, as a cause?
>> 
>> Subvolumes are mounted with the following options:
>> autodefrag,relatime,compress=lzo,subvol=<sub vol name>>

>That relatime (which is the default), could be an issue.  See below.

I've now changed that to noatime.  I think I read or missread relatime as
a good comprimise sometime in the past.


>> Not sure if there is much else to do about fragmentation apart from
>> running a balance which would probally make thje machine v sluggish for
>> a day or so.
>> 
>>>>Out of curiosity, what is/was the utilisation of the disk? Were the
>>>>snapshots read-only or read-write?
>> 
>> root@phoenix:~# btrfs fi df /
>> Data, single: total=101.03GiB, used=97.91GiB
>> System, single: total=32.00MiB, used=16.00KiB
>> Metadata, single: total=8.00GiB, used=5.29GiB
>> GlobalReserve, single: total=512.00MiB, used=0.00B
>> 
>> root@phoenix:~# btrfs fi df /home
>> Data, RAID1: total=1.99TiB, used=1.97TiB
>> System, RAID1: total=32.00MiB, used=352.00KiB
>> Metadata, RAID1: total=53.00GiB, used=50.22GiB
>> GlobalReserve, single: total=512.00MiB, used=0.00B

>Normally when posting, either btrfs fi df *and* btrfs fi show are 
>needed, /or/ (with a new enough btrfs-progs) btrfs fi usage.  And of 
>course the kernel (4.0.4 in your case) and btrfs-progs (not posted, that 
>I saw) versions.

OK, I have usage.  For the SSD with the system:

root@phoenix:~# btrfs fi usage /
Overall:
    Device size:		 118.05GiB
    Device allocated:		 110.06GiB
    Device unallocated:		   7.99GiB
    Used:			 103.46GiB
    Free (estimated):		  11.85GiB	(min: 11.85GiB)
    Data ratio:			      1.00
    Metadata ratio:		      1.00
    Global reserve:		 512.00MiB	(used: 0.00B)

Data,single: Size:102.03GiB, Used:98.16GiB
   /dev/sda3	 102.03GiB

Metadata,single: Size:8.00GiB, Used:5.30GiB
   /dev/sda3	   8.00GiB

System,single: Size:32.00MiB, Used:16.00KiB
   /dev/sda3	  32.00MiB

Unallocated:
   /dev/sda3	   7.99GiB


Hmm.  A bit tight.  I've just ordered a replacement SSD. Slackware
should it in about 5GB+ of disk space I've seen on a website?  Hmm.  Don't
beleive that.  I'd allow at least 10GB and more if I want to add extra 
packages such as libreoffice.  If I have no snapshots it seems to get to
45GB with various extra packages installed and grows to 100ish with
snapshotting probally owing to updates.

Anyway, took the lazy, but less tearing less hair out route and ordered
a 500GB drive.  Prices have dropped and fortunately a new drive is not
a major issue.  Timing is also good with Slack 14.2 immanent. You
rarely hear people complaining about disk too empty problems...
   
   
For the traditional hard drives with the data:

root@phoenix:~# btrfs fi usage /home
Overall:
    Device size:		   5.46TiB
    Device allocated:		   4.09TiB
    Device unallocated:		   1.37TiB
    Used:			   4.04TiB
    Free (estimated):		 720.58GiB	(min: 720.58GiB)
    Data ratio:			      2.00
    Metadata ratio:		      2.00
    Global reserve:		 512.00MiB	(used: 0.00B)

Data,RAID1: Size:1.99TiB, Used:1.97TiB
   /dev/sdb	   1.99TiB
   /dev/sdc	   1.99TiB

Metadata,RAID1: Size:53.00GiB, Used:49.65GiB
   /dev/sdb	  53.00GiB
   /dev/sdc	  53.00GiB

System,RAID1: Size:32.00MiB, Used:352.00KiB
   /dev/sdb	  32.00MiB
   /dev/sdc	  32.00MiB

Unallocated:
   /dev/sdb	 699.49GiB
   /dev/sdc	 699.49GiB
root@phoenix:~# 

   

>> Hmm.  The system disk is getting a little tight. cddisk reports the
>> partition I use for btrfs containing root as 127GB approx.  Not sure why
>> it grows so much. Suspect that software updates can't help as snapshots
>> will contain the legacy versions.  On the other hand they can be useful.

>With the 127 GiB (I _guess_ it's GiB, 1024, not GB, 1000, multiplier, 
>btrfs consistently uses the 1024 multiplier and properly specifies it 
>using the XiB notation) for /, however, and the btrfs fi df sizes of 101 
>GiB plus data and 8 GiB metadata (with system's 32 MiB a rounding error 
>and global reserve actually taken from metadata, so it doesn't add to 
>chunk reservation on its own) we can see that as you mention, it's 
>starting to get tight, a bit under 110 GiB of 127 GiB, but that 17 GiB 
>free isn't horrible, just slightly tight, as you said.

>Tho it'll obviously be tighter if that's 127 GB, 1000 multiplier...

Note that the system btrfs does not get 127GB, it gets /dev/sda3, not
far off, but I've a 209MB partition for /boot and a 1G partition for a 
very cut down system for maintenance purposes (both ext4).  On the 
new drive I'll keep the 'maintenance' ext4 install but I could use 
/boot from that filesystem using bind mounts, a bit cleaner.



>It's tight enough that particularly with the regular snapshotting, btrfs 
>might be having to fragment more than it'd like.  Tho kudos for the 
>_excellent_ snapshot rotation.  We regularly see folks in here with 100K 
>or more snapshots per filesystem, and btrfs _does_ have scaling issues in 
>that case.  But your rotation seems to be keeping it well below the 1-3K 
>snapshots per filesystem recommended max, so that's obviously NOT you're 
>problem, unless of course the snapshot deletion bugged out and they 
>aren't being deleted as they should.

Yay, I've done it right at least somewhere...  I was assuming that was
on server hardware so I thought best to keep it tighter on my more 
modest desktop.

They are deleting.  The new ones are also read only now.


>(Of course, you can check that by listing them, and I would indeed double-
>check, as that _is_ the _usual_ problem we have with snapshots slowing 
>things down, simply too many of them, hitting the known scaling issues 
>btrfs had with over 10K snapshots per filesystem.  But FWIW I don't use 
>snapshots here and thus don't deal with snapshots command-level detail.)

Rarely use them except when I either delete the wrong file or do something
very sneaky but dumb like inavertently set umask for root and install
a package and break _lots_ of file system permissions.  Easiest to 
recover from a good snapshot than try to fix that mess...



>But as I mentioned above, that relatime mount option isn't your best 
>choice, in the presence of heavy snapshotting.  Unless you KNOW you need 
>atimes for something or other, noatime is _strongly_ recommended with 
>snapshotting, because relatime, while /relatively/ better than 
>strictatime, still updates atimes once a day for files you're accessing 
>at least that frequently.

Now noatime.


>And that interacts badly with snapshots, particularly where few of the 
>files themselves have changed, because in that case, a large share of the 
>changes from one snapshot to another are going to be those atime updates 
>themselves.  Ensuring that you're always using noatime avoids the atime 
>updates entirely (well, unless the file itself changes and thus mtime 
>changes as well), which should, in the normal most files unchanged 
>snapshotting context, make for much smaller snapshot-exclusive sizes.

>And you mention below that the snapshots are read-write, but generally 
>used as read-only.  Does that include actually mounting them read-only?  
>Because if not, and if they too are mounted the default relatime, 
>accessing them is obviously going to be updating atimes the relatime-
>default once per day there as well... triggering further divergence of 
>snapshots from the subvolumes they are snapshots of and from each other...

Actually they are normally not mounted.  Only mount them, or rather the 
default subvolume that contains them, on an as needed basis.  The script
that does the snapshotting mounts and then unmounts.


>> Is it likely the SSD?  If likely I could get a larger one, now is a good
>> time with a new version of slackware imminent.  However, no point in
>> spending money for the sake of it.

>Not directly btrfs related, but when you do buy a new ssd, now or later, 
>keep in mind that a lot of authorities recommend that for ssds you buy 
>10-33% larger than you plan on actually provisioning, and that you leave 
>that extra space entirely unprovisioned -- either leave that extra space 
>entirely unpartitioned, or partition it, but don't put filesystems or 
>anything else (swap, etc) on it.  This leaves those erase-blocks free to 
>be used by the FTL for additional wear-leveling block-swap, thus helping 
>maintain device speed as it ages, and with good wear-leveling firmware, 
>should dramatically increase device usable lifetime, as well.

Well, went OTT so got ordered a 500GB.  So if I put say 20GB as my 
'maintenance' partition, then the rest minus 100-150GB as btrfs and keep
the rest unallocated that should work well?


>FWIW, I ended up going rather overboard with that here, as I knew I 
<snip>

So have I.  The price seems almost linear per gigabyte perhaps?  
Suspected it was better to go larger if I could and delay the 
time until the new disk runs out.  Could put the old disk in the
laptop for experimentation with distros.


>>>>Apropos Nada: quick shout out to Qu to wish him luck for the 4.6 merge.
>> 
>> I'm wondering if it is time for an update from 4.0.4?

>The going list recommendation is to choose either current kernel track or 
>LTS kernel track.  If you choose current kernel, the recommendation is to 
>stick within 1-2 kernel cycles of newest current, which with 4.5 about to 
>come out, means you would be on 4.3 at the oldest, and be looking at 4.4 
>by now, again, on the current kernel track.

4.5 is out.  Maybe I ought to await 4.5.1 or .2 for any initial bugs to 
shake out.


>If you choose LTS kernels, until recently, the recommendation was again 
>the latest two, but here LTS kernel cycles.  That would be 4.4 as the 
>newest LTS and 4.1 previous to that.  However, 3.18, the LTS kernel 
>previous to 4.1, has been holding up reasonably well, so while 4.1 would 
>be preferred, 3.18 remains reasonably well supported as well.

Can't see the advantage to me for a LTS kernel.  In the past I've gone
for the latest and then updated the kernel with the new latest kernel.  
Distro maintainers might want LTS kernels but I'm not going to go from
say 4.1.10 to 4.1.19 when I can go to 4.5.

OK googled for a bit.  Upgrading within an LTS branch fixes bugs but 
reduces chances of breakage due to new functionality.


>You're on 4.0, which isn't an LTS kernel series and is thus, along with 
>4.2, out of upstream's support window.  So it's past time to look at 
>updating. =:^)  Given that you obviously do _not_ follow the last couple 

Whilst everything worked fine and there were no security horrors there was
no need to update.

Kind regards,

Pete
