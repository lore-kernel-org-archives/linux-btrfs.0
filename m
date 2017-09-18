Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tartarus.angband.pl ([89.206.35.136]:33570 "EHLO
        tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753006AbdIRLxz (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 18 Sep 2017 07:53:55 -0400
Date: Mon, 18 Sep 2017 13:53:52 +0200
From: Adam Borowski <kilobyte@angband.pl>
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: Marat Khalili <mkh@rqc.ru>, linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: qemu-kvm VM died during partial raid1 problems of btrfs
Message-ID: <20170918115352.3wyezrda4g352r4d@angband.pl>
References: <20170912111159.jcwej7s6uluz4dsz@angband.pl>
 <2679f652-2fee-b1ee-dcce-8b77b02f9b01@rqc.ru>
 <20170912172125.rb6gtqdxqneb36js@angband.pl>
 <d1f6450c-fc09-171c-82c8-32caa2cbd230@gmail.com>
 <20170912184359.hovirdaj55isvwwg@angband.pl>
 <7019ace9-723e-0220-6136-473ac3574b55@gmail.com>
 <20170912200057.3mrgtahlvszkg334@angband.pl>
 <e169336d-db31-276f-1d71-bf897cf10d4b@gmail.com>
 <20170912211346.uxzqfu7uh2ikrg2m@angband.pl>
 <8d74d2c2-0f65-77c9-124c-4bcc071a2b2e@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <8d74d2c2-0f65-77c9-124c-4bcc071a2b2e@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Sep 13, 2017 at 08:21:01AM -0400, Austin S. Hemmelgarn wrote:
> On 2017-09-12 17:13, Adam Borowski wrote:
> > On Tue, Sep 12, 2017 at 04:12:32PM -0400, Austin S. Hemmelgarn wrote:
> > > On 2017-09-12 16:00, Adam Borowski wrote:
> > > > Noted.  Both Marat's and my use cases, though, involve VMs that are off most
> > > > of the time, and at least for me, turned on only to test something.
> > > > Touching mtime makes rsync run again, and it's freaking _slow_: worse than
> > > > 40 minutes for a 40GB VM (source:SSD target:deduped HDD).
> > > 40 minutes for 40GB is insanely slow (that's just short of 18 MB/s) if
> > > you're going direct to a hard drive.  I get better performance than that on
> > > my somewhat pathetic NUC based storage cluster (I get roughly 20 MB/s there,
> > > but it's for archival storage so I don't really care).  I'm actually curious
> > > what the exact rsync command you are using is (you can obviously redact
> > > paths as you see fit), as the only way I can think of that it should be that
> > > slow is if you're using both --checksum (but if you're using this, you can
> > > tell rsync to skip the mtime check, and that issue goes away) and --inplace,
> > > _and_ your HDD is slow to begin with.
> >
> > rsync -axX --delete --inplace --numeric-ids /mnt/btr1/qemu/ mordor:$BASE/qemu
> > The target is single, compress=zlib SAMSUNG HD204UI, 34976 hours old but
> > with nothing notable on SMART, in a Qnap 253a, kernel 4.9.
> compress=zlib is probably your biggest culprit.  As odd as this sounds, I'd
> suggest switching that to lzo (seriously, the performance difference is
> ludicrous), and then setting up a cron job (or systemd timer) to run defrag
> over things to switch to zlib.  As a general point of comparison, we do
> archival backups to a file server running BTRFS where I work, and the
> archiving process runs about four to ten times faster if we take this
> approach (LZO for initial compression, then recompress using defrag once the
> initial transfer is done) than just using zlib directly.

Turns out that lzo is actually the slowest, but only by a bit.

I tried a different disk, in the same Qnap; also an old disk but 7200 rpm
rather than 5400.  Mostly empty, only a handful subvolumes, not much
reflinking.  I made three separate copies, fallocated -d, upgraded Windows
inside the VM, then:

[/mnt/btr1/qemu]$ for x in none lzo zlib;do time rsync -axX --delete --inplace --numeric-ids win10.img mordor:/SOME/DIR/$x/win10.img;done

real    31m37.459s
user    27m21.587s
sys     2m16.210s

real    33m28.258s
user    27m19.745s
sys     2m17.642s

real    32m57.058s
user    27m24.297s
sys     2m17.640s

Note the "user" values.  So rsync does something bad on the source side.

Despite fragmentation, reads on the source are not a problem:

[/mnt/btr1/qemu]$ time cat <win10.img >/dev/null

real	1m28.815s
user	0m0.061s
sys	0m48.094s
[/mnt/btr1/qemu]$ /usr/sbin/filefrag win10.img 
win10.img: 63682 extents found
[/mnt/btr1/qemu]$ btrfs fi def win10.img
[/mnt/btr1/qemu]$ /usr/sbin/filefrag win10.img 
win10.img: 18015 extents found
[/mnt/btr1/qemu]$ time cat <win10.img >/dev/null

real	1m17.879s
user	0m0.076s
sys	0m37.757s

> `--inplace` is probably not helping (especially if most of the file changed,
> on BTRFS, it actually is marginally more efficient to just write out a whole
> new file and then replace the old one with a rename if you're rewriting most
> of the file), but is probably not as much of an issue as compress=zlib.

Yeah, scp + dedupe would run faster.  For deduplication, instead of
duperemove it'd be better to call file_extent_same on the first 128K, then
the second, ... -- without even hashing the blocks beforehand.

Not that this particular VM takes enough backup space to make spending too
much time worthwhile, but it's a good test case for performance issues like
this.


Meow!
-- 
⢀⣴⠾⠻⢶⣦⠀ I've read an article about how lively happy music boosts
⣾⠁⢰⠒⠀⣿⡁ productivity.  You can read it, too, you just need the
⢿⡄⠘⠷⠚⠋⠀ right music while doing so.  I recommend Skepticism
⠈⠳⣄⠀⠀⠀⠀ (funeral doom metal).
