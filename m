From: David Nicol <davidnicol@gmail.com>
Subject: revisiting "Hard link across subvolumes"
Date: Sat, 9 Oct 2010 02:52:07 -0500
Message-ID: <AANLkTim28O+6b86Cuoxgt5sht6KK2Xq=iwMNp46X1ceL@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: kreijack@libero.it
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

could i-node numbers be made unique on a whole device, or somehow
adjusted to avoid collisions, instead of simply disallowing this
useful operation?

On Thu, Oct 7, 2010 at 4:13 PM, Goffredo Baroncelli <kreijack@libero.it=
> wrote:

> The link across subvolumes is not allowable. =C2=A0In the beginning i=
t was
> possible, but that was source of bugs. See the thread "Hard link acro=
ss
> subvolumes"
>
> http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg03286.html
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
