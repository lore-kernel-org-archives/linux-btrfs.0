Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f171.google.com ([209.85.213.171]:33011 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932903AbcCQUFp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 17 Mar 2016 16:05:45 -0400
Received: by mail-ig0-f171.google.com with SMTP id ig19so23774607igb.0
        for <linux-btrfs@vger.kernel.org>; Thu, 17 Mar 2016 13:05:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87y49ggbas.wl-MarkoSchuetz@web.de>
References: <87y49ggbas.wl-MarkoSchuetz@web.de>
Date: Thu, 17 Mar 2016 14:05:44 -0600
Message-ID: <CAJCQCtQ4Ax5=_sgKXPiShpx0L6-6qZmVnV0upRHsZio7RW_4Aw@mail.gmail.com>
Subject: Re: btrfs receive hangs in "uninterruptible sleep"
From: Chris Murphy <lists@colorremedies.com>
To: =?UTF-8?Q?Marko_Sch=C3=BCtz_Schmuck?= <MarkoSchuetz@web.de>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Mar 17, 2016 at 1:21 PM, Marko Schütz Schmuck
<MarkoSchuetz@web.de> wrote:
> Dear All,
>
> for backup purposes on a laptop I use a shell script that takes
> snapshots and then btrfs sends the increment to a btrfs receive to an
> external USB drive. This used to work for years.

Ok it's kindof an old file system now a lot has changed with it and
also the code. So now you're testing how it ages.


>The last time I used
> it successfully was mid-January. After that I have not been able to do
> a successful backup. It seems the btrfs receive hangs in
> "uninterruptible sleep". I turned on verbose output and can seen that
> it hangs predictably at the same file after `df -m` on the target file
> system reports 44MB more space used and 30MB less space available. At
> that time the `btrfs receive` has used 6s of CPU time. I cannot kill
> the `btrfs receive` and a shutdown does not go through (I have to
> power off).
>
> I have tried booting into an older kernel version, btrfs scrub, btrfs
> check. Always the same.
>
> Needless to say this is annoying: my main reason for using btrfs was
> the backup using send/receive ...
>
> Any help is greatly appreciated!
>
> Best regards,
>
> Marko
>
> % uname -a
> Linux tpad-u 3.19.0-25-generic #26~14.04.1-Ubuntu SMP Fri Jul 24 21:16:20 UTC 2015 x86_64 x86_64 x86_64 GNU/Linux
>
> % btrfs --version
> Btrfs v3.12

Neither of those versions are maintained anymore so even if it's a bug
(likely) there are thousands of bugs that have been fixed since then
that won't make it back that far. At the very least you could try
btrfs-progs 3.19 so they're at least closer in age? But I personally
wouldn't do that. I would go straight to kernel 4.4.6 and progs 4.4.1,
and create new file systems for both send and receive. As in, I
wouldn't even use new kernels+progs with two year old filesystems. Yes
it should work, and it probably would. But file systems do not get
more reliable or deterministic with age. So if you want to be more of
a tester, sure upgrade the kernel and progs, leave the filesystems as
they are, chances are the problem is resolved. If you want to be less
of a tester, new file systems for both send and receive, get the data
migrated over sooner than later.


-- 
Chris Murphy
