From: Ahmed Kamal <email.ahmedkamal@googlemail.com>
Subject: Re: No space left, although 16G are there
Date: Fri, 27 Nov 2009 00:46:58 +0200
Message-ID: <3da3b5b40911261446p7d844611kd2a7c507f00fc808@mail.gmail.com>
References: <3da3b5b40911261338j352ee3f7i6966a3308bc6fd08@mail.gmail.com>
	 <3da3b5b40911261341x67c8b696v36f7ed2f4caefe63@mail.gmail.com>
	 <3da3b5b40911261347x4e9f9b17p953d9f5a39eac61@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <3da3b5b40911261347x4e9f9b17p953d9f5a39eac61@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

More info

[root@matrix ~]# btrfs-show
failed to read /dev/sr0
Label: none  uuid: 06b0d069-b1cb-48c4-b26f-c5088a2360d2
        Total devices 1 FS bytes used 9.99GB
        devid    1 size 25.72GB used 25.72GB path /dev/dm-1

Btrfs Btrfs v0.19


On Thu, Nov 26, 2009 at 11:47 PM, Ahmed Kamal
<email.ahmedkamal@googlemail.com> wrote:
> The system is insisting I am out of disk space!
>
> [root@matrix tmp]# df -h /
> Filesystem =A0 =A0 =A0 =A0 =A0 =A0Size =A0Used Avail Use% Mounted on
> /dev/mapper/vgkimo-lvF12
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 26G =A0 10G =A0 16G =A039=
% /
>
> [root@matrix tmp]# dd if=3D/dev/zero of=3Dbigfile bs=3D1M count=3D500
> dd: writing `bigfile': No space left on device
> 61+0 records in
> 60+0 records out
> 62914560 bytes (63 MB) copied, 0.40297 s, 156 MB/s
> You have mail in /var/spool/mail/root
>
>
>
>
> On Thu, Nov 26, 2009 at 11:41 PM, Ahmed Kamal
> <email.ahmedkamal@googlemail.com> wrote:
>> Hi folks,
>> I am running a Fedora-12 system (2.6.31.5-127.fc12.x86_64) with a
>> btrfs root fs. While running a "yum upgrade" with around 200MB of
>> updates, the system became significantly slow (3 seconds for Chrome =
to
>> scroll down after hitting space bar!) and I noticed in
>> /var/log/messages
>>
>> Nov 26 22:12:08 localhost kernel: no space left, need 61440, 1857945=
6
>> delalloc bytes, 10387451904 bytes_used, 0 bytes_reserved, 0
>> bytes_pinned, 0 bytes_read only, 0 may use 10406068224 total
>>
>> Although "df -h" shows 16G of free space for the root fs. I thought
>> I'd report this. Let me know if you want more diagnostics.
>>
>> Regards
>>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
