From: Konstantinos Skarlatos <k.skarlatos@gmail.com>
Subject: Re: slow deletion of files
Date: Sun, 11 Jul 2010 23:20:48 +0300
Message-ID: <4C3A27A0.6090907@gmail.com>
References: <i1cm80$901$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Cc: linux-btrfs@vger.kernel.org
To: Lubos Kolouch <lubos.kolouch@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <i1cm80$901$1@dough.gmane.org>
List-ID: <linux-btrfs.vger.kernel.org>

  I have the same problem too, in general file deletion is very slow on=
=20
btrfs (at least for me).

On 11/7/2010 5:59 =CE=BC=CE=BC, Lubos Kolouch wrote:
> Hello,
>
> during my testing of btrfs I found out,
> that deletion of directory with many files (many millions) takes veee=
ery
> long (it is running two weeks now and did not finish).
>
> But when instead of directory I create subvolume, it is deleted insta=
ntly.
>
> Is it normal behaviour? (gentoo 2.6.34-r1, btrfs-progs-9999).
> Why the directory cannot be deleted instantly as well?
>
> Thank you
>
> Lubos
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs=
" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
