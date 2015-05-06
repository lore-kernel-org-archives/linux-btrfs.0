Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:33541 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751034AbbEFVrM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 May 2015 17:47:12 -0400
Received: by wgin8 with SMTP id n8so25591957wgi.0
        for <linux-btrfs@vger.kernel.org>; Wed, 06 May 2015 14:47:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <mie1ge$3to$1@ger.gmane.org>
References: <mie1ge$3to$1@ger.gmane.org>
From: Timofey Titovets <nefelim4ag@gmail.com>
Date: Thu, 7 May 2015 00:46:30 +0300
Message-ID: <CAGqmi77PuX-o-HZVFs6z2w9Eui5wtnic4frz25SQ4d9-7gsV2Q@mail.gmail.com>
Subject: Re: fstrim and subvolumes.
To: Christian <cdysthe@gmail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

when you run fstrim, you give path to file system, fstrim talk with
file system and filesystem call trim for whole free space on it
filesystem.
As you say above, home and root, is a subvolume on one big btrfs
filesystem, then if you call fstrim on any path in fs, you will trim
whole free space on this fs.

*Enough call it once for '/', sorry for long and ugly answer

2015-05-07 0:36 GMT+03:00 Christian <cdysthe@gmail.com>:
> Hi,
>
> I use a script to run scheduled fstrims on my SSD. I have a small /boot
> partition ext4 and a large btrfs partition / with /home as a subvolume of /
>
> My question is simple if I run "fstrim /" will /home be trimmed as well or
> will i have to run "fstrim /home" also to get the whole partition trimmed?
>
> --
> //Christian
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Have a nice day,
Timofey.
