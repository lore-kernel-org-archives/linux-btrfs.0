From: Nirbheek Chauhan <nirbheek@gentoo.org>
Subject: Re: Applications using fsync cause hangs for several seconds every
 few minutes
Date: Thu, 21 Jul 2011 02:29:25 +0530
Message-ID: <CADqQcK7_p_H6ZYPJ4h5cDHunoCGRFTSQ6+zrKMQZ8mu8BpOuHw@mail.gmail.com>
References: <BANLkTimMv_MMVmsJeVvr_1_wEVam1WZ6BA@mail.gmail.com> <4E2478B1.60601@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E2478B1.60601@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jul 18, 2011 at 11:47 PM, Josef Bacik <josef@redhat.com> wrote:
> On 06/06/2011 06:58 PM, Nirbheek Chauhan wrote:
>> What can I do to debug this issue? What other information should I
>> supply? Could someone guide me on how to figure out why my machine i=
s
>> unusable now?
>
> I've been looking into this and I have a suspicion. =C2=A0Would you r=
un with this
> patch and see if the problem goes away? =C2=A0If so I'm on the right =
track
> and I'll
> have more test patches for you to try :). =C2=A0Thanks,
>

Hello!

Thanks for taking a look! I'm currently travelling and as soon as I
get a bit closer to my backups, I'll try the patch out and report back
for further testing :)

Cheers,

--=20
~Nirbheek Chauhan

Gentoo GNOME+Mozilla Team
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
