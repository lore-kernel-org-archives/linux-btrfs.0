From: Bron Gondwana <brong@fastmail.fm>
Subject: Re: grub-0.97: btrfs multidevice  support [PATCH]
Date: Fri, 25 Sep 2009 08:38:10 +1000
Message-ID: <20090924223810.GA2638@brong.net>
References: <4ABBC1F5.70808@redhat.com>
 <20090924202146.GA16412@thorin>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: The development of GRUB 2 <grub-devel@gnu.org>,
	The development of BTRFS <linux-btrfs@vger.kernel.org>,
	Chris Mason <chris.mason@oracle.com>,
	Ric Wheeler <rwheeler@redhat.com>
To: Robert Millan <rmh@aybabtu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090924202146.GA16412@thorin>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Sep 24, 2009 at 10:21:46PM +0200, Robert Millan wrote:
> 
> Hi Edward,
> 
> I'm sorry but GRUB Legacy is not maintained.  At least not by us;  we've
> deprecated it in favour of GRUB 2.
> 
> It is also being abandoned by distributors, so I wouldn't recommend that you
> put any effort in developing for it.

You've been spouting this line for years, and yet my Ubuntu 10.4 machine
uses, guess what, GRUB 1.  Mainly because you deprecated GRUB Legacy[tm]
well before GRUB 2 was usable.

(you in the generic sense of the GRUB project here)

Edward - please do continue to develop patches for GRUB 1 (the one that
still actually works plenty well enough for lots of people) and ignore the
naysayers who are happy to throw out backwards compatibility.

Sometimes you have to maintain crappy code because people out there depend
on it.  And we thank those who step up and do it rather than throw their
hands up and pretend it doesn't need doing!

Ta,

Bron.
