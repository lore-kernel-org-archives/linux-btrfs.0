Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.virtall.com ([178.63.195.102]:51910 "EHLO mail.virtall.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758477AbbLBOGy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 2 Dec 2015 09:06:54 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Wed, 02 Dec 2015 23:06:27 +0900
From: Tomasz Chmielewski <tch@virtall.com>
To: Wang Shilong <wangshilong1991@gmail.com>
Cc: Austin S Hemmelgarn <ahferroin7@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: compression disk space saving - what are your results?
In-Reply-To: <CAP9B-Qm8gQdCZzQuMeZWCY=ni-xEBOueZpFPrYHMpcwdjtVC5Q@mail.gmail.com>
References: <4082684905f25f921ae4564b1c8a892e@admin.virtall.com>
 <565EEC1F.7070600@gmail.com>
 <18fb40ae4411f31353e06bf99ee12c8a@admin.virtall.com>
 <CAP9B-Qm8gQdCZzQuMeZWCY=ni-xEBOueZpFPrYHMpcwdjtVC5Q@mail.gmail.com>
Message-ID: <444beddc07dce88fd81eeabdaa060f29@admin.virtall.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2015-12-02 23:03, Wang Shilong wrote:

>> Compression ratio is much much better now (on a slightly changed data 
>> set):
>> 
>> # df -h
>> /dev/xvdb       200G   24G  176G  12% /var/log/remote
>> 
>> 
>> # du -sh /var/log/remote/
>> 138G    /var/log/remote/
>> 
>> 
>> So, 138 GB files use just 24 GB on disk - nice!
>> 
>> However, I would still expect that compress=zlib has almost the same 
>> effect
>> as compress-force=zlib, for 100% text files/logs.
> 
> btw, what is your kernel version? there was a bug that detected inode
> compression
> ration wrong.
> 
> http://git.kernel.org/cgit/linux/kernel/git/mason/linux-btrfs.git/commit/?id=68bb462d42a963169bf7acbe106aae08c17129a5
> http://git.kernel.org/cgit/linux/kernel/git/mason/linux-btrfs.git/commit/?id=4bcbb33255131adbe481c0467df26d654ce3bc78

Linux 4.3.0.


Tomasz Chmielewski
http://wpkg.org/

