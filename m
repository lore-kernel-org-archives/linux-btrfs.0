Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f43.google.com ([209.85.218.43]:36028 "EHLO
	mail-oi0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751977AbcF0TYe (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 Jun 2016 15:24:34 -0400
Received: by mail-oi0-f43.google.com with SMTP id f189so214397271oig.3
        for <linux-btrfs@vger.kernel.org>; Mon, 27 Jun 2016 12:24:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <feb87fbf-c017-ce29-3ba5-abc9d4cbb303@fastmail.fm>
References: <a3dcbcfc-a8b5-6a54-f600-63dd2d9162b5@fastmail.fm>
 <CAJCQCtRrk70p+iNNKCZvmz4T3R2=2d_JqQXJuSpt2QD1g9ysZQ@mail.gmail.com> <feb87fbf-c017-ce29-3ba5-abc9d4cbb303@fastmail.fm>
From: Chris Murphy <lists@colorremedies.com>
Date: Mon, 27 Jun 2016 13:24:32 -0600
Message-ID: <CAJCQCtSdNitRUA498COj1S3bcgdVA8Xf6qq1Fw71pbn_m=Z62A@mail.gmail.com>
Subject: Re: Btrfs full balance command fails due to ENOSPC (bug 121071)
To: Francesco Turco <fturco@fastmail.fm>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jun 27, 2016 at 12:32 PM, Francesco Turco <fturco@fastmail.fm> wrote:
> On 2016-06-27 20:18, Chris Murphy wrote:
>> If you can grab btrfs-debugfs from
>> https://github.com/kdave/btrfs-progs/blob/master/btrfs-debugfs
>>
>> And then attach the output to the bug report it might be useful for a
>> developer. But really your case is an odd duck, because there's fully
>> 14GiB unallocated, so it should be able to create a new one without
>> problem.
>>
>> $ sudo ./btrfs-debugfs -b /
>
> Done! Thank you, I was not aware of the existence of btrfs-debug...

I'm not certain what the "1 enospc errors during balance' refers to.
That message happens several times, the balance operation isn't
aborted, and doesn't come with any call traces (those appear later).
Further, the btrfs-debugfs output suggests the balance worked - each
bg is continguously located after the last and they're all new bg
offset values compared to what's found in the dmesg.

This might be that obscure -28 enospc bug that affects some file
systems and hasn't been tracked down yet. If I recall correctly it's a
misleading error, and the only work around to get rid of it is migrate
to a new Btrfs file system. I don't think the file system is at any
risk in the current state, but I'm not certain as it's already an edge
case. I'd just make sure you keep suitably current backups and keep
using it.



-- 
Chris Murphy
