From: cwillu <cwillu@cwillu.com>
Subject: Re: [PATCH] [RFC] Add btrfs autosnap feature
Date: Mon, 5 Mar 2012 04:28:22 -0600
Message-ID: <CAE5mzvg8mcgz57F3x3UDPauuDfP_nrPOYLp6ohWJGePVLLFxMQ@mail.gmail.com>
References: <1330484376-16178-1-git-send-email-anand.jain@oracle.com>
	<1330484376-16178-2-git-send-email-anand.jain@oracle.com>
	<CAE5mzvjiL+81AsSspTrE1A1BBiL27zJ1qK1oqCF27oL+-CG9Mw@mail.gmail.com>
	<4F54625E.6040003@oracle.com>
	<4F54938E.6080704@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org, hugo@carfax.org.uk,
	chris.mason@oracle.com
To: Anand Jain <Anand.Jain@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4F54938E.6080704@oracle.com>
List-ID: <linux-btrfs.vger.kernel.org>

> =C2=A0---
> =C2=A0sync; read current tran-id and compare
> =C2=A0(new tgw occurs)
> =C2=A0snapshot
> =C2=A0new tgw =C2=A0occurs
> =C2=A0sync; read current tran-id again and store
> =C2=A0---
>
> =C2=A0which will result in failing to take snapshot even if there are=
 changes.

"btrfs sub find-new /snapshot-xxxx -1" shows the transid of the latest
change of the snapshot, not the whole filesystem.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
