From: Daniel J Blueman <daniel.blueman@gmail.com>
Subject: Re: Kernel 2.6.36 btrfs csum bugreport
Date: Mon, 1 Nov 2010 10:55:22 +0000
Message-ID: <AANLkTim3QfhFVvPaiKMSJPSjuRhG89=+DH63NsJf+SfH@mail.gmail.com>
References: <vmime.4cce0b42.4e03.7a6f42ce1e8ae262@mail.voltage.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: cwillu <cwillu@cwillu.com>, linux-btrfs@vger.kernel.org
To: Andreas Bauer <ab@voltage.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <vmime.4cce0b42.4e03.7a6f42ce1e8ae262@mail.voltage.de>
List-ID: <linux-btrfs.vger.kernel.org>

On 1 November 2010 00:35, Andreas Bauer <ab@voltage.de> wrote:
> So I conclude that these messages are faulty because data is read cor=
rectly.
> =A0In addition, when you have more than one btrfs you cannot see from=
 the message
> =A0which fs it is refering to.
>
> =A0Is this a raid1 or a dup array?
>
> No, plain vanilla partition on physical hard disk. Btrfs was made wit=
h the command "mkfs.btrfs /dev/sdc1" no extra arguments.

By default, metadata is duplicated, thus it could be that BTRFS is
using the correct copy of the metadata after finding checksum errors
in the first copy.

Daniel
--=20
Daniel J Blueman
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
