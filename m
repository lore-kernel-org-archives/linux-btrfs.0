From: Gregory Maxwell <gmaxwell@gmail.com>
Subject: Re: RAID[56] status
Date: Tue, 10 Nov 2009 16:20:43 -0500
Message-ID: <e692861c0911101320k420fba21q8d7d861eced6267@mail.gmail.com>
References: <1249553833.568.23.camel@macbook.infradead.org>
	 <e9c3a7c20911101151q2d85237cyecdd7d292d21552d@mail.gmail.com>
	 <84fb38e30911101306p30633135tdbec8c282692b3f4@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Dan Williams <dan.j.williams@intel.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: tsuraan <tsuraan@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <84fb38e30911101306p30633135tdbec8c282692b3f4@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Nov 10, 2009 at 4:06 PM, tsuraan <tsuraan@gmail.com> wrote:
>> 3/ The md-raid6 recovery code assumes that there is always at least
>> two good blocks to perform recovery. =C2=A0That makes the current mi=
nimum
>> number of raid6 members 4, not 3. =C2=A0(small nit the btrfs code ca=
lls
>> members 'stripes', in md a stripe of data is a collection of blocks
>> from all members).
>
> Why would you use RAID6 on three drives instead of mirroring across
> all of them? =C2=A0I agree it's an artificial limitation, but would a=
nybody
> use a RAID6 with fewer than 4 drives?

Here is some text I wrote on a local linux-users-group list a few month=
s ago, on
a thread talking about cost/reliability trade-off on small arrays.
(it doesn't seem to be in a public archive)


Lets also consider another configuration:
Raid  0:  4 * 1TB WD RE3s =3D $640; 4TB; $0.160/GB

WD1002FBYS (1TB WD RE3) has a spec MTBF of 1.2 million hours. Lets
assume a mean time to replace for each drive of 72 hours, I think
thats a reasonably prompt response for a disk at home.

Raid 0
1.2million hours/4 =3D 34.22313483 yrs MTBF
$4.675/TB/MTBF_YEAR

Raid 5
1.2million_hrs * (1.2million_hrs/(4*3*72)) =3D 190,128 yrs MTBF
$0.00112/TB/MTBF_YEAR

Raid 0+1
(1.2million_hrs * 1.2million_hrs / (2 * 72))/2 =3D 570,386 yrs MTBF
$.00056102/TB/MTBF_YEAR

Raid 6
1.2million_hrs*1.2million_hrs*1.2million_hrs/(4*3*2*72*72) =3D
1,584,404,390 yrs MTBF
$0.00000020/TB/MTBF_YEAR
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
