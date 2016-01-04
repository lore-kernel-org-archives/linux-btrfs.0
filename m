Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f172.google.com ([209.85.223.172]:33941 "EHLO
	mail-io0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751500AbcADKlR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Jan 2016 05:41:17 -0500
Received: by mail-io0-f172.google.com with SMTP id 1so104739194ion.1
        for <linux-btrfs@vger.kernel.org>; Mon, 04 Jan 2016 02:41:17 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <568A2EDF.6090909@markandruth.co.uk>
References: <568A2EDF.6090909@markandruth.co.uk>
Date: Mon, 4 Jan 2016 11:41:17 +0100
Message-ID: <CA+res+SW+8-R7kOxZdxXdmRyDdDQ8G=CUkVnYK=O=YzHHmCDqg@mail.gmail.com>
Subject: Re: Filesystem hang on kernel 4.2.0 with copy reflink
From: Jack Wang <jack.wang.usish@gmail.com>
To: Mark Zealey <mark@markandruth.co.uk>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Mark,

Could you do below when the hang happens, and post the dmesg.

echo w > /proc/sysrq-trigger

2016-01-04 9:35 GMT+01:00 Mark Zealey <mark@markandruth.co.uk>:
> Hi there, I've run into a very strange hang with btrfs. I was trying to
> restore a directory (postgres database) from a readonly snapshot. To do this
> i used the command `cp -ar --reflink=always`. This worked fine for 100s of
> files, however when it got to a particular file 16 kworker threads (I have 8
> processors in this system) got marked as being in D state (with 0 cpu usage
> or disk usage) and I could not access the btrfs file system any more. I
> can't see any kernel message or OOPS. Can you please let me know what
> additional debug information I can provide to help track this issue down in
> the kernel?
>
> System is latest ubuntu 14.04 LTS with a backported wily kernel (package
> linux-image-4.2.0-22-generic):
>
> 4.2.0-22-generic #27~14.04.1-Ubuntu SMP Fri Dec 18 10:57:53 UTC 2015 x86_64
> x86_64 x86_64 GNU/Linux
>
> Thanks
>
> Mark
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
