Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f49.google.com ([74.125.82.49]:36681 "EHLO
	mail-wm0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753667AbcBJUkC (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 10 Feb 2016 15:40:02 -0500
Received: by mail-wm0-f49.google.com with SMTP id p63so46315565wmp.1
        for <linux-btrfs@vger.kernel.org>; Wed, 10 Feb 2016 12:40:01 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtRtVjyjvSfT=BCZZwfaSvbD4YVxEBezfAx+-q7cwMHmRQ@mail.gmail.com>
References: <CABXGCsOrgnvE=qbftu=7OuJenq7Vw6HzM9B86DLT4xJGLmqbMQ@mail.gmail.com>
 <CAJCQCtS3MsrF43PnueK3-4kVLGfTNGjN4Tv-c=Jo1jVWYL7ksw@mail.gmail.com>
 <CABXGCsOAyYa96E965ruKp9evCY3FrCdBr-GTPvCws5VqmjUC5Q@mail.gmail.com>
 <CAJCQCtRjCixev=Mt=jaL1ZytYaxj7Fa-AViLYGB-ALufyL98VA@mail.gmail.com> <CAJCQCtRtVjyjvSfT=BCZZwfaSvbD4YVxEBezfAx+-q7cwMHmRQ@mail.gmail.com>
From: =?UTF-8?B?0JzQuNGF0LDQuNC7INCT0LDQstGA0LjQu9C+0LI=?=
	<mikhail.v.gavrilov@gmail.com>
Date: Thu, 11 Feb 2016 01:39:45 +0500
Message-ID: <CABXGCsNivrLgTEE+HZOLHXA-kpLVQOUv9L_nTw96nvy+DHodZg@mail.gmail.com>
Subject: Re: task btrfs-cleaner:770 blocked for more than 120 seconds.
To: Chris Murphy <lists@colorremedies.com>
Cc: bo.li.liu@oracle.com, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

2016-02-03 9:48 GMT+05:00 Chris Murphy <lists@colorremedies.com>:
> Mike: From your attachment, looks like you rebooted. So do this:
>
> echo 1 > /proc/sys/kernel/sysrq
> Reproduce the problem where you get blocked task messages in dmesg
> echo w > /proc/sysrq-trigger
> journalctl -k > kernel-sysrqw-btrfscleaner770blocked-2.txt
>
>
> Make sure you use the same mount options. Looks like you're using
> autodefrag, and inode_cache. Are there others? And can you say what
> the workload is? Especially because inode_cache is not a default mount
> option and isn't recommended except for certain workloads, but still I
> think it shouldn't hang. But that's a question for Liu Bo.
>
>
> Chris Murphy

Thanks Chris for clarification.
I am not have exactly algorithm for reproducing this.
But it happens with my btrfs partition again.

*Hang occured here*
echo 1 > /proc/sys/kernel/sysrq
Reproduce the problem where you get blocked task messages in dmesg
echo w > /proc/sysrq-trigger
journalctl -k > kernel-sysrqw-btrfscleaner770blocked-2.txt

Here full log: http://btrfs.sy24.ru/kernel-sysrqw-btrfscleaner770blocked-2.txt

I am so sorry if this log is useless.
If "sysrq" is needed enabled before hang then I need set this
permanently because as I said I not having exactly reproducing this.

My mount options:
UUID=82df2d84-bf54-46cb-84ba-c88e93677948 /home btrfs
subvolid=5,autodefrag,noatime,space_cache,inode_cache 0 0


--
Best Regards,
Mike Gavrilov.
