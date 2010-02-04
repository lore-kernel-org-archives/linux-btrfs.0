From: "Yan, Zheng " <yanzheng@21cn.com>
Subject: Re: btrfs-vol -b endless loop
Date: Thu, 4 Feb 2010 10:59:16 +0800
Message-ID: <3d0408631002031859r69ac7ef8r248ffab3a2774b6a@mail.gmail.com>
References: <87636ej6t3.fsf@nsc.liu.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: =?ISO-8859-1?Q?P=E4r_Andersson?= <paran@lysator.liu.se>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <87636ej6t3.fsf@nsc.liu.se>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Feb 4, 2010 at 6:25 AM, P=E4r Andersson <paran@lysator.liu.se> =
wrote:
> Hi,
>
> I have a 11G btrfs file system where "btrfs-vol -b" get stuck in a
> loop. The "found 7 extents" messages and heavy disk io continues unti=
l I
> reboot:
>
> [26223.544037] btrfs: relocating block group 42079027200 flags 36
> [26228.082740] btrfs: found 2457 extents
> [26228.104515] btrfs: relocating block group 41407938560 flags 1
> [26228.423981] btrfs: found 124 extents
> [26229.514583] btrfs: found 124 extents
> [26229.544160] btrfs: found 7 extents
> [26229.812494] btrfs: found 7 extents
> [26230.453720] btrfs: found 7 extents
> [26230.733233] btrfs: found 7 extents
> [26231.383321] btrfs: found 7 extents
> [26231.652815] btrfs: found 7 extents
> ...
>
> The error is repeatable. btrfsck does not report any errors:
>
> root@faran:~# btrfsck /dev/sda5
> found 9035055104 bytes used err is 0
> total csum bytes: 8293152
> total tree bytes: 542867456
> total fs tree bytes: 503087104
> btree space waste bytes: 108089491
> file data blocks allocated: 8492187648
> =A0referenced 10314125312
> Btrfs Btrfs v0.19
>
> The kernel is Linus' master from two days ago, and seems to have all =
the
> latest btrfs code merged.
>

The loop is due to fragments of free space. I'm working on make 'btrfs-=
vol -b'
return -ENOSPC in this case.

Yan, Zheng
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
