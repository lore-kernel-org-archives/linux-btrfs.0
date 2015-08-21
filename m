Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f46.google.com ([209.85.215.46]:33788 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752463AbbHUIsQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 21 Aug 2015 04:48:16 -0400
Received: by lalv9 with SMTP id v9so37304068lal.0
        for <linux-btrfs@vger.kernel.org>; Fri, 21 Aug 2015 01:48:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <2017000.AEG9PyVY17@zafu>
References: <2017000.AEG9PyVY17@zafu>
From: Karsten Heymann <karsten.heymann@gmail.com>
Date: Fri, 21 Aug 2015 10:47:45 +0200
Message-ID: <CAL017hDuuzfnPWpGthbHg+wkwinF90W8Ps-4uXY52ZJasJ42Hw@mail.gmail.com>
Subject: Re: BTRFS cannot remove empry directory pretending it is not empty
To: =?UTF-8?Q?Sw=C3=A2mi_Petaramesh?= <swami@petaramesh.org>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Swâmi,

did you check with lsof that no process has an open file descriptor in
that directory?

Regards,
Karsten

2015-08-21 10:19 GMT+02:00 Swâmi Petaramesh <swami@petaramesh.org>:
> Hello,
>
> BTRFS refuses to remove an empty dir and pretends it is not empty (and there
> is no BTRFS subvolume involved in there...)
>
> # uname -r
> 4.1.5-1-ARCH
>
>
> # ls -alnR .dropbox-old/
> .dropbox-old/:
> total 0
> drwx------ 1 1000 1000   18 21 août  09:59 .
> drwxr-x--- 1 1000 1000 2624 21 août  10:09 ..
> drwx------ 1 1000 1000  416 21 août  09:59 instance1
>
> .dropbox-old/instance1:
> total 0
> drwx------ 1 1000 1000 416 21 août  09:59 .
> drwx------ 1 1000 1000  18 21 août  09:59 ..
>
>
> # rm -rf .dropbox-old
> rm: cannot remove ‘.dropbox-old/instance1’: Directory not empty
>
> # ls -alnR .dropbox-old/instance1/
> .dropbox-old/instance1/:
> total 0
> drwx------ 1 1000 1000 416 21 août  09:59 .
> drwx------ 1 1000 1000  18 21 août  09:59 ..
>
> # rm -rf .dropbox-old/instance1/
> rm: cannot remove ‘.dropbox-old/instance1/’: Directory not empty
>
>
> How could this be fixed ?
>
> TIA, kind regards.
>
> --
> Swâmi Petaramesh <swami@petaramesh.org>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
