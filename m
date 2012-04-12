From: Marco Stornelli <marco.stornelli@gmail.com>
Subject: Re: [PATCH] fs: make i_generation a u64
Date: Thu, 12 Apr 2012 08:46:14 +0200
Message-ID: <CANGUGtBHNHE0=GQg-Hv1YUaYNhpt9F5-9qt+_UQ6fkCL__gxaQ@mail.gmail.com>
References: <1334176968-8687-1-git-send-email-josef@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	viro@zeniv.linux.org.uk
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1334176968-8687-1-git-send-email-josef@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

2012/4/11 Josef Bacik <josef@redhat.com>:
> Btrfs stores generation numbers as 64bit numbers, which means we have=
 to
> carry around a u64 in our incore inode in addition to setting i_gener=
ation.
> So convert to a u64 so btrfs can kill it's incore generation. =A0Than=
ks,
>
> Signed-off-by: Josef Bacik <josef@redhat.com>
> ---
> =A0include/linux/fs.h | =A0 =A02 +-
> =A01 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 9be896d..40564e0 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -831,7 +831,7 @@ struct inode {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct cdev =A0 =A0 =A0 =A0 =A0 =A0 *i=
_cdev;
> =A0 =A0 =A0 =A0};
>
> - =A0 =A0 =A0 __u32 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 i_generation;
> + =A0 =A0 =A0 u64 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 i_generatio=
n;
>
> =A0#ifdef CONFIG_FSNOTIFY
> =A0 =A0 =A0 =A0__u32 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 i_fsnotify_m=
ask; /* all events this inode cares about */
> --
> 1.7.7.6

This patch can have several impact on other fs. Only to do an example
you can see the code in ioctl of ext4. I haven't got study the code
but the ioctl returns a long, but on 32bit system, long means 4 bytes,
so how we can return i_generation with ioctl?

Marco
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
