From: =?UTF-8?B?Q2zDoXVkaW8=?= Martins <ctpm@ist.utl.pt>
Subject: Re: assertion failures
Date: Sun, 28 Feb 2010 03:05:00 +0000
Message-ID: <20100228030500.732f9a05.ctpm@ist.utl.pt>
References: <20100226175927.GG12841@think>
	<20100226181157.50F73414B9@viridian.itc.virginia.edu>
	<20100226190915.GI12841@think>
	<201002262149.14718.diegocg@gmail.com>
	<20100226210853.GM12841@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Diego Calleja <diegocg@gmail.com>,
	Bill Pemberton <wfp5p@viridian.itc.virginia.edu>,
	linux-btrfs@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100226210853.GM12841@think>
List-ID: <linux-btrfs.vger.kernel.org>


On Fri, 26 Feb 2010 16:08:53 -0500 Chris Mason <chris.mason@oracle.com>=
 wrote:
>=20
> The problem is that with a writeback cache, any write is likely
> to be missed on power failures.  journalling in general requires some
> notion of being able to wait for block A to be on disk before you wri=
te
> block B, and that's difficult to do when the disk lies about what is
> really there ;)
>=20

 Hi,

 Has anyone managed to make a list of drive models which are suspect of
lying about what has really hit the disk surface, or of not hounouring
barriers?

 Can anyone share any cases where your investigation turned positive
evidence that a drive model was defective in this respect?

 This is so worrying that I think we should understand why are
manufacturers doing this: is it firmware bugs? Is it to inflate
benchmarks? Are they shoving crap on the cheaper drives' firmware to
force "enterprise" people to buy the more expensive SAS models?

 If one could publish a list of known defective drives, maybe we could
put some shame on the manufacturers or even convince them to fix their
firmware. Failing that, we might at least be able to avoid the known
bad models.

 Any insight into this subject will be appreciated.

Best regards

Cl=C3=A1udio

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
