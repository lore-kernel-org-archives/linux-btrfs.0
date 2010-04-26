From: C Anthony Risinger <anthony@extof.me>
Subject: Re: list subvolumes with new btrfs command
Date: Mon, 26 Apr 2010 12:23:21 -0500
Message-ID: <p2qbe6460751004261023s24fe1f84xd80738387c1a3da8@mail.gmail.com>
References: <g2kbe6460751004251127tbdf980b6q867cf1b98fc562dc@mail.gmail.com>
	 <q2j9bd6b5361004251909j8dcf6ccbzd978d627e137fadb@mail.gmail.com>
	 <z2tbe6460751004251947ve533479ax174cc4f8bff50c01@mail.gmail.com>
	 <l2n9bd6b5361004252022wceaf4c6bj3d62a48f389331d2@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: sniper <s3c24xx@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <l2n9bd6b5361004252022wceaf4c6bj3d62a48f389331d2@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

> I am using ubuntu-10.04-rc with kernel compiled from the almost
> lastest source , the btrfs-progs is latest too.
>
> You can modify line
>
> =A0fprintf(stderr, "ERROR: can't perform the search\n");
> to
> =A0fprintf(stderr, "ERROR: can't perform the search: %s\n", strerror(=
errno));
>
> to see what happened on earth.

nice:

$ sudo btrfs subvolume list /
ERROR: can't perform the search: Inappropriate ioctl for device

i'm not really familiar with C, or anything this low level, does this
help you diagnose my problem?

thanks again for the help thus far,
C Anthony
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
