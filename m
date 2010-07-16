From: "Sebastian 'gonX' Jensen" <gonx@overclocked.net>
Subject: Re: Status of BTRFS
Date: Fri, 16 Jul 2010 14:22:35 +0200
Message-ID: <AANLkTikYXkNqj-l0HtwWsX9anrCHMGXfRAVLdlX1a5Eo@mail.gmail.com>
References: <000001cb24dd$cab87650$602962f0$@com>
	<AANLkTikQ4Q2W2MII6vAo3WzBN9-d0R41ZsLkbJOkNjMS@mail.gmail.com>
	<000101cb24e0$804e4b00$80eae100$@com>
	<20100716121633.GC24361@mother.pipebreaker.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: Tomasz Torcz <tomek@pipebreaker.pl>, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100716121633.GC24361@mother.pipebreaker.pl>
List-ID: <linux-btrfs.vger.kernel.org>

On 16 July 2010 14:16, Tomasz Torcz <tomek@pipebreaker.pl> wrote:
> On Fri, Jul 16, 2010 at 08:14:49AM -0400, Edward Ned Harvey wrote:
>> > From: Sebastian 'gonX' Jensen [mailto:gonx@overclocked.net]
>> >
>> > On 16 July 2010 13:55, Edward Ned Harvey <kernel@nedharvey.com> wr=
ote:
>> > > Is this a good place to get a clue about the status of BTRFS? =C2=
=A0Like
>> > ... =C2=A0Is
>> > > it usable yet, and stuff like that?
>> > >
>> >
>> > It has been in a good state for quite a while. There seems to be q=
uite
>> > a lot of people who use it on enterprise-grade hardware and server=
s
>> > that require high reliability.
>>
>> Is it included in any distributions yet? =C2=A0Do you just need to b=
uild the latest kernel or something like that? =C2=A0Download the sourc=
e code, and follow what it says in the INSTALL file?
>
> =C2=A0Of course it is. Fedora installer allows btrfs since for few re=
leases now.
>
> --
> Tomasz Torcz =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0O=
nly gods can safely risk perfection,
> xmpp: zdzichubg@chrome.pl =C2=A0 =C2=A0 it's a dangerous thing for a =
man. =C2=A0-- Alia
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs=
" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
>

Yes, Fedora is one of the releases that has officially supported it
for a while now. Additionally an initrd hook for btrfs has just been
implemented for Arch Linux, so you might see btrfs being an option for
that in the next version of the installer :-)

Regards,
Sebastian J.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
