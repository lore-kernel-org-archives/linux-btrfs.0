From: =?UTF-8?B?U8OpYmFzdGllbiBXYWNxdWlleg==?= <sw@enix.org>
Subject: Re: Using SSDs for caching?
Date: Fri, 19 Jun 2009 08:57:12 +0200
Message-ID: <4A3B36C8.2070500@enix.org>
References: <D3FA806D-C1A1-455F-A4E0-81AAD3E5C615@karlsbakk.net> <20090618155530.GA16819@mother.pipebreaker.pl>
Reply-To: sw@enix.org
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090618155530.GA16819@mother.pipebreaker.pl>
List-ID: <linux-btrfs.vger.kernel.org>

Tomasz Torcz a =C3=A9crit :
>   Linux already has second-level=C2=B9 cache layer, it called FS-Cach=
e. For now,
> the sole user is NFS. btrfs could take advantage of FS-Cache also.
>
> =C2=B9 first-level is page cache in RAM
>  =20

=46S-Cache is a good thing to speedup your network filesystem, but to b=
e=20
efficient localy, IMHO, the second-level cache shoud be at the block le=
vel.

So it should go directly in btrfs or in something like the device mappe=
r ...



S=C3=A9bastien Wacquiez
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
