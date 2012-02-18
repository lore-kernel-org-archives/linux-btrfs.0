From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: brtfs on top of dmcrypt with SSD. No corruption iff write cache off?
Date: Sat, 18 Feb 2012 13:39:24 +0100
Message-ID: <201202181339.24502.Martin@lichtvoll.de>
References: <20120130003754.GD4380@merlins.org> <4F384FAA.5060506@redhat.com> <20120213001400.GD31989@merlins.org> (sfid-20120213_091738_261043_A8965C3B)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Cc: Marc MERLIN <marc@merlins.org>, Milan Broz <mbroz@redhat.com>,
	Chris Mason <chris.mason@oracle.com>,
	jeff@deserettechnology.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120213001400.GD31989@merlins.org>
List-ID: <linux-btrfs.vger.kernel.org>

Sorry, I forget to keep Cc=B4s, different lists, different habits.

To Milan Broz: Well now I noticed that you linked to your own blog entr=
y.=20
Please do not take my below statements personally - I might have writte=
n=20
them a bit harshly. Actually I do not really know whether your statemen=
t=20
that TRIM is overrated is correct, but before believing that TRIM does =
not=20
give much advantage, I would like to see at least some evidence of any=20
sort, cause for me my explaination below that it should make a differen=
ce=20
at least seems logical to me.

Am Montag, 13. Februar 2012 schrieb Marc MERLIN:
> On Mon, Feb 13, 2012 at 12:47:54AM +0100, Milan Broz wrote:
> > On 02/12/2012 11:32 PM, Marc MERLIN wrote:
> > >Actually I had one more question.
> > >
> > >I read this page:
> > >http://www.redhat.com/archives/dm-devel/2011-July/msg00042.html
> > >
> > >I'm not super clear if with 3.2.5 kernel, I need to pass the speci=
al
> > >allow_discards option for brtfs and dm-crypt to be safe together, =
or
> > >whether
> > >they now talk through an API and everything "just works" :)
> >=20
> > If you want discards to be supported in dmcrypt, you have to enable
> > it manually.
> >=20
> > The most comfortable way is just use recent cryptsetup and add
> > --allow-discards option to luksOpen command.
> >=20
> > It will be never enabled by default in dmcrypt for security reasons
> > http://asalor.blogspot.com/2011/08/trim-dm-crypt-problems.html
>=20
> Thanks for the answer.
> I knew that it created some security problems but I had not yet found
> the page you just gave, which effectively states that TRIM isn't
> actually that big a win on recent SSDs (I thought it was actually
> pretty important to use it on them until now).

Well I find

"On the other side, TRIM is usually overrated. Drive itself should keep=
=20
good performance even without TRIM, either by using internal garbage=20
collecting process or by some area reserved for optimal writes handling=
=2E"

a very, very weak statement on the matter, cause it lacks any links to =
any=20
evidence for the statement made. For that I meant to knew up to know is=
=20
that wear leaveling of the SSD can be more effective the more space the=
 SSD=20
controller/firmware can use for wear leveling freely. Thus when I give=20
space back to the SSD via fstrim it has more space for wear leveling wh=
ich=20
should lead to more evenly distributed write pattterns and more evenly=20
distributed write accesses to flash cells and thus a longer life time. =
I do=20
not see any other means on how the SSD drive can do that data has been=20
freed again except for it being overwritten, then the old write locatio=
n=20
can be freed of course. But then BTRFS does COW and thus when I underst=
and=20
this correctly, the SSD wouldn=B4t even be told when a file is overwrit=
ten,=20
cause actually it isn=B4t, but is written to a new location. Thus espec=
ially=20
for BTRFS I see even more reasons to use fstrim.

I have no scientifical backing either, but at least I tried to think of=
 an=20
explaination that appears logical to me instead of just saying it is so=
=20
without providing any explaination at all. Yes, I dislike bold statemen=
ts=20
without any backing at all. (If I overread something in the text, pleas=
e=20
hint me to it, but I did not see any explaination or link to support th=
e=20
statement.)

I use ecryptfs and I use fstrim occassionally with BTRFS and Ext4, but =
I=20
do not use online discard.

Thanks,
--=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
