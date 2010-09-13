From: Goffredo Baroncelli <kreijack@gmail.com>
Subject: Re: reserving an IOCTL number; other details
Date: Mon, 13 Sep 2010 19:23:52 +0200
Message-ID: <201009131923.53227.kreijack@libero.it>
References: <AANLkTi=GzqHy5h2gAmkQSSMQOCaYza=yTtWZrcyd8RSC@mail.gmail.com> <AANLkTinWg7o3KwDS9vHKpZV0mUyk6xKsuFvwVUjiynPk@mail.gmail.com>
Reply-To: kreijack@libero.it
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Cc: linux-btrfs@vger.kernel.org
To: David Nicol <davidnicol@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTinWg7o3KwDS9vHKpZV0mUyk6xKsuFvwVUjiynPk@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hi David,

please don't do that. "btrfsctl" is obsolete, now the develop should involve 
the "btrfs" command.
I you need help in updating the "btrfs" command source files, don't hesitate 
to contact me.

Regards
G.Baroncelli

On Monday, 13 September, 2010, David Nicol wrote:
> this I can release, the user-facing API.
> 
> 
> diff --git a/man/btrfsctl.8.in b/man/btrfsctl.8.in
> index c2d4488..94403a4 100644
> --- a/man/btrfsctl.8.in
> +++ b/man/btrfsctl.8.in
> @@ -35,6 +35,10 @@ Scans all devices present in the system for btrfs 
filesystem.
>  .TP
>  \fB\-c\fR
>  Forces a filesystem sync.
> +.TP
> +\fB\-C\fR \fIdirectory [ms]\fR
> +Wait until all the space from all deleted snapshots have been recovered.
> +The optional timeout parameter is in milliseconds.
>  .SH AVAILABILITY
>  .B btrfsctl
>  is part of btrfs-progs. Btrfs is currently under heavy development,
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


-- 
gpg key@ keyserver.linux.it: Goffredo Baroncelli (ghigo) <kreijack@inwind.it>
Key fingerprint = 4769 7E51 5293 D36C 814E  C054 BF04 F161 3DC5 0512
