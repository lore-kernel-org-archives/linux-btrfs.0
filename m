From: cwillu <cwillu@cwillu.com>
Subject: Re: subvolume nomenclature
Date: Fri, 2 Mar 2012 07:36:42 -0600
Message-ID: <CAE5mzvhsb+O6xEvpOW5nh7iLgk5M+mgFD_ASVCpM0P==LSANqQ@mail.gmail.com>
References: <jiqi3l$d4k$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: "Brian J. Murrell" <brian@interlinx.bc.ca>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <jiqi3l$d4k$1@dough.gmane.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Mar 2, 2012 at 7:31 AM, Brian J. Murrell <brian@interlinx.bc.ca=
> wrote:
> I seem to have the following subvolumes of my filesystem:
>
> # btrfs sub li /
> ID 256 top level 5 path @
> ID 257 top level 5 path @home
> ID 258 top level 5 path @/etc/apt/oneiric
>
> I *think* the last one is there due to a:
>
> # btrfsctl -s oneiric /
>
> that I did prior to doing an upgrade. =C2=A0I can't seem to figure ou=
t the
> nomenclature to delete it though:
>
> # btrfs sub de /@/etc/apt/oneiric

Try btrfs sub delete /etc/apt/oneiric, assuming that that's the path
where you actually see it.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
