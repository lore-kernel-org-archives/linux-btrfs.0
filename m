Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f173.google.com ([209.85.223.173]:34726 "EHLO
	mail-io0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751003AbcBJVXA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 10 Feb 2016 16:23:00 -0500
Received: by mail-io0-f173.google.com with SMTP id 9so35544720iom.1
        for <linux-btrfs@vger.kernel.org>; Wed, 10 Feb 2016 13:23:00 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CABXGCsNivrLgTEE+HZOLHXA-kpLVQOUv9L_nTw96nvy+DHodZg@mail.gmail.com>
References: <CABXGCsOrgnvE=qbftu=7OuJenq7Vw6HzM9B86DLT4xJGLmqbMQ@mail.gmail.com>
	<CAJCQCtS3MsrF43PnueK3-4kVLGfTNGjN4Tv-c=Jo1jVWYL7ksw@mail.gmail.com>
	<CABXGCsOAyYa96E965ruKp9evCY3FrCdBr-GTPvCws5VqmjUC5Q@mail.gmail.com>
	<CAJCQCtRjCixev=Mt=jaL1ZytYaxj7Fa-AViLYGB-ALufyL98VA@mail.gmail.com>
	<CAJCQCtRtVjyjvSfT=BCZZwfaSvbD4YVxEBezfAx+-q7cwMHmRQ@mail.gmail.com>
	<CABXGCsNivrLgTEE+HZOLHXA-kpLVQOUv9L_nTw96nvy+DHodZg@mail.gmail.com>
Date: Wed, 10 Feb 2016 14:23:00 -0700
Message-ID: <CAJCQCtTrcnwvumgt-bOx+9wX+f50S9ja5rDrnYAsuuN1aDTsZA@mail.gmail.com>
Subject: Re: task btrfs-cleaner:770 blocked for more than 120 seconds.
From: Chris Murphy <lists@colorremedies.com>
To: =?UTF-8?B?0JzQuNGF0LDQuNC7INCT0LDQstGA0LjQu9C+0LI=?=
	<mikhail.v.gavrilov@gmail.com>
Cc: bo.li.liu@oracle.com, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Feb 10, 2016 at 1:39 PM, Михаил Гаврилов
<mikhail.v.gavrilov@gmail.com> wrote:


>
> Here full log: http://btrfs.sy24.ru/kernel-sysrqw-btrfscleaner770blocked-2.txt
>
> I am so sorry if this log is useless.

Looks good to me. The blocked task happens out of no where with
nothing reported for almost an hour before the blocking. And I see the
sysrq: SysRq : Show Blocked State was issued and lots of information
is in the file.

> If "sysrq" is needed enabled before hang then I need set this
> permanently because as I said I not having exactly reproducing this.

echo 1 > /proc/sys/kernel/sysrq can happen anytime, it just enables
sysrq triggering functions which on Fedora kernels is not enabled by
default. The main thing is that the echo w to the sysrq trigger needs
to happen at the time of the problem to show the state. You did that.
Let's see what Liu Bo has to say about it.


-- 
Chris Murphy
