Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qc0-f180.google.com ([209.85.216.180]:52340 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751801AbaETK2Y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 20 May 2014 06:28:24 -0400
Received: by mail-qc0-f180.google.com with SMTP id i17so348461qcy.25
        for <linux-btrfs@vger.kernel.org>; Tue, 20 May 2014 03:28:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20140520102024.GA12133@suse.de>
References: <CAF1ZMEfRCrnNU9HNUZwm2V154Z1f639m6ctFMKVbi3dRQw2cVQ@mail.gmail.com>
	<20140520102024.GA12133@suse.de>
Date: Tue, 20 May 2014 18:28:23 +0800
Message-ID: <CAF1ZMEe3pFdvqwSm3dzFSjBYQ8zHRO9Q2ynb1cfC1Tw-WHuYAA@mail.gmail.com>
Subject: Re: btrfs-progs: add arg_strtou64 break library btrfs
From: "Dennis Lan (dlan)" <dennis.yxun@gmail.com>
To: Arvin Schnell <aschnell@suse.de>
Cc: Wang Shilong <wangsl.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 20, 2014 at 6:20 PM, Arvin Schnell <aschnell@suse.de> wrote:
> On Tue, May 20, 2014 at 06:15:49PM +0800, Dennis Lan (dlan) wrote:
>> progs # cat btrfs_mini_tst.c
>>  /*
>>   * gcc -o btrfs_mini_tst btrfs_mini_tst.c -lbtrfs
>>   */
>>
>>   char btrfs_read_and_process_send_stream ();
>>  int
>>  main ()
>>  {
>>  return btrfs_read_and_process_send_stream ();
>>  }
>>
>> progs # gcc -o btrfs_mini_tst btrfs_mini_tst.c -lbtrfs
>> /usr/lib/gcc/x86_64-pc-linux-gnu/4.8.2/../../../../lib64/libbtrfs.so:
>> undefined reference to `arg_strtou64'
>> collect2: error: ld returned 1 exit status
>
> Hi,
>
> that problem was already found. A fix can be found here:
>
> http://www.spinics.net/lists/linux-btrfs/msg33434.html
>
> Regards,
>   Arvin
>
> --
> Arvin Schnell, <aschnell@suse.de>
> Senior Software Engineer, Research & Development
> SUSE LINUX Products GmbH, GF: Jeff Hawn, Jennifer Guild, Felix Imendörffer, HRB 16746 (AG Nürnberg)
> Maxfeldstraße 5
> 90409 Nürnberg
> Germany


HI arvin:
  oh, indeed, this patch should fix my problem
  thanks for quick response

Lan
