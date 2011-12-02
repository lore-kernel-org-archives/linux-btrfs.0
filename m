From: Mike Thomas <btrfs@thomii.com>
Subject: btrfs errors
Date: Fri, 2 Dec 2011 07:34:24 -0500
Message-ID: <000501ccb0ee$b92cd590$2b8680b0$@thomii.com>
References: <AFB7E63B2FEE4449B3DBF47BC3AA36F085956971@server2k8.thomii.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
To: <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AFB7E63B2FEE4449B3DBF47BC3AA36F085956971@server2k8.thomii.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hi, I've been using btrfs for a while now, I've been utilizing snapshot=
ting
nightly/weekly/monthly.=A0 During the weekly I also do a backup of the
filesystem to an ext4 filesystem.=A0 My storage is a linux md raid 5 vo=
lume.=A0
I've recently noticed these errors in the logs during the backup of the
files to the ext4 filesystem.=A0 I am running RHEL 6.1
(2.6.32-131.0.15.el6.x86_64)

I'd like to help in any way I can so I thought I'd post here to see if =
there
is anything I can do to help.

Thanks, Mike

PS I'm new to helping on an opensource project!

kernel: btrfs: dm-1 checksum verify failed on 759414784 wanted 52BAE689
found 827C3140 level 0
kernel: btrfs no csum found for inode 168597 start 82202624
=85
kernel: btrfs no csum found for inode 168597 start 84520960
kernel: __ratelimit: 2267 callbacks suppressed
kernel: btrfs no csum found for inode 170122 start 3772416
=85
kernel: btrfs no csum found for inode 170123 start 1720320

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
