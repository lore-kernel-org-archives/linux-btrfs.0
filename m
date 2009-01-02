From: Roland Dreier <rdreier@cisco.com>
Subject: Re: Btrfs for mainline
Date: Fri, 02 Jan 2009 14:26:34 -0800
Message-ID: <adaocyppco5.fsf@cisco.com>
References: <1230722935.4680.5.camel@think.oraclecorp.com>
	<20081231104533.abfb1cf9.akpm@linux-foundation.org>
	<1230765549.7538.8.camel@think.oraclecorp.com>
	<87r63ljzox.fsf@basil.nowhere.org>
	<1230924749.7538.35.camel@think.oraclecorp.com>
	<20090102210104.GC496@one.firstfloor.org>
	<1230932112.7538.82.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andi Kleen <andi@firstfloor.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1230932112.7538.82.camel@think.oraclecorp.com> (Chris Mason's
	message of "Fri, 02 Jan 2009 16:35:12 -0500")
List-ID: <linux-btrfs.vger.kernel.org>

 > > > I don't disagree, please do keep in mind that I'm not suggesting anyone
 > > > use this in production yet.

 > > When it's in mainline I suspect people will start using it for that.

 > I think the larger question here is where we want development to happen.
 > I'm definitely not pretending that btrfs is perfect, but I strongly
 > believe that it will be a better filesystem if the development moves to
 > mainline where it will attract more eyeballs and more testers.

One possibility would be to mimic ext4 and register the fs as "btrfsdev"
until it's considered stable enough for production.  I agree with the
consensus that we want to use the upstream kernel as a nexus for
coordinating btrfs development, so I don't think it's worth waiting a
release or two to merge something.

 - R.
