From: Gareth Pye <gareth@cerberos.id.au>
Subject: Re: COW a file from snapshot
Date: Thu, 22 Dec 2011 22:57:10 +1100
Message-ID: <CA+WRLO8iD=q9yXNv=ehwfNP0b0C_gDYztkix0fmxMGmNkAtnOw@mail.gmail.com>
References: <20111220150717.GA24891@hendrix.borisch.local>
	<CALJXSJp4jzfjyo3msvt=ZHvtidBkNZ5CSsfr9rjReLzWet_Pqg@mail.gmail.com>
	<CABVOS0-7-UCetP03VS3rMPTnFYJ0+9r-PEypcY1cMd_oovr33g@mail.gmail.com>
	<201112222235.57662.chris@csamuel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Chris Samuel <chris@csamuel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201112222235.57662.chris@csamuel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Chris, I=A0recommend=A0reading the previously linked thread. The suppli=
ed
(and reportedly working) patch was nacked because it violates some
principles or another of file systems. (although from my limited
understanding it only does it in the same way that btrfs snapshots do
in the first place)

On Thu, Dec 22, 2011 at 10:35 PM, Chris Samuel <chris@csamuel.org> wrot=
e:
>
> On Thu, 22 Dec 2011 07:12:13 PM Roman Kapusta wrote:
>
> > I'm using btrfs for about two years and this is the key feature I'm
> > missing all the time. Why is it not part of mainline btrfs already?
>
> Because nobody has written the code to do it yet?
>
> I'm sure the developers would welcome patches for this with open arms=
!
>
> cheers,
> Chris
> --
> =A0Chris Samuel =A0: =A0http://www.csamuel.org/ =A0: =A0Melbourne, VI=
C
>
> This email may come with a PGP signature as a file. Do not panic.
> For more info see: http://en.wikipedia.org/wiki/OpenPGP




--
Gareth Pye
Level 2 Judge, Melbourne, Australia
Australian MTG Forum:=A0mtgau.com
gareth@cerberos.id.au=A0-=A0www.rockpaperdynamite.wordpress.com
"Dear God, I would like to file a bug report"
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
