From: Mike Fedyk <mfedyk@mikefedyk.com>
Subject: Re: help message of btrfsctl does not tell anything about deletion of
	a subvolume
Date: Sat, 15 May 2010 15:42:58 -0700
Message-ID: <AANLkTilPrTJkoa0KHVrGCLQE_RZP_IAuMqm_DrCeGfl9@mail.gmail.com>
References: <4BEEEC28.7020100@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Andreas Philipp <philipp.andreas@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4BEEEC28.7020100@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, May 15, 2010 at 11:47 AM, Andreas Philipp
<philipp.andreas@gmail.com> wrote:
> Hi,
>
> The help message of the btrfsctl command does not tell anything about
> the deletion of a subvolume. See patch below.
>
> Kind regards,
> Andreas
>
> diff --git a/btrfsctl.c b/btrfsctl.c
> index be6bf25..3ed6f2d 100644
> --- a/btrfsctl.c
> +++ b/btrfsctl.c
> @@ -56,7 +56,7 @@ static void print_usage(void)
> =C2=A0 =C2=A0 printf("\t-A device: scans the device file for a Btrfs =
filesystem\n");
> =C2=A0 =C2=A0 printf("\t-a: scans all devices for Btrfs filesystems\n=
");
> =C2=A0 =C2=A0 printf("\t-c: forces a single FS sync\n");
> - =C2=A0 =C2=A0printf("\t-D: delete snapshot\n");
> + =C2=A0 =C2=A0printf("\t-D: delete snapshot or subvolume\n");
> =C2=A0 =C2=A0 printf("\t-m [tree id] directory: set the default mount=
ed subvolume"
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0" to the [tree id] or the di=
rectory\n");
> =C2=A0 =C2=A0 printf("%s\n", BTRFS_BUILD_VERSION);
>

We have a new command "btrfs subvolume delete <path>" which can be
shortened even as far as "btrfs s d <path>".

Are we going to keep the btrfsctl program indefinitely when we have a
replacement in the "btrfs" program?
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
