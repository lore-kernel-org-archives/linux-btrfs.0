Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f171.google.com ([209.85.213.171]:33075 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752566AbbDASEl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 1 Apr 2015 14:04:41 -0400
Received: by ignm3 with SMTP id m3so35930733ign.0
        for <linux-btrfs@vger.kernel.org>; Wed, 01 Apr 2015 11:04:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CACPiFCKx7G3pYdSs_MBne5Z6XP+zbgQK_iaNWvMQPs76R=VQNg@mail.gmail.com>
References: <CACPiFCJwQTsVcU2CJpSMyGyL1jsEQooMvOHooZriM70SsmGgVA@mail.gmail.com>
	<CAJCQCtTVAkJM6JE68a8vopKZqaSwfXCL9Bp8mGx-pDqny-h9ZQ@mail.gmail.com>
	<CACPiFCLDa8iSfWt=rggAEHpEh==MH95rzasLmDC175pFfMCrkQ@mail.gmail.com>
	<CAJCQCtRy4gzXYqHeoqdtv+Q-3Js7pthXMPa5X_gGHbSynktbBQ@mail.gmail.com>
	<CACPiFCKKb6SGZubGRMka3JmvFvtC64PxQ5PpJ6VR56gKcjXwdA@mail.gmail.com>
	<CAJCQCtSDSW3ZB5LE=Y5AJgWWgP=Lo6XFXTGZMLVQMwd36QQNMA@mail.gmail.com>
	<CACPiFCKx7G3pYdSs_MBne5Z6XP+zbgQK_iaNWvMQPs76R=VQNg@mail.gmail.com>
Date: Wed, 1 Apr 2015 12:04:40 -0600
Message-ID: <CAJCQCtShxpMC10QXJ8=rQCa2SaZ56d4kwH2riL4mEChCC-WvHg@mail.gmail.com>
Subject: Re: F21 fails to mount root part, btrfs check: Couldn't open file system
From: Chris Murphy <lists@colorremedies.com>
To: Martin Langhoff <martin.langhoff@gmail.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Apr 1, 2015 at 11:26 AM, Martin Langhoff
<martin.langhoff@gmail.com> wrote:
> On Wed, Apr 1, 2015 at 1:03 PM, Chris Murphy <lists@colorremedies.com> wrote:
>> mount /dev/sda6 /mnt
>> btrfs inspect-internal inode-resolve 39841 /mnt
>
> on the booted system...
> # uname -a
> Linux tp-martin.remote-learner.net 3.18.9-200.fc21.x86_64 #1 SMP Mon
> Mar 9 15:10:50 UTC 2015 x86_64 x86_64 x86_64 GNU/Linux
> # btrfs inspect-internal inode-resolve 39841 /
> //etc/shadow-
> # diff -u /etc/shadow{,-}
> --- /etc/shadow 2015-03-04 02:26:59.478255332 -0500
> +++ /etc/shadow-        2015-03-04 02:26:59.000000000 -0500
> @@ -42,4 +42,3 @@
>  systemd-timesync:!!:16498::::::
>  systemd-network:!!:16498::::::
>  systemd-resolve:!!:16498::::::
> -systemd-bus-proxy:!!:16498::::::
>
> Bizarre.

When I had this same btrfs check error, it was the exact inode number
and same /etc/shadow file. I didn't diff the two shadow files, but I
the the cp mv rm routine, and then the system booted. Goofy cakes.
It's almost like an April Fools joke.

-- 
Chris Murphy
