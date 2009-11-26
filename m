From: Ahmed Kamal <email.ahmedkamal@googlemail.com>
Subject: Re: No space left, although 16G are there
Date: Thu, 26 Nov 2009 23:47:48 +0200
Message-ID: <3da3b5b40911261347x4e9f9b17p953d9f5a39eac61@mail.gmail.com>
References: <3da3b5b40911261338j352ee3f7i6966a3308bc6fd08@mail.gmail.com>
	 <3da3b5b40911261341x67c8b696v36f7ed2f4caefe63@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <3da3b5b40911261341x67c8b696v36f7ed2f4caefe63@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

The system is insisting I am out of disk space!

[root@matrix tmp]# df -h /
Filesystem            Size  Used Avail Use% Mounted on
/dev/mapper/vgkimo-lvF12
                       26G   10G   16G  39% /

[root@matrix tmp]# dd if=/dev/zero of=bigfile bs=1M count=500
dd: writing `bigfile': No space left on device
61+0 records in
60+0 records out
62914560 bytes (63 MB) copied, 0.40297 s, 156 MB/s
You have mail in /var/spool/mail/root




On Thu, Nov 26, 2009 at 11:41 PM, Ahmed Kamal
<email.ahmedkamal@googlemail.com> wrote:
> Hi folks,
> I am running a Fedora-12 system (2.6.31.5-127.fc12.x86_64) with a
> btrfs root fs. While running a "yum upgrade" with around 200MB of
> updates, the system became significantly slow (3 seconds for Chrome to
> scroll down after hitting space bar!) and I noticed in
> /var/log/messages
>
> Nov 26 22:12:08 localhost kernel: no space left, need 61440, 18579456
> delalloc bytes, 10387451904 bytes_used, 0 bytes_reserved, 0
> bytes_pinned, 0 bytes_read only, 0 may use 10406068224 total
>
> Although "df -h" shows 16G of free space for the root fs. I thought
> I'd report this. Let me know if you want more diagnostics.
>
> Regards
>
