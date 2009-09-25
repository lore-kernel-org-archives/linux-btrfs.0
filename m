From: Bron Gondwana <brong@fastmail.fm>
Subject: Re: grub-0.97: btrfs multidevice  support [PATCH]
Date: Sat, 26 Sep 2009 09:47:04 +1000
Message-ID: <20090925234704.GA13393@brong.net>
References: <4ABBC1F5.70808@redhat.com>
 <20090924202146.GA16412@thorin>
 <20090924223810.GA2638@brong.net>
 <20090925140951.GA6318@thorin>
 <20090925150136.GQ13423@riva.ucam.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: The development of GRUB 2 <grub-devel@gnu.org>,
	Bron Gondwana <brong@fastmail.fm>,
	Ric Wheeler <rwheeler@redhat.com>,
	Chris Mason <chris.mason@oracle.com>,
	The development of BTRFS <linux-btrfs@vger.kernel.org>
To: Colin Watson <cjwatson@ubuntu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090925150136.GQ13423@riva.ucam.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 25, 2009 at 04:01:36PM +0100, Colin Watson wrote:
> On Fri, Sep 25, 2009 at 04:09:51PM +0200, Robert Millan wrote:
> > On Fri, Sep 25, 2009 at 08:38:10AM +1000, Bron Gondwana wrote:
> > > On Thu, Sep 24, 2009 at 10:21:46PM +0200, Robert Millan wrote:
> > > > I'm sorry but GRUB Legacy is not maintained.  At least not by us;  we've
> > > > deprecated it in favour of GRUB 2.
> > > > 
> > > > It is also being abandoned by distributors, so I wouldn't recommend that you
> > > > put any effort in developing for it.
> > > 
> > > You've been spouting this line for years, and yet my Ubuntu 10.4 machine
> > > uses, guess what, GRUB 1.
> 
> I assume you typoed, since there's no such thing as Ubuntu 10.4 yet.
> When there is (well, 10.04 anyway), it will use GRUB 2 by default.

Yeah, I meant 9.04 of course.  Sorry.  The one that's currently
stable!  I am running GRUB 2 on my 9.10 laptop, as well as my
Debian "testing" box.  It works fine, though /boot/grub is full
of a LOT of files.  Still, it's simpler all together.

> > > Edward - please do continue to develop patches for GRUB 1 (the one that
> > > still actually works plenty well enough for lots of people) and ignore the
> > > naysayers who are happy to throw out backwards compatibility.
> 
> It would be great if somebody could take up Edward's work and port it to
> GRUB 2. If nobody else does then I'd be interested in doing so myself,
> although I will not be able to start for a month or two from now.
> 
> Robert is working hard on making GRUB 2 usable, and is just advising
> Edward that, right now, there is no upstream for GRUB Legacy who could
> either accept or usefully comment on his patch. 

Just out of interest, how long has it been that there was no stable
supported version of GRUB?  My vague memory is that it's been about
6 years now since GRUB 1 was declared deprecated in favour of the
nebulous future.

> This isn't naysaying those people who post patches for GRUB Legacy - but
> given the reality that nobody is maintaining GRUB Legacy upstream right
> now, which is better, to have your patch ignored or to receive a note
> saying that it's against an unmaintained target? I'd go for not being
> ignored any day.

Well, yeah.  True.  There's no really good path out of here other than
everyone moving to GRUB 2 before running any filesystem that's changed
in the past few years as root.

Bron.
