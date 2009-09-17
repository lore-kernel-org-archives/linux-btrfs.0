From: Markus Trippelsdorf <markus@trippelsdorf.de>
Subject: Re: btrfs csum failed on git .pack file
Date: Thu, 17 Sep 2009 15:58:47 +0200
Message-ID: <20090917135847.GA1888@phenom2.trippelsdorf.de>
References: <20090907203531.GA1889@phenom2.trippelsdorf.de>
 <20090908200041.GF18599@kernel.dk>
 <20090917050512.GB1916@phenom2.trippelsdorf.de>
 <20090917064456.GZ23126@kernel.dk>
 <20090917090428.GA1877@phenom2.trippelsdorf.de>
 <20090917090549.GE23126@kernel.dk>
 <20090917121501.GB1877@phenom2.trippelsdorf.de>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="9amGYk9869ThD9tj"
Cc: linux-btrfs@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090917121501.GB1877@phenom2.trippelsdorf.de>
List-ID: <linux-btrfs.vger.kernel.org>


--9amGYk9869ThD9tj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Sep 17, 2009 at 02:15:01PM +0200, Markus Trippelsdorf wrote:
> On Thu, Sep 17, 2009 at 11:05:49AM +0200, Jens Axboe wrote:
> > On Thu, Sep 17 2009, Markus Trippelsdorf wrote:
> > > On Thu, Sep 17, 2009 at 08:44:56AM +0200, Jens Axboe wrote:
> > > > On Thu, Sep 17 2009, Markus Trippelsdorf wrote:
> > > > > On Tue, Sep 08, 2009 at 10:00:42PM +0200, Jens Axboe wrote:
> > > > > > On Mon, Sep 07 2009, Markus Trippelsdorf wrote:
> > > > > > > Just got this error today in my dmesg:
> > > > > > > btrfs csum failed ino 1483065 off 158482432 csum 4283543305 private 43905798
> > > > > > > 
> > > > > > > linux % find . -inum 1483065
> > > > > > > ./.git/objects/pack/pack-f9251bcc6a8afe3c92193e14d1d742f2f0182ce5.pack
> > > > > > > 
> > > > > > > It's the main pack file from my git linux kernel tree:
> > > > > > > 
> > > > > > 
> > > > > > Hmm, I ran into something very similar. Care to check what the corrupted
> > > > > > block of data looks like (and how big it is)?
> > > > > 
> > > > > I've hit the same problem again today:
> > > > > 
> > > > > btrfs csum failed ino 1826333 off 150208512 csum 4148434891 private 1660028275
> > > > > 
> > > > > The file in question is:
> > > > > ./.git/objects/pack/pack-a2330b703d5a7fd62626b39a5fdfb6eecf739d0d.pack
> > > > > 
> > > > > I can't read the file directly, because of the csum mismatch:
> > > > 
> > > > Chris, is there a way to force reading the file? Seems like that would
> > > > be a very handy feature.
> > > > 
> > > > Markus, not sure if that works, but you could always try and remount
> > > > with data checksumming disabled.
> > > > 
> > > > mount /dev/fooX -o remount,rw,nodatasum
> > > > 
> > > > should do the trick.
> > > 
> > > That doesn't work unfortunately, btrfs still calculates and compares the
> > > checksums (it won't write new ones I guess).
> > 
> > Ah ok, as mentioned I wasn't sure whether that would work or not. I'll
> > defer to Chris :-)
> 
> Understood.
> 
> I did some further investigations and was able to reconstruct exactly
> the same pack file in question by starting from an older backup copy of
> my git repro and then running the same git commands as previous. 
> Then I did a binary comparison between this reconstructed file and a
> corrupted backup copy from the time before the csum errors occured (I
> automatically backup every 4h).
> 
Thanks to Chris' patch (from IRC) I was able to compare the file with
the csum error to the reconstructed one. You'll find the reults as
attachments.

-- 
Markus

--9amGYk9869ThD9tj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=hex_bad1

08F403A0   5D 8E B3 32  7D 8F 5D E7  54 B6 9D 1E  E6 0C 9B 0D  BE 1D 9D 0C  34 BA 7F FE  7F D4 E5 1A  0A 16 29 96

--9amGYk9869ThD9tj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=hex_bad2

105AC3A0   76 80 1E 0A  3F 8A 7E FC  B3 2E 2B 9E  9E 53 82 10  C3 F6 4B C1  C0 12 FC 61  A5 0E 63 70  B0 A4 7B 27
105AC3C0   DC AE 26 CE  48 5D CA 07  B7 26 B6 3C  BC 91 AD 00  55 97 BF E4  8C D7 EF AA  28 B7 54 65  30 DB 78 A6
105AC3E0   26 90 18 88  8F F4 25 91  48 5F 9C F6  4F 0D 46 72  A2 04 77 1A  AF FB 88 23  93 AF FB AA  B9 82 BC CC

--9amGYk9869ThD9tj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=hex_good1

08F403A0   5D 8E B3 32  7D 8F 5D E7  54 B4 9D 1E  E6 0C 9B 0D  BE 1D 9D 0C  34 BA 7F FE  7F D4 E5 1A  0A 16 29 96

--9amGYk9869ThD9tj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=hex_good2

105AC3A0   76 80 1E 0A  3F 8A 7E FC  B3 2E 2B 9E  9E 53 82 10  C3 F7 4B C1  C0 12 FC 61  A5 0E 63 70  B0 A4 7B 27
105AC3C0   DC AE 26 CE  48 5D CA 07  B7 77 B6 3C  BC 91 AD 00  55 97 BF E4  8C D7 EF AA  28 A7 54 65  30 DB 78 A6
105AC3E0   26 90 18 88  8F F4 25 91  48 5F 9C F6  4F 0D 46 72  A2 04 77 1A  AF FB 88 23  93 AF FB AA  B9 82 BC CC

--9amGYk9869ThD9tj--
