Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f51.google.com ([209.85.215.51]:34585 "EHLO
	mail-lf0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932301AbbLBOD1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 2 Dec 2015 09:03:27 -0500
Received: by lffu14 with SMTP id u14so51717447lff.1
        for <linux-btrfs@vger.kernel.org>; Wed, 02 Dec 2015 06:03:26 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <18fb40ae4411f31353e06bf99ee12c8a@admin.virtall.com>
References: <4082684905f25f921ae4564b1c8a892e@admin.virtall.com>
	<565EEC1F.7070600@gmail.com>
	<18fb40ae4411f31353e06bf99ee12c8a@admin.virtall.com>
Date: Wed, 2 Dec 2015 22:03:25 +0800
Message-ID: <CAP9B-Qm8gQdCZzQuMeZWCY=ni-xEBOueZpFPrYHMpcwdjtVC5Q@mail.gmail.com>
Subject: Re: compression disk space saving - what are your results?
From: Wang Shilong <wangshilong1991@gmail.com>
To: Tomasz Chmielewski <tch@virtall.com>
Cc: Austin S Hemmelgarn <ahferroin7@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Dec 2, 2015 at 9:53 PM, Tomasz Chmielewski <tch@virtall.com> wrote:
> On 2015-12-02 22:03, Austin S Hemmelgarn wrote:
>
>>>  From these numbers (124 GB used where data size is 153 GB), it appears
>>> that we save around 20% with zlib compression enabled.
>>> Is 20% reasonable saving for zlib? Typically text compresses much better
>>> with that algorithm, although I understand that we have several
>>> limitations when applying that on a filesystem level.
>>
>>
>> This is actually an excellent question.  A couple of things to note
>> before I share what I've seen:
>> 1. Text compresses better with any compression algorithm.  It is by
>> nature highly patterned and moderately redundant data, which is what
>> benefits the most from compression.
>
>
> It looks that compress=zlib does not compress very well. Following Duncan's
> suggestion, I've changed it to compress-force=zlib, and re-copied the data
> to make sure the file are compressed.
>
> Compression ratio is much much better now (on a slightly changed data set):
>
> # df -h
> /dev/xvdb       200G   24G  176G  12% /var/log/remote
>
>
> # du -sh /var/log/remote/
> 138G    /var/log/remote/
>
>
> So, 138 GB files use just 24 GB on disk - nice!
>
> However, I would still expect that compress=zlib has almost the same effect
> as compress-force=zlib, for 100% text files/logs.

btw, what is your kernel version? there was a bug that detected inode
compression
ration wrong.

http://git.kernel.org/cgit/linux/kernel/git/mason/linux-btrfs.git/commit/?id=68bb462d42a963169bf7acbe106aae08c17129a5
http://git.kernel.org/cgit/linux/kernel/git/mason/linux-btrfs.git/commit/?id=4bcbb33255131adbe481c0467df26d654ce3bc78

Regards,
Shilong

>
>
> Tomasz Chmielewski
> http://wpkg.org
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
