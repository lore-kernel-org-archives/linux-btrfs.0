From: =?ISO-8859-1?Q?J=E9r=F4me_Poulin?= <jeromepoulin@gmail.com>
Subject: Re: File cloning across subvolumes with BTRFS_IOC_CLONE ioctl
Date: Wed, 21 Jul 2010 11:11:13 -0400
Message-ID: <AANLkTil_bqyOwBIlkdZGyn1HAVKBMuEu4cem2UAhei3A@mail.gmail.com>
References: <20100720053934.GA14402@epicurus>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: redneb <redneb@gmx.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100720053934.GA14402@epicurus>
List-ID: <linux-btrfs.vger.kernel.org>

I've got the same problem, and that post clearly seems to say it is pos=
sible.
cp --reflink=3Dalways source subvolume1/   gives me:
cp: failed to clone `xxxx': Invalid cross-device link

Even on the same subvolume I get 10% of the files telling me the same.

btrfs-bcp copy the files in its integrity.


On Tue, Jul 20, 2010 at 1:39 AM,  <redneb@gmx.com> wrote:
> It seems that the BTRFS_IOC_CLONE ioctl fails when trying to do a
> cross-subvolume clone of a file. Chris Mason suggested in the past ([=
1])
> that this should be possible. Am I missing something?
>
> [1] http://kerneltrap.org/mailarchive/linux-btrfs/2010/6/10/6884911
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs=
" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
