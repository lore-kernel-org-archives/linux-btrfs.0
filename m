From: Daniel J Blueman <daniel.blueman@gmail.com>
Subject: Re: btrfs csum failed on git .pack file
Date: Wed, 9 Sep 2009 09:18:06 +0100
Message-ID: <6278d2220909090118o6cdadb38ic38f2991d4fd1e10@mail.gmail.com>
References: <20090907203531.GA1889@phenom2.trippelsdorf.de>
	 <20090908200041.GF18599@kernel.dk>
	 <20090908202211.GA1901@phenom2.trippelsdorf.de>
	 <20090908203214.GH18599@kernel.dk>
	 <20090909065533.GA2861@phenom2.trippelsdorf.de>
	 <20090909070141.GL18599@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Markus Trippelsdorf <markus@trippelsdorf.de>,
	linux-btrfs@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090909070141.GL18599@kernel.dk>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Sep 9, 2009 at 8:01 AM, Jens Axboe<jens.axboe@oracle.com> wrote:
> On Wed, Sep 09 2009, Markus Trippelsdorf wrote:
>> On Tue, Sep 08, 2009 at 10:32:14PM +0200, Jens Axboe wrote:
>> > On Tue, Sep 08 2009, Markus Trippelsdorf wrote:
>> > > On Tue, Sep 08, 2009 at 10:00:42PM +0200, Jens Axboe wrote:
>> > > > On Mon, Sep 07 2009, Markus Trippelsdorf wrote:
>> > > > > Just got this error today in my dmesg:
>> > > > > btrfs csum failed ino 1483065 off 158482432 csum 4283543305 private 43905798
>> > > > >
>> > > > > linux % find . -inum 1483065
>> > > > > ./.git/objects/pack/pack-f9251bcc6a8afe3c92193e14d1d742f2f0182ce5.pack
>> > > > >
>> > > > > It's the main pack file from my git linux kernel tree:
>> > > > >
>> > > >
>> > > > Hmm, I ran into something very similar. Care to check what the corrupted
>> > > > block of data looks like (and how big it is)?
>> > >
>> > > I've already deleted the file in question unfortunately.
>> > > On IRC Chris decided that either bad RAM or a harddrive error was the
>> > > most likely reason for this chechsum mismatch.
>> >
>> > Darn, that's too bad. The corruption issue I had was also in a git pack
>> > file. It was fine one day, bad the next. Turned out to be 16kb of 0xff
>> > in the file, and I blamed it on the (cheap) SSD drive that hosted the
>> > local git repo. It's still the most likely explanation given the nature
>> > of the problem, however it would have been really interesting to see
>> > what corruption you had.
>>
>> If by cheap SSD drive you mean an Indilinx Barefoot based one, we might
>> be using the same hardware (30GB Vertex in my case).
>
> Spooky, yes indeed that's the very same drive I'm using. Also see my
> postings on this very issue here, top two entries:
>
> http://axboe.livejournal.com/
>
> So that pretty much looks like it reaffirms some of my suspicions. Is
> the drive in a laptop that you suspend and resume?

If you're on firmware < 1.30, the changlog includes some fixes which
may be relevant, eg if "block 0" is relative, or you're
suspending/resuming:

- Race condition occurred during soft reset handler
- If read fail occurs during reading stamp information, firmware
corrupted block 0.
- Power off recovery had bug in certain circumstances

http://www.ocztechnologyforum.com/forum/showthread.php?t=57516
-- 
Daniel J Blueman
