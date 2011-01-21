From: "Ian! D. Allen" <idallen@idallen.ca>
Subject: latest btrfs hangs when creating/deleting snapshots
Date: Fri, 21 Jan 2011 09:50:42 -0500
Message-ID: <20110121145042.GE22519@idallen.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I can make the latest btrfs from Chris hang my system.
I got a fresh clone yesterday from:

git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-progs-unstable.git
git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-unstagle.git

Built and installed both tools and kernel into Ubuntu 10.10 running in vmware.
Ran a script that looped:

 LOOP:
   if more than 10,000 snaps, delete the oldest
   create a new snap from the previous one
   modify a 20MB file on the snap, appending one line
 goto LOOP

The disk system hung at snap 21,959.  Programs that were running continued
to display updates on the screen (e.g. gkrellm), but anything that
tried to access the disk hung.  I could switch to a text console, but I
couldn't log in - the login hung.  Ping to the virtual machine worked;
an ssh login hung.  I couldn't run "ps" to see if the hang was in the
same place as before (see original message at bottom).  I had to reset.

Upon reboot this is what df showed for the btrfs partition:

Filesystem           1K-blocks      Used Available Use% Mounted on
/dev/sdb1              2096128    452460   1336228  26% /mnt/sdb1

My script output log file only showed up to snap 22,954.
The last things in the script output log file were:

Thu Jan 20 22:41:07 EST 2011 snapshot /mnt/sdb1/snap022952 /mnt/sdb1/snap022953
Create a snapshot of '/mnt/sdb1/snap022952' in '/mnt/sdb1/snap022953'

Filesystem           1K-blocks      Used Available Use% Mounted on
/dev/sdb1              2096128    453000   1336192  26% /mnt/sdb1

Filesystem            Size  Used Avail Use% Mounted on
/dev/sdb1             2.0G  443M  1.3G  26% /mnt/sdb1

Data: total=212.69MB, used=100.25MB
System, DUP: total=8.00MB, used=4.00KB
System: total=4.00MB, used=0.00
Metadata, DUP: total=306.94MB, used=171.06MB
Metadata: total=8.00MB, used=0.00

Delete subvolume '/mnt/sdb1/snap012954'
0.00user 0.00system 0:00.10elapsed 0%CPU (0avgtext+0avgdata 2256maxresident)k
0inputs+480outputs (0major+189minor)pagefaults 0swaps

Filesystem           1K-blocks      Used Available Use% Mounted on
/dev/sdb1              2096128    453592   1336200  26% /mnt/sdb1

Filesystem            Size  Used Avail Use% Mounted on
/dev/sdb1             2.0G  443M  1.3G  26% /mnt/sdb1

Data: total=212.69MB, used=100.24MB
System, DUP: total=8.00MB, used=4.00KB
System: total=4.00MB, used=0.00
Metadata, DUP: total=306.94MB, used=171.36MB
Metadata: total=8.00MB, used=0.00

Thu Jan 20 22:41:08 EST 2011 snapshot /mnt/sdb1/snap022953 /mnt/sdb1/snap022954
Create a snapshot of '/mnt/sdb1/snap022953' in '/mnt/sdb1/snap022954'
[EOF]

I'll run the script again today and see what happens.


On Fri, Dec 17, 2010 at 09:52:10AM -0500, Chris Mason wrote:
> Excerpts from Ian! D. Allen's message of 2010-12-16 23:45:12 -0500:
> > On Thu, Dec 16, 2010 at 08:47:05PM -0500, Chris Mason wrote:
> > > I think this hang is something that sage fixed.  Which kernel is this
> > > ubuntu including?
> > 
> > All that detail is posted in the second message in the thread you quoted:
> > 
> > http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg07448.html
> 
> The 2.6.35 kernel didn't have Sage's fix.  I'd say the deadlock will be
> fixed in the current btrfs-unstable git tree (against 2.6.36).
> 
> > 
> > Is the btrfsck snapshot error (from Tuesday) fixed too?
> 
> I'm looking into that one, I think it is a btrfsck bug.

-- 
| Ian! D. Allen  -  idallen@idallen.ca  -  Ottawa, Ontario, Canada
| Home Page: http://idallen.com/   Contact Improv: http://contactimprov.ca/
| College professor (Free/Libre GNU+Linux) at: http://teaching.idallen.com/
| Defend digital freedom:  http://eff.org/  and have fun:  http://fools.ca/
