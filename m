From: Jon Nelson <jnelson@jamponi.net>
Subject: Re: hunt for 2.6.37 dm-crypt+ext4 corruption? (was: Re: dm-crypt
 barrier support is effective)
Date: Mon, 13 Dec 2010 12:56:59 -0600
Message-ID: <AANLkTinMWS-yyzWJ3oBo_KS9jXt4p4pveo+SPTLiWnCt__23559.3124678873$1292266681$gmane$org@mail.gmail.com>
References: <20101210023852.GB3059@thunk.org> <AANLkTikJ1Q=L15wcMLn=U8-Qx9PbppY-AX=LpmjDkk2V@mail.gmail.com>
 <AANLkTikeiv2jQM5hhghs1Zd2d=5CbRLKMgYvqHqpm76m@mail.gmail.com>
 <AANLkTinMt6saGeeX3MbwAzZ-+f6AL5BegeFqyPgGwiDo@mail.gmail.com>
 <AANLkTi=cn04WZGMnVX6ie5PSM+9v0tJSSg0kD8_W5N11@mail.gmail.com>
 <20101212023415.GG3059@thunk.org> <AANLkTim=i8wDnML+K4uGK_neNDCiWxtKGDx01O+3joaE@mail.gmail.com>
 <AANLkTinhHTqqpP=pQ8Foyc9xeaZi65GHGHGY51OyZtvF@mail.gmail.com>
 <20101212124354.GA4513@thunk.org> <AANLkTikZkCs7Wee2=uhe3bw96Pggcv0jsCkZ+nkWEQ+=@mail.gmail.com>
 <20101213020657.GB4513@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: "Ted Ts'o" <tytso@mit.edu>, Jon Nelson <jnelson@jamponi.net>,
	Matt <jackdachef@gmail.com>,
	Chris Mason <chris.mason@oracle.com>,
	Andi Kleen <andi@firstfloor.org>,
	Mike Snitzer <snitz
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20101213020657.GB4513@thunk.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Dec 12, 2010 at 8:06 PM, Ted Ts'o <tytso@mit.edu> wrote:
> On Sun, Dec 12, 2010 at 07:11:28AM -0600, Jon Nelson wrote:
>> I'm glad you've been able to reproduce the problem! If you should ne=
ed
>> any further assistance, please do not hesitate to ask.
>
> This patch seems to fix the problem for me. =C2=A0(Unless the partiti=
on is
> mounted with mblk_io_submit.)
>
> Could you confirm that it fixes it for you as well?

I believe I have applied the (relevant) inode.c changes to
bd2d0210cf22f2bd0cef72eb97cf94fc7d31d8cc, rebuilt and begun testing.
Now at 28 passes without error, I think I can say that the patch
appears to resolve the issue.

--=20
Jon
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
