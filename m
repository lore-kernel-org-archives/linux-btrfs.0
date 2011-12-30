From: Sandra Schlichting <littlesandra88@gmail.com>
Subject: Re: Encryption implementation like ZFS?
Date: Fri, 30 Dec 2011 22:12:32 +0100
Message-ID: <CAELiMBMiBRnNTq8ZnTPRusE_56xFqvR_5+MLYQcS9q5Hbq3gRA@mail.gmail.com>
References: <CAELiMBN7vPQ=42eNwT3oGztWS-666RrpzDzv7nDF_LX+0gjxhQ@mail.gmail.com>
	<CANZ96zUydMMYSGoX9QM8p5KSE_17faDCM9ruEeT9peO4_q181A@mail.gmail.com>
	<CAELiMBP9g52fHQv=ur0Kjk+=kO9DWJMCh20RL+-2s_0pS7GVXg@mail.gmail.com>
	<CANZ96zXurbiy=WOOmULcs13fiQomuw=WzDtqm-KFptCx_4TA5A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Billy Crook <billycrook@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CANZ96zXurbiy=WOOmULcs13fiQomuw=WzDtqm-KFptCx_4TA5A@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

> Good point. =A0I'm actually very close to moving from magnetic to SSD
> storage for my btrfs volumes. =A0Would my luks layer offset the major=
ity
> of any advantage I might otherwise see from SSD? =A0I'd be happy just=
 to
> eliminate seektime.

Not to my knowledge.

> I've been using btrfs on luks now for 6 months and online grow works
> fine -- if you online grow the luks container first. (cryptsetup
> resize <name>) =A0It does make it a more manual process, I suppose, b=
ut
> for me it's worth knowing that no part of the filesystem, will ever b=
e
> available should a disk be stolen.

That is of course true =3D)

That is sort the EXT2/3/4 way of doing it, where it would be very
handy if btrfs adapted the ZFS idea, where the FS knows and does
everything, where everything is done through the btrfs commands.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
