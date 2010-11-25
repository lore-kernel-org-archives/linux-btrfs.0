From: =?ISO-8859-1?Q?P=E1draig_Brady?= <P@draigBrady.com>
Subject: Re: VFS support for fast copy on deduplicating FSes
Date: Thu, 25 Nov 2010 10:50:31 +0000
Message-ID: <4CEE3F77.4020206@draigBrady.com>
References: <AANLkTinz17SePZCCixBCA_WoW3rFWAsB7mRghL9uN17h@mail.gmail.com> <20101125103258.GA16562@mother.pipebreaker.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	BTRFS MAILING LIST <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20101125103258.GA16562@mother.pipebreaker.pl>
List-ID: <linux-btrfs.vger.kernel.org>

On 25/11/10 10:32, Tomasz Torcz wrote:
> On Thu, Nov 25, 2010 at 04:19:17AM -0600, David Nicol wrote:
>> unresearched question/suggestion:
>>
>> Is there general support for a "fast copy" ioctl in the VFS layer,
>> which would be hooked by file systems that support COW or other form=
s
>> of deduplication and can provide copy semantics by manipulating
>> metadata only?
>>
>=20
>   Yes, see reflink(2) syscall (http://lwn.net/Articles/331576/).
>=20

Yep and this: http://lwn.net/Articles/335380/
Note that cp --reflink has been supported for a while,
but it's BTRFS specific at the moment.
We'll need to change to the more generic interface.

cheers,
P=E1draig.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
