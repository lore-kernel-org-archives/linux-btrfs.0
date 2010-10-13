From: David Nicol <davidnicol@gmail.com>
Subject: Re: PATCH: IOCTL#21 progs, including -dq OPTIONS FOR btrfs fi sy
Date: Wed, 13 Oct 2010 10:04:42 -0500
Message-ID: <AANLkTikK3Qa2tdFDh_-_1BjEnnyQ5NAi0tJ3L7Pmt6r8@mail.gmail.com>
References: <AANLkTimoVcjZAhEMRX7FgNZJ36xMhbR39Vyi28Ang84a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: BTRFS MAILING LIST <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTimoVcjZAhEMRX7FgNZJ36xMhbR39Vyi28Ang84a@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Drat, I left in a file descriptor leak. Is anyone trying this stuff?

On Wed, Oct 13, 2010 at 9:37 AM, David Nicol <davidnicol@gmail.com> wro=
te:
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0res =3D ioctl(fd, BTRFS_IOC_SYNC);
> - =C2=A0 =C2=A0 =C2=A0 close(fd);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0if( res < 0 ){
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
