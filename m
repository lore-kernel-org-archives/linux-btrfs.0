From: Peng Tao <bergwolf@gmail.com>
Subject: Re: grub-0.97: btrfs multidevice support [PATCH]
Date: Sun, 27 Sep 2009 11:29:11 +0800
Message-ID: <6149e97b0909262029w30fe3adcq591515f0f2b156c4@mail.gmail.com>
References: <4ABBC1F5.70808@redhat.com> <20090924202146.GA16412@thorin>
	 <20090924223810.GA2638@brong.net> <20090925140951.GA6318@thorin>
	 <20090925150136.GQ13423@riva.ucam.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: The development of GRUB 2 <grub-devel@gnu.org>,
	Bron Gondwana <brong@fastmail.fm>,
	Ric Wheeler <rwheeler@redhat.com>,
	Chris Mason <chris.mason@oracle.com>,
	The development of BTRFS <linux-btrfs@vger.kernel.org>
To: Colin Watson <cjwatson@ubuntu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090925150136.GQ13423@riva.ucam.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 25, 2009 at 11:01 PM, Colin Watson <cjwatson@ubuntu.com> wr=
ote:
> On Fri, Sep 25, 2009 at 04:09:51PM +0200, Robert Millan wrote:
>> On Fri, Sep 25, 2009 at 08:38:10AM +1000, Bron Gondwana wrote:
>> > On Thu, Sep 24, 2009 at 10:21:46PM +0200, Robert Millan wrote:
>> > > I'm sorry but GRUB Legacy is not maintained. =C2=A0At least not =
by us; =C2=A0we've
>> > > deprecated it in favour of GRUB 2.
>> > >
>> > > It is also being abandoned by distributors, so I wouldn't recomm=
end that you
>> > > put any effort in developing for it.
>> >
>> > You've been spouting this line for years, and yet my Ubuntu 10.4 m=
achine
>> > uses, guess what, GRUB 1.
>
> I assume you typoed, since there's no such thing as Ubuntu 10.4 yet.
> When there is (well, 10.04 anyway), it will use GRUB 2 by default.
>
>> > Edward - please do continue to develop patches for GRUB 1 (the one=
 that
>> > still actually works plenty well enough for lots of people) and ig=
nore the
>> > naysayers who are happy to throw out backwards compatibility.
>
> It would be great if somebody could take up Edward's work and port it=
 to
> GRUB 2. If nobody else does then I'd be interested in doing so myself=
,
> although I will not be able to start for a month or two from now.
Is there any guild lines for porting GPLv2 code to GRUB2? I've looked
at the GRUB2 wiki but very few things are documented there
(http://grub.enbug.org/). I'd like to see what it would take to port
the patches. If I can afford it, I'd like to try.
>
>
> Robert is working hard on making GRUB 2 usable, and is just advising
> Edward that, right now, there is no upstream for GRUB Legacy who coul=
d
> either accept or usefully comment on his patch. It would of course be
> possible for some people (presumably mostly the distributors who rely=
 on
> it) to get together and declare themselves the new upstream for GRUB
> Legacy, but most of the people who might be interested in such things
> seem to have either lost interest or thrown their weight behind GRUB =
2
> upstream. Certainly this distributor right here is in the latter camp=
 as
> it seems much more likely to produce a result that meets our needs in
> the end. (Plus, I think such a revitalised upstream would be a careta=
ker
> at best, and wouldn't really be able to effectively work on some of t=
he
> major issues that have dogged distributors of GRUB Legacy for years
> without reinventing the wheel of GRUB 2.)
>
> This isn't naysaying those people who post patches for GRUB Legacy - =
but
> given the reality that nobody is maintaining GRUB Legacy upstream rig=
ht
> now, which is better, to have your patch ignored or to receive a note
> saying that it's against an unmaintained target? I'd go for not being
> ignored any day.
>
> --
> Colin Watson =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 [cjwatson@ubuntu.com]
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs=
" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
>



--=20
Cheers,
Peng Tao
State Key Laboratory of Networking and Switching Technology
Beijing Univ. of Posts and Telecoms.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
