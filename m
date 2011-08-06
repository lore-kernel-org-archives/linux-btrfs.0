From: Dan <hpram99@gmail.com>
Subject: Remove Missing Device from Raid1 error
Date: Sat, 6 Aug 2011 15:50:31 -0500
Message-ID: <CAHikFtZUgZdCBfwqtBkbZGnW1dR99NPHtOTs0kxpvjL+SccS4g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

4 identical devices, raid 1.
Ubuntu 11.10 Alpha 3

I've physically unplugged TWO (alternating) devices.
mounted as degraded, filesystem works great.

Run the command =C2=A0"btrfs dev del missing /mnt"
Response:
ERROR: error removing the device 'missing'
No error in dmesg

"btrfs-vol -r missing /mnt"
Response:
removing missing devices from /home
ioctl returns -1
Still nothing in logs.

The latest Ubuntu alpha uses the 3.0 kernel, but am I still missing
something? do I need newer btrfs-tools? =C2=A0Or is this=C2=A0legitimat=
ely=C2=A0an
issue?
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
