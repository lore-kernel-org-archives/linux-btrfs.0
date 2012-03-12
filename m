From: Fong Vang <sudoyang@gmail.com>
Subject: immutable (WORM) file system
Date: Mon, 12 Mar 2012 12:36:13 -0700
Message-ID: <CAP7LQsLiDC8Y=g+ocQGYdC-4LdpDWs9QkL+PvMD311wR2UY0GQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Does anyone know if there's a plan to provide an option to make a
BTRFS filesystem a WORM (write-one-read-many)? =A0So essentially, once =
a
file has been written it cannot be altered nor deleted. =A0To delete
would require a newfs. =A0I know that there's extended attributes but
root can alter that on individual files.

Anyway, thanks in advance for any help.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
