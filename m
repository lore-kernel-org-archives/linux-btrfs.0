Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:48644 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751448AbaCYQly (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Mar 2014 12:41:54 -0400
Date: Tue, 25 Mar 2014 09:41:42 -0700
From: Marc MERLIN <marc@merlins.org>
To: Martin <m_btrfs@ml1.co.uk>, Xavier Nicollet <nicollet@jeru.org>
Cc: linux-btrfs@vger.kernel.org
Message-ID: <20140325164142.GN12833@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <20140325135756.GA14382@jeru.org>
 <lgrrtf$el3$1@ger.gmane.org>
Subject: Re: How to debug very very slow file delete? (btrfs on md-raid5)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 25, 2014 at 12:13:50PM +0000, Martin wrote:
> On 25/03/14 01:49, Marc MERLIN wrote:
> > I had a tree with some amount of thousand files (less than 1 million)
> > on top of md raid5.
> > 
> > It took 18H to rm it in 3 tries:

I ran another test after typing the original Email:
gargamel:/mnt/dshelf2/backup/polgara# time du -sh 20140312-feisty/; time find 20140 312-feisty/ | wc -l
17G     20140312-feisty/
real    245m19.491s
user    0m2.108s
sys     1m0.508s

728507 <- number of files
real    11m41.853s <- 11mn to restat them when they should all be in cache ideally
user    0m1.040s
sys     0m4.360s

4 hours to stat 700K files. That's bad...
Even 11mn to restat them just to count them looks bad too.

> > I checked that btrfs scrub is not running.
> > What else can I check from here?
> 
> "noatime" set?

I have relatime
gargamel:/mnt/dshelf2/backup/polgara# df .
Filesystem           1K-blocks       Used  Available Use% Mounted on
/dev/mapper/dshelf2 7814041600 3026472436 4760588292  39% /mnt/dshelf2/backup

gargamel:/mnt/dshelf2/backup/polgara# grep /mnt/dshelf2/backup /proc/mounts
/dev/mapper/dshelf2 /mnt/dshelf2/backup btrfs rw,relatime,compress=lzo,space_cache 0 0
 
> What's your cpu hardware wait time?
 
Sorry, not sure how to get that.
 
> And is not *the 512kByte raid chunk* going to give you horrendous write
> amplification?! For example, rm updates a few bytes in one 4kByte
> metadata block and the system has to then do a read-modify-write on
> 512kBytes...

That's probably not great, but
1) rm -rf should bunch a lot of writes together before they start
hitting the block layer for writes, so I'm not sure that is too much a
problem with the caching layer in between

2) this does not explain 4H to just run du with relatime, which
shouldn't generate any writing, correct?
iostat seems to confirm:

gargamel:~# iostat /dev/md8 1 20
Linux 3.14.0-rc5-amd64-i915-preempt-20140216c (gargamel.svh.merlins.org)        03/25/2014      _x86_64_        (4 CPU)
avg-cpu:  %user   %nice %system %iowait  %steal   %idle  
          75.19    0.00   10.13    8.61    0.00    6.08
Device:            tps    kB_read/s    kB_wrtn/s    kB_read    kB_wrtn
md8              98.00       392.00         0.00        392          0
md8              96.00       384.00         0.00        384          0
md8              83.00       332.00         0.00        332          0
md8             153.00       612.00         0.00        612          0
md8              82.00       328.00         0.00        328          0
md8              55.00       220.00         0.00        220          0
md8              69.00       276.00         0.00        276          0

> Also, the 64MByte chunk bit-intent map will add a lot of head seeks to
> anything you do on that raid. (The map would be better on a separate SSD
> or other separate drive.)

That's true for writing, but not reading, right?
 
> So... That sort of setup is fine for archived data that is effectively
> read-only. You'll see poor performance for small writes/changes.

So I agree with you that the write case can be improved, especially since I also have a layer
of dmcrypt in the middle
gargamel:/mnt/dshelf2/backup/polgara# cryptsetup luksDump /dev/md8
LUKS header information for /dev/md8
Cipher name:    aes
Cipher mode:    xts-plain64
Hash spec:      sha1
Payload offset: 8192

(I used cryptsetup luksFormat --align-payload=8192 -s 256 -c aes-xts-plain64)

I'm still not convinced that a lot of file IO don't get all collated in memory 
before hitting disk in bigger blocks, but maybe not.

If I were to recreate this array entirely, what would you use for the raid creation
and cryptsetup?

More generally, before I go through all that trouble (it will likely
take 1 week of data copying back and forth), I'd like to debug why my reads are
so slow first.

Thanks,
Marc

On Tue, Mar 25, 2014 at 02:57:57PM +0100, Xavier Nicollet wrote:
> Le 25 mars 2014 à 12:13, Martin a écrit:
> > On 25/03/14 01:49, Marc MERLIN wrote:
> > > It took 18H to rm it in 3 tries:
> 
> > And is not *the 512kByte raid chunk* going to give you horrendous write
> > amplification?! For example, rm updates a few bytes in one 4kByte
> > metadata block and the system has to then do a read-modify-write on
> > 512kBytes...
> 
> My question would be naive, but would it be possible to have a syscall or something to do 
> a fast "rm -rf" or du ?

Well, that wouldn't hurt either, even if it wouldn't address my underlying problem.

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
