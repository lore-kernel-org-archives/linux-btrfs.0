From: Colin Watson <cjwatson@ubuntu.com>
Subject: Re: grub-0.97: btrfs multidevice  support [PATCH]
Date: Fri, 25 Sep 2009 16:01:36 +0100
Message-ID: <20090925150136.GQ13423@riva.ucam.org>
References: <4ABBC1F5.70808@redhat.com> <20090924202146.GA16412@thorin>
	<20090924223810.GA2638@brong.net> <20090925140951.GA6318@thorin>
Reply-To: The development of GRUB 2 <grub-devel@gnu.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Bron Gondwana <brong@fastmail.fm>, Ric Wheeler <rwheeler@redhat.com>,
	The development of BTRFS <linux-btrfs@vger.kernel.org>,
	Chris Mason <chris.mason@oracle.com>
To: The development of GRUB 2 <grub-devel@gnu.org>
Return-path: <grub-devel-bounces+gcbgd-grub-devel=m.gmane.org@gnu.org>
In-Reply-To: <20090925140951.GA6318@thorin>
List-Unsubscribe: <http://lists.gnu.org/mailman/listinfo/grub-devel>,
	<mailto:grub-devel-request@gnu.org?subject=unsubscribe>
List-Archive: <http://lists.gnu.org/pipermail/grub-devel>
List-Post: <mailto:grub-devel@gnu.org>
List-Help: <mailto:grub-devel-request@gnu.org?subject=help>
List-Subscribe: <http://lists.gnu.org/mailman/listinfo/grub-devel>,
	<mailto:grub-devel-request@gnu.org?subject=subscribe>
Errors-To: grub-devel-bounces+gcbgd-grub-devel=m.gmane.org@gnu.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 25, 2009 at 04:09:51PM +0200, Robert Millan wrote:
> On Fri, Sep 25, 2009 at 08:38:10AM +1000, Bron Gondwana wrote:
> > On Thu, Sep 24, 2009 at 10:21:46PM +0200, Robert Millan wrote:
> > > I'm sorry but GRUB Legacy is not maintained.  At least not by us;  we've
> > > deprecated it in favour of GRUB 2.
> > > 
> > > It is also being abandoned by distributors, so I wouldn't recommend that you
> > > put any effort in developing for it.
> > 
> > You've been spouting this line for years, and yet my Ubuntu 10.4 machine
> > uses, guess what, GRUB 1.

I assume you typoed, since there's no such thing as Ubuntu 10.4 yet.
When there is (well, 10.04 anyway), it will use GRUB 2 by default.

> > Edward - please do continue to develop patches for GRUB 1 (the one that
> > still actually works plenty well enough for lots of people) and ignore the
> > naysayers who are happy to throw out backwards compatibility.

It would be great if somebody could take up Edward's work and port it to
GRUB 2. If nobody else does then I'd be interested in doing so myself,
although I will not be able to start for a month or two from now.


Robert is working hard on making GRUB 2 usable, and is just advising
Edward that, right now, there is no upstream for GRUB Legacy who could
either accept or usefully comment on his patch. It would of course be
possible for some people (presumably mostly the distributors who rely on
it) to get together and declare themselves the new upstream for GRUB
Legacy, but most of the people who might be interested in such things
seem to have either lost interest or thrown their weight behind GRUB 2
upstream. Certainly this distributor right here is in the latter camp as
it seems much more likely to produce a result that meets our needs in
the end. (Plus, I think such a revitalised upstream would be a caretaker
at best, and wouldn't really be able to effectively work on some of the
major issues that have dogged distributors of GRUB Legacy for years
without reinventing the wheel of GRUB 2.)

This isn't naysaying those people who post patches for GRUB Legacy - but
given the reality that nobody is maintaining GRUB Legacy upstream right
now, which is better, to have your patch ignored or to receive a note
saying that it's against an unmaintained target? I'd go for not being
ignored any day.

-- 
Colin Watson                                       [cjwatson@ubuntu.com]
