Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f42.google.com ([209.85.215.42]:42448 "EHLO
        mail-lf0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751072AbdLNHDW (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 14 Dec 2017 02:03:22 -0500
Received: by mail-lf0-f42.google.com with SMTP id i2so5396718lfe.9
        for <linux-btrfs@vger.kernel.org>; Wed, 13 Dec 2017 23:03:21 -0800 (PST)
Message-ID: <5A32223C.2020408@gmail.com>
Date: Thu, 14 Dec 2017 08:03:24 +0100
From: ein <ein.net@gmail.com>
MIME-Version: 1.0
To: service@automatix.de, linux-btrfs@vger.kernel.org
Subject: Re: OFF-By-One Trouble? [BTRFS in Debian Stretch Kernel 4.9.0-4-amd64]
References: <3bd97912-4561-9b75-8fd7-98bc52ddcbc2@automatix.de>
In-Reply-To: <3bd97912-4561-9b75-8fd7-98bc52ddcbc2@automatix.de>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA256

On 12/12/2017 11:22 AM, Juergen Sauer wrote:
> Hi collegues,

Hello.

> 
> this morning we've got a problm with btrfs in Debian Stable.
> 
> Yesterday we had our fs filled below 30% space usage. No further 
> usage came in the usage is nearly the same, but ...
> 
> # df -h . Dateisystem    Größe Benutzt Verf. Verw% Eingehängt auf 
> /dev/vdb1      483G    483G  148K  100% /mnt
> 
> # btrfs fi df . Data, single: total=480.97GiB, used=480.97GiB 
> System, single: total=32.00MiB, used=96.00KiB Metadata, single: 
> total=2.00GiB, used=1.29GiB GlobalReserve, single:
> total=512.00MiB, used=0.00B
> 
> # btrfs fi show . Label: 'AXSDaten'  uuid: 
> fde7e31f-4127-4a9d-b7c6-774ceff8f7c1 Total devices 1 FS bytes used 
> 482.26GiB devid    1 size 483.00GiB used 483.00GiB path /dev/vdb1
> 
> # btrfs --version btrfs-progs v4.7.3
> 
> we found exerpt of kernel log: [  199.391577] attempt to access 
> beyond end of device [  199.391598] vdb1: rw=536870984, 
> want=1012922336, limit=1012922335 [  199.391615] BTRFS error 
> (device vdb1): bdev /dev/vdb1 errs: wr 301, rd 0, flush 0, corrupt 
> 0, gen 0 r If I interpret the log right, on the FS the kernel
> wants to write on block  1012922336, but the fs was created with
> max 1012922335 blocks.
> 
> Looks to us here like a typical off-by-one error on accessing the 
> last block of device.

Or user error, or HW problems, I use Debian 9 in production and I
completed multiple BTRFS resizes with success. The only one difference I
see for now is:
server #1:
root@node0:~# uname -a; btrfs
- --version



Linux node0 4.12.0-0.bpo.2-amd64 #1 SMP Debian 4.12.13-1~bpo9+1
(2017-09-28) x86_64
GNU/Linux


btrfs-progs v4.13.3

server #2:
root@node0.intranet.xxx.pl:~# uname -a; btrfs --version
Linux node0.intranet.xxx.pl 4.12.0-0.bpo.2-amd64 #1 SMP Debian
4.12.13-1~bpo9+1 (2017-09-28) x86_64 GNU/Linux
btrfs-progs v4.13.3

Both kernels and btrfs-progs were from backports.

> This error was repeating under ff. conditions: - shutdown the 
> virtual server (kvm), - extend the physical file of the according 
> virtual hdd by 20% (from 483 Gib to 520 GiB)

Extend exactly how?

> - restart virtual server - fixed partion size (parted), mounted - 
> called btrfs fi resize max on the corresponding mount point
> 
> Error came back, nearly at once.
> 
> Any other Idea to fix this error?
> 
> mit freundlichen Grüßen Jürgen Sauer
> 
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJaMiI8AAoJEHr/aeHyxuoQ8fAQAJyPSI0t+JTR7s1ve+cbQepi
9zOifU0OgFd/GLQYiqcSBiZf8Rz619PLf3yW/oN7pBjiBW393sPTu2PbWIRZmtBW
uOhxFr+IQyjYWTwCfM4CLTMdXn73WXA9AgBA2BquWeM0HDzZrjh+lDoNyYdu2eNP
zhwhgk3o+qC931d67B48tPN6q5kL3VVG0bLspG4SDoaEeV6PHRUgfIYjMEhWf49p
jdkKm3FfI7WcAw9w0+5zKxZ8ujhJIlLAJEYw6AgYOhukmLFPXOO/CJPjs4aGiEXb
NI3k9Oql2fkRa9/u2n/RPpmAqQAzS8nWMhM5JB7B0/mYUid99QbPUXQiZ9LVLBne
UiHPBRyOQcZTKGbjrXPOfzsrSvlxoZs+xNLc7dyJBgfbFmoXjcEoHV6+Blow+kqA
34bZ5rGq907LvbQcQaDjoLdWLXlgm1/5J5rhhgd9dFRAcCYWzYOWuZMVXBjAmCNf
Xclvjp3Jp7ObsTsUy+ZgVKw5wwQEAtlFMA7bV6zzlyMVnC6k9XlMcSwKg1ySg/Vv
cIoZukCeqOOVrFxjzw++ntpI1v1KgT3DHt4Wiyum93eu9VKyYSVKUIuFOjCltqDJ
yxhMv8LjGcsdL8vVAsVSDvVwx2entYwDM2Wlx7JoEGI1n4GN7LufrttdfsulL8xZ
M+1DH/2421Lhy/9kQUiG
=44JM
-----END PGP SIGNATURE-----
