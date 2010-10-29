From: =?UTF-8?B?Q2zDoXVkaW8=?= Martins <ctpm@ist.utl.pt>
Subject: Re: [PATCH] Btrfs-progs: add support for mixed data+metadata block
 groups V3
Date: Fri, 29 Oct 2010 01:20:13 +0100
Message-ID: <20101029012013.68a18b8a.ctpm@ist.utl.pt>
References: <1288204654-2127-1-git-send-email-josef@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1288204654-2127-1-git-send-email-josef@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>


On Wed, 27 Oct 2010 14:37:34 -0400 Josef Bacik <josef@redhat.com> wrote=
:
> So alot of crazy people (I'm looking at you Meego) want to use btrfs =
on phones
> and such with small devices.  Unfortunately the way we split out meta=
data/data
> chunks it makes space usage inefficient for volumes that are smaller =
than
> 1gigabyte.  So add a -M option for mixing metadata+data, and default =
to this
> mixed mode if the filesystem is less than or equal to 1 gigabyte.  I'=
ve tested
> this with xfstests on a 100mb filesystem and everything is a-ok.
>=20

 Hi,

 Could you provide some rationale as to why btrfs should support these
two modes of data/metadata (mixed and separate) allocation instead of
just always doing mixed data+metadata?

 The reason I'm asking this is that having two separate modes implies
having more codepaths in the kernel, which naturally adds complexity to
the filesystem and also more code to test, two things that should be
avoided, if possible. I'd love if you could add a small explanation to
your patch description (or a comment in the code) about why it is
useful to keep the default mode of allocation, instead of simply
droping it and doing mixed allocation in all cases.

 Thanks in advance.

Best regards

Cl=C3=A1udio

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
