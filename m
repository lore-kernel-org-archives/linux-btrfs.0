Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f180.google.com ([209.85.214.180]:57119 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750841AbaKYFOs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Nov 2014 00:14:48 -0500
Received: by mail-ob0-f180.google.com with SMTP id wp4so8197759obc.25
        for <linux-btrfs@vger.kernel.org>; Mon, 24 Nov 2014 21:14:47 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <54740F42.2040301@cn.fujitsu.com>
References: <CAPRQymMYBhy0mxG1qTxqt2OGezm3qnq+rAZOLAk1TpkOoixNWw@mail.gmail.com>
 <54740F42.2040301@cn.fujitsu.com>
From: Daniel Miranda <danielkza2@gmail.com>
Date: Tue, 25 Nov 2014 03:14:27 -0200
Message-ID: <CAPRQymNp3+387P-nmXKoWGNV31TKaYLBWv6g63WwJPqN4g-fYg@mail.gmail.com>
Subject: Re: Apparent metadata corruption (file that simultaneously does/does
 not exist) on kernel 3.17.3
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I'll go run that and get you the output.

I can do the image dump, sure. I don't know how long it might take to
upload it somewhere though. Right now `btrfs fi df` shows about 2GiB
of metadata (it's a 120GiB volume). I'll see how large it ends up
after compression.

Thanks for the quick response,
Daniel

On Tue, Nov 25, 2014 at 3:10 AM, Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:
> Hi,
>
> What's the btrfsck output? Without --repair option.
>
> Also, if it is OK for you, would you please dump the btrfs with
> 'btrfs-image' command?
> '-c 9' option is highly recommended considering the size of it.
> This will helps a lot for developers to test the btrfsck repair function.
>
> Thanks,
> Qu
>
>
> -------- Original Message --------
> Subject: Apparent metadata corruption (file that simultaneously does/does
> not exist) on kernel 3.17.3
> From: Daniel Miranda <danielkza2@gmail.com>
> To: <linux-btrfs@vger.kernel.org>
> Date: 2014年11月25日 13:04
>>
>> Hello,
>>
>> After I had some brief stability issues with my computer, it seems
>> some form of metadata corruption took place in my BTRFS filesystem,
>> and now a particular file seems to exist, but I cannot access any
>> details on it or delete it.
>>
>> If I try to `ls` in the directory it is in, that's what I get:
>>
>> ls: cannot access string.h: No such file or directory
>> total 0
>> drwxr-xr-x. 1 danielkza mock 16 Nov 21 14:18 ./
>> drwxr-xr-x. 1 danielkza mock  6 Nov 21 14:18 ../
>> -?????????? ? ?         ?     ?            ? string.h
>>
>> If I try to delete it I get:
>>
>> rm: cannot remove ‘string.h’: No such file or directory
>>
>> I'm using kernel 3.17.3 from Fedora 21. I got no messages on dmesg or
>> anything of the sort. I know the btrfs fsck situation is complicated,
>> but is there any utility I should use to try and repair this? Losing
>> this file is not a problem, it's just one header from the kernel I was
>> building.
>>
>> Regards,
>> Daniel Miranda
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
