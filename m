From: Leonidas Spyropoulos <artafinde@gmail.com>
Subject: Re: 'ioctl:: Inappropriate ioctl for device' when trying to shrink partition
Date: Wed, 12 Jan 2011 19:48:04 +0000
Message-ID: <AANLkTi=Jn8-7AD8fcX4cyJUC32YQP2-CE8J_cTxnOuOC@mail.gmail.com>
References: <1294857915.7377.14.camel@develog-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Mikael Andersson <mikael@develog.se>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1294857915.7377.14.camel@develog-laptop>
List-ID: <linux-btrfs.vger.kernel.org>

On 12 January 2011 18:45, Mikael Andersson <mikael@develog.se> wrote:
> E.g. btrfsctl -r -4000m /dev/sda5
>
Hey Mikael,

btrfsctl is deprecated, you should use btrfs
In the previous example:
btrfs filesystem resize -4000m /dev/sda5

Check the help of btrfs

And also good to download latest btrfs-progs from git and compile them
yourself the version of btrfs-progs on LiveCD is old.


Latest version I use for example is: v0.19-35-g1b444cd


> results in:
> ioctl:: Inappropriate ioctl for device
>
> Distribution: Ubuntu 10.10
> Kernel: 2.6.35-22-generic
>
> According to the Synaptic Package manager, the version of btrfs-tools=
 is
> 0.19+20100601-3
>
> Other information that can be of interest:
> - I started Ubuntu on a live CD
> - before invoking the btrfsctl command I invoked apt-get update.
>
> I have googled but have not found anything that seems to help me.
>
> I have searched for "resize" on the following pages but have not find
> anything:
> https://btrfs.wiki.kernel.org/index.php/Problem_FAQ
> https://btrfs.wiki.kernel.org/index.php/Gotchas
>
> Thanks,
>
> Mikael
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs=
" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>



--=20
Caution: breathing may be hazardous to your health.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
