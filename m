From: Ed Tomlinson <edt@aei.ca>
Subject: Re: Btrfs for mainline
Date: Sun, 4 Jan 2009 10:56:07 -0500
Message-ID: <200901041056.07714.edt@aei.ca>
References: <1230932112.7538.82.camel@think.oraclecorp.com> <adaocyppco5.fsf@cisco.com> <20090104222638.C7FD.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Cc: Roland Dreier <rdreier@cisco.com>,
	Chris Mason <chris.mason@oracle.com>,
	Andi Kleen <andi@firstfloor.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org,
	"linux-fsdevel" <linux-fsdevel@vger.kernel.org>,
	"linux-btrfs" <linux-btrfs@vger.kernel.org>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090104222638.C7FD.KOSAKI.MOTOHIRO@jp.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On January 4, 2009, KOSAKI Motohiro wrote:
> Hi
> 
> > One possibility would be to mimic ext4 and register the fs as "btrfsdev"
> > until it's considered stable enough for production.  I agree with the
> > consensus that we want to use the upstream kernel as a nexus for
> > coordinating btrfs development, so I don't think it's worth waiting a
> > release or two to merge something.
> 
> I like this idea.
> I also want to test btrfs. but I'm not interested out of tree code.

I'll second this.  Please get btrfsdev into mainline asap.

TIA
Ed Tomlinson
