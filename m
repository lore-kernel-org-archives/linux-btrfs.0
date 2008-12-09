From: jim owens <jowens@hp.com>
Subject: Re: Selective Compression/Encryption
Date: Tue, 09 Dec 2008 18:50:19 -0500
Message-ID: <493F043B.50804@hp.com>
References: <20081209145952.GA30494@tux64-03>	<f058a9c30812090745v15b5f983u468b560ae791dc37@mail.gmail.com>	<200812091722.21567.mail@earthworm.de>	<20081209180951.GA6551@tux64-03> <20081210000512.7be20413@diego-desktop>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Cc: Lee Trager <lt73@cs.drexel.edu>,
	Christian Hesse <mail@earthworm.de>, miguel.filipe@gmail.com,
	linux-btrfs@vger.kernel.org
To: Diego Calleja <diegocg@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20081210000512.7be20413@diego-desktop>
List-ID: <linux-btrfs.vger.kernel.org>

Diego Calleja wrote:
> El Tue, 9 Dec 2008 13:09:51 -0500, "Lee Trager" <lt73@cs.drexel.edu> =
escribi=C3=B3:
>=20
>> It does seem that doing it with volumes would limit user control and=
 add
>> lots of complexity to such a simple task.
>=20
> IMHO, WRT compression it's the contrary. Compression on a per-file ba=
sis has
> never been very succesful (just look at how many windows users use it=
)
> because it implies taking a decision for every file on the system. OT=
OH,
> volume-level is just a single option to be enabled.
>=20
> I'm of course not arguing that file-level compression shouldn't be po=
ssible,
> im just saying that is way more difficult to administer and that most=
 people
> (including sysadmins) is most likely to use compression in a per-volu=
me basis.

While I have not gotten far enough to prove it is feasible...

My idea on controlling features like compression is that
the default mode is inherited from the parent in the
directory tree.  Thus you can turn it on/off at whatever
granularity you want.

jim
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
