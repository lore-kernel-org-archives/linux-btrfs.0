Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:36008 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750706AbaKYFKe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Nov 2014 00:10:34 -0500
Message-ID: <54740F42.2040301@cn.fujitsu.com>
Date: Tue, 25 Nov 2014 13:10:26 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: Daniel Miranda <danielkza2@gmail.com>, <linux-btrfs@vger.kernel.org>
Subject: Re: Apparent metadata corruption (file that simultaneously does/does
 not exist) on kernel 3.17.3
References: <CAPRQymMYBhy0mxG1qTxqt2OGezm3qnq+rAZOLAk1TpkOoixNWw@mail.gmail.com>
In-Reply-To: <CAPRQymMYBhy0mxG1qTxqt2OGezm3qnq+rAZOLAk1TpkOoixNWw@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

What's the btrfsck output? Without --repair option.

Also, if it is OK for you, would you please dump the btrfs with 
'btrfs-image' command?
'-c 9' option is highly recommended considering the size of it.
This will helps a lot for developers to test the btrfsck repair function.

Thanks,
Qu

-------- Original Message --------
Subject: Apparent metadata corruption (file that simultaneously 
does/does not exist) on kernel 3.17.3
From: Daniel Miranda <danielkza2@gmail.com>
To: <linux-btrfs@vger.kernel.org>
Date: 2014年11月25日 13:04
> Hello,
>
> After I had some brief stability issues with my computer, it seems
> some form of metadata corruption took place in my BTRFS filesystem,
> and now a particular file seems to exist, but I cannot access any
> details on it or delete it.
>
> If I try to `ls` in the directory it is in, that's what I get:
>
> ls: cannot access string.h: No such file or directory
> total 0
> drwxr-xr-x. 1 danielkza mock 16 Nov 21 14:18 ./
> drwxr-xr-x. 1 danielkza mock  6 Nov 21 14:18 ../
> -?????????? ? ?         ?     ?            ? string.h
>
> If I try to delete it I get:
>
> rm: cannot remove ‘string.h’: No such file or directory
>
> I'm using kernel 3.17.3 from Fedora 21. I got no messages on dmesg or
> anything of the sort. I know the btrfs fsck situation is complicated,
> but is there any utility I should use to try and repair this? Losing
> this file is not a problem, it's just one header from the kernel I was
> building.
>
> Regards,
> Daniel Miranda
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

