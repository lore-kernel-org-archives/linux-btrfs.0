From: Claudio Martins <ctpm@ist.utl.pt>
Subject: Re: ssd optimised mode
Date: Mon, 23 Feb 2009 16:48:55 +0000
Message-ID: <200902231648.55563.ctpm@ist.utl.pt>
References: <934e480c0902200326m7647d87cq28bfa1675ef012f4@mail.gmail.com> <3a7f57190902221706l34e8f925m9ef687c1df920123@mail.gmail.com> <yq1wsbht8ci.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: Dmitri Nikulin <dnikulin@gmail.com>, linux-btrfs@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <yq1wsbht8ci.fsf@sermon.lab.mkp.net>
List-ID: <linux-btrfs.vger.kernel.org>


On Monday 23 February 2009, Martin K. Petersen wrote:
> "Stuff" in this case is on the order of megabytes, not a few sectors
> like on spinning media.  With disk drives the risk of garbling unrela=
ted
> files is there but relatively small.  On SSDs it's much higher becaus=
e
> of the big blocking and the high latency erase/rewrite cycle.  In
> several cases I've lost system binaries that obviously weren't being
> written when I crashed the system.  In one case I even lost all of
> /sbin.
>

 What brand of SSDs are we talking about? What filesystems did you expe=
riment=20
with?

 Best regards

Cl=C3=A1udio

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
