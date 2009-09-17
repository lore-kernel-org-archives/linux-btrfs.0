From: Markus Trippelsdorf <markus@trippelsdorf.de>
Subject: Re: btrfs csum failed on git .pack file
Date: Thu, 17 Sep 2009 14:15:01 +0200
Message-ID: <20090917121501.GB1877@phenom2.trippelsdorf.de>
References: <20090907203531.GA1889@phenom2.trippelsdorf.de>
 <20090908200041.GF18599@kernel.dk>
 <20090917050512.GB1916@phenom2.trippelsdorf.de>
 <20090917064456.GZ23126@kernel.dk>
 <20090917090428.GA1877@phenom2.trippelsdorf.de>
 <20090917090549.GE23126@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090917090549.GE23126@kernel.dk>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Sep 17, 2009 at 11:05:49AM +0200, Jens Axboe wrote:
> On Thu, Sep 17 2009, Markus Trippelsdorf wrote:
> > On Thu, Sep 17, 2009 at 08:44:56AM +0200, Jens Axboe wrote:
> > > On Thu, Sep 17 2009, Markus Trippelsdorf wrote:
> > > > On Tue, Sep 08, 2009 at 10:00:42PM +0200, Jens Axboe wrote:
> > > > > On Mon, Sep 07 2009, Markus Trippelsdorf wrote:
> > > > > > Just got this error today in my dmesg:
> > > > > > btrfs csum failed ino 1483065 off 158482432 csum 4283543305 private 43905798
> > > > > > 
> > > > > > linux % find . -inum 1483065
> > > > > > ./.git/objects/pack/pack-f9251bcc6a8afe3c92193e14d1d742f2f0182ce5.pack
> > > > > > 
> > > > > > It's the main pack file from my git linux kernel tree:
> > > > > > 
> > > > > 
> > > > > Hmm, I ran into something very similar. Care to check what the corrupted
> > > > > block of data looks like (and how big it is)?
> > > > 
> > > > I've hit the same problem again today:
> > > > 
> > > > btrfs csum failed ino 1826333 off 150208512 csum 4148434891 private 1660028275
> > > > 
> > > > The file in question is:
> > > > ./.git/objects/pack/pack-a2330b703d5a7fd62626b39a5fdfb6eecf739d0d.pack
> > > > 
> > > > I can't read the file directly, because of the csum mismatch:
> > > 
> > > Chris, is there a way to force reading the file? Seems like that would
> > > be a very handy feature.
> > > 
> > > Markus, not sure if that works, but you could always try and remount
> > > with data checksumming disabled.
> > > 
> > > mount /dev/fooX -o remount,rw,nodatasum
> > > 
> > > should do the trick.
> > 
> > That doesn't work unfortunately, btrfs still calculates and compares the
> > checksums (it won't write new ones I guess).
> 
> Ah ok, as mentioned I wasn't sure whether that would work or not. I'll
> defer to Chris :-)

Understood.

I did some further investigations and was able to reconstruct exactly
the same pack file in question by starting from an older backup copy of
my git repro and then running the same git commands as previous. 
Then I did a binary comparison between this reconstructed file and a
corrupted backup copy from the time before the csum errors occured (I
automatically backup every 4h).

This is the result (first line good pack file, second line corrupted
file):

vbindiff debug/.git/objects/pack/pack-a2330b703d5a7fd62626b39a5fdfb6eecf739d0d.pack debug2/.git/objects/pack/pack-a2330b703d5a7fd62626b39a5fdfb6eecf739d0d.pack

0130 9FA0: E2 3B 43 AA 63 BF 28 B3  87 B7 FD AB DA 74 2D 1C
0130 9FA0: E2 3B 43 AA 63 BF 28 B3  87 33 FD AB DA 74 2D 1C

06CD DF90: B0 22 6B 46 9F ED 6E 47  73 5E 7E EB DA 5F D6 11
06CD DF90: B0 22 6B 46 9F ED 6E 47  73 1E 7E EB DA 5F D6 11

06CD DFC0: 0D 86 2B B2 57 A4 5A CD  78 4B 08 94 C0 65 17 3A
06CD DFC0: 0D 86 2B B2 57 A4 5A CD  78 0B 08 94 C0 65 17 3A

0802 C3C0: 5C A5 E1 4A 1C BC 14 04  16 4A 29 D3 CC EF A6 80
0802 C3C0: 5C 25 E1 4A 1C BC 14 04  16 48 29 D3 CC EF A6 80

081A B3C0: 7D 7A 2C CD 20 89 E5 F2  A8 D3 32 38 04 BA 8A B5
081A B3C0: 7D 3A 2C CD 20 89 E5 F2  A8 D3 32 38 04 BA 8A B5

098E C430: FE 24 4A 19 09 F4 D5 1F  22 E8 36 FA F8 55 B2 6E
098E C430: FE 24 4A 19 09 F4 D5 1F  22 E0 36 FA F8 55 B2 6E

098E C440: 1B 3F C1 B4 BB 80 F8 5A  FB EE 0D A3 3F C5 A4 DB
098E C440: 1B 3D C1 B4 BB 80 F8 5A  FB EE 0D A3 3F C5 A4 DB

098E C4D0: F8 6C E2 65 18 7A 5D 33  2E 35 77 64 B2 81 BE DF
098E C4D0: F8 6C E2 65 18 7A 5D 33  2E 25 77 64 B2 81 BE DF

098E C4E0: 05 18 DE E3 00 78 D2 2C  4F 91 8F AF 0B F6 0C 31
098E C4E0: 05 1C DE E3 00 78 D2 2C  4F 91 8F AF 0B F6 0C 31

098E C500: 0A 12 D3 E7 FA B8 40 DE  0D 71 94 88 5D 4C 97 21
098E C500: 0A 12 D3 E7 FA B8 40 DE  0D 51 94 88 5D 4C 97 21

098E C540: 93 F2 58 C7 49 9A AA EB  30 3D 28 AA E3 09 4B 7B
098E C540: 93 F2 58 C7 49 9A AA EB  30 3C 28 AA E3 09 4B 7B

0FDE C420: F3 6A C2 38 76 43 9E 86  0D 9C 89 86 F1 E6 B0 F2
0FDE C420: F3 6A C2 38 76 43 9E 86  0D DC 89 86 F1 E6 B0 F2

0FDE C430: 38 E4 69 2E 22 1D E4 FF  90 A7 C6 E8 9F 08 4C 98
0FDE C430: 38 E4 69 2E 22 1D E4 FF  90 A5 C6 E8 9F 08 4C 98

1214 A4C0: 24 D6 56 AC 8B D8 D0 9B  D2 62 7B 83 C7 0B 3D BE
1214 A4C0: 24 D4 56 AC 8B D8 D0 9B  D2 62 7B 83 C7 0B 3D BE

1214 A500: EC 51 D3 FF C5 7D 30 DD  6D 45 50 FE E9 64 A4 FC
1214 A500: EC 11 D3 FF C5 7D 30 DD  6D 45 50 FE E9 64 A4 FC

1214 A520: D9 4D 63 EB 77 4D F0 BE  5E B3 6B DE E6 D2 28 67
1214 A520: D9 4D 63 EB 77 4D F0 BE  5E 33 6B DE E6 D2 28 67

-- 
Markus
