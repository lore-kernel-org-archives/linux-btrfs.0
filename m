From: "kreijack@libero.it" <kreijack@libero.it>
Subject: R: Re: mount command not honoring rootflags passed
Date: Fri, 22 Jan 2010 13:37:48 +0100 (CET)
Message-ID: <16366420.67811264163868365.JavaMail.defaultUser@defaultHost>
Reply-To: "kreijack@libero.it" <kreijack@libero.it>
Mime-Version: 1.0
Content-Type: text/plain;charset="UTF-8"
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>,
	Leszek Ciesielski <skolima@gmail.com>
To: <thomas@kupper.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi Thomas,

>----Messaggio originale----
>Da: thomas@kupper.org
>Data: 22/01/2010 10.48
>A: "Leszek Ciesielski"<skolima@gmail.com>
>Cc: "linux-btrfs"<linux-btrfs@vger.kernel.org>
>Ogg: Re: mount command not honoring rootflags passed
>
>
>On 22 Jan 2010, at 10:40, Leszek Ciesielski wrote:
>
>> On Fri, Jan 22, 2010 at 10:30 AM, Thomas Kupper <thomas@kupper.org> wrote:
[...]
>> Doesn't 'cat /proc/mounts' show the actually used mount options?
>
>No, it doesn't in my case - Ubuntu 9.10 with 2.6.32-10-generic kernel.
>
>thomas # cat /proc/mounts | fgrep ' / '
>rootfs / rootfs rw 0 0
>/dev/sda3 / btrfs rw,relatime 0 0
>
>thomas # cat /proc/cmdline
>[...] root=/dev/sda3 ro rootflags=subvol=rootfs-snapshot-001--
>To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html


The btrfs code doesn't show the subvol= mount option in cat /proc/mount. I 
sent a patch which should solve it.

http://article.gmane.org/gmane.comp.file-systems.btrfs/4487

But today it is not merged.

Br
Goffredo


