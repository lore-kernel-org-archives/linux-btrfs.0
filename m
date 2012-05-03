From: Chu Duc Minh <chu.ducminh@gmail.com>
Subject: How file store when using Btrfs on multi-devices? What happen when a
 device fail?
Date: Thu, 3 May 2012 13:46:17 +0700
Message-ID: <CAGP-ymNoE1CtSTdYXJMgQ0k2HmRmDxq=zSxNE7pGonoTzrkNHw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi, i have some questions when using Btrfs on multi-devices:
1. a large file will always be stored wholely on a device or it may
spread on some devices/partitions? Btrfs has option to specify it
explicitly?
2. suppose i have a directory tree like that:
Dir_1
=A0|--> file_1A
=A0|--> file_1B
=A0|--> Dir_2
=A0=A0=A0=A0=A0=A0=A0=A0 |--> file_2C
=A0=A0=A0=A0=A0=A0=A0=A0 |--> file_2D

If Dir_2, file_2C=A0 on a failed device, can i still have access to fil=
e_2D?
If i use GlusterFS (mirror mode) on two nodes, each nodes run Btrfs on
multi-device. When a device on a node fail and I replace it, then
GlusterFS resync it, can i have troubles with data consistency?

Thanks in advance!
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
