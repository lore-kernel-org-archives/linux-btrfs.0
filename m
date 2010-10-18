From: =?ISO-8859-1?Q?Fabr=EDcio_dos_Anjos_Silva?=
	<fabricio.silva@linkcom.com.br>
Subject: FS consistency while snapshoting
Date: Sun, 17 Oct 2010 23:47:18 -0300
Message-ID: <AANLkTimx1ZyVhX-_jy3i6uQxTPHtm-XEpVZKv7ZxB+0T@mail.gmail.com>
References: <AANLkTin6V=R0UZWfymTKGwwKBwb+tXBsHkbMEo3mcY_L@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTin6V=R0UZWfymTKGwwKBwb+tXBsHkbMEo3mcY_L@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

  Hi,

  I want to use AWS EC2 EBS snapshot capability and while doing this,
I want to make sure that Btrfs is consistent.

  I already know how to proceed when using XFS in the two scenarios tha=
t follow:

1) XFS on EBS
=46reeze XFS by using "xfs_freeze -f", then create EBS snapshot, then
unfreeze XFS by using "xfs_freeze -u".

2) XFS on LVM
XFS is automatically frozen/unfrozen when LVM snapshot is requested.

  What I don't know is how to proceed in the following scenarios:

3) Btrfs on EBS
What commands need to be executed to freeze/unfreeze Btrfs when
requesting EBS snapshot?

4) Btrfs on LVM
Is Btrfs automatically frozen/unfrozen when requesting LVM snapshot?

5) LVM on EBS
What command needs to be executed to freeze/unfreeze LVM? What about
the FS on top of LVM?

   I know that scenario 5 is not Btrfs related, but I appreciate if
someone could help me with that too. I also know that there is no need
to use Btrfs on LVM, but the question remains.

   If there is any difference betweens kernel 2.6.21 and 2.6.35,
please point it out.

   Thank you,

=46abr=EDcio dos Anjos Silva
LinkCom Solu=E7=F5es em T.I.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
