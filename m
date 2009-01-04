From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: Btrfs for mainline
Date: Sun, 4 Jan 2009 22:28:38 +0900 (JST)
Message-ID: <20090104222638.C7FD.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <1230932112.7538.82.camel@think.oraclecorp.com> <adaocyppco5.fsf@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Cc: kosaki.motohiro@jp.fujitsu.com,
	Chris Mason <chris.mason@oracle.com>,
	Andi Kleen <andi@firstfloor.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Roland Dreier <rdreier@cisco.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <adaocyppco5.fsf@cisco.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hi

> One possibility would be to mimic ext4 and register the fs as "btrfsdev"
> until it's considered stable enough for production.  I agree with the
> consensus that we want to use the upstream kernel as a nexus for
> coordinating btrfs development, so I don't think it's worth waiting a
> release or two to merge something.

I like this idea.
I also want to test btrfs. but I'm not interested out of tree code.



