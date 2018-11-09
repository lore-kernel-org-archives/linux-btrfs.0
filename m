Return-Path: <SRS0=dhPA=NU=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA990C43441
	for <linux-btrfs@archiver.kernel.org>; Fri,  9 Nov 2018 20:25:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9D78520827
	for <linux-btrfs@archiver.kernel.org>; Fri,  9 Nov 2018 20:25:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=virtall.com header.i=@virtall.com header.b="JZS6P+BF"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9D78520827
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=virtall.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728167AbeKJGHe (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 10 Nov 2018 01:07:34 -0500
Received: from mail.virtall.com ([46.4.129.203]:38996 "EHLO mail.virtall.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725752AbeKJGHd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 10 Nov 2018 01:07:33 -0500
Received: from mail.virtall.com (localhost [127.0.0.1])
        by mail.virtall.com (Postfix) with ESMTP id 2C6143555CB2;
        Fri,  9 Nov 2018 20:25:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtall.com;
        s=default; t=1541795120;
        bh=JxtN/TaXyqovv4kiD0lRyKq/cUyAhY2I+/Mo1IlQsKE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References;
        b=JZS6P+BF2BUWeHoJzebOuaSZf6MPD5mGpLps0H6WRJdcKS40/8WniBDRRFmDTnQyO
         PWmmiLx+/O8PvCHd/sA9Cowj5q1/EMdQGasjpWMPaN8rlsRv1pI/1hdjNXXcsWUpmt
         KScuKPuymSJII57QkyuRUU8UBOqt08IyTabNM0f39yD3gA+krdthXTrVltmtLwjXtm
         dIbyxQ2UNf6RJx+R9K5JLBkawhL+vdFOp6zZJdtoIJX8k7tgLy5o1B0bSrvQ/zx2fA
         JFZN4w2fY/4tloEOeNBVQdW6yiA0Dh6w3WISugkN81rUHbiygSjX7GwqxsaWN27YIZ
         6wK8JkSuPGjzQ==
X-Fuglu-Suspect: 4a99adaec40243a8830cff47f197b5ad
X-Fuglu-Spamstatus: NO
Received: from localhost (localhost [127.0.0.1]) (Authenticated sender: tch@virtall.com)
        by mail.virtall.com (Postfix) with ESMTPSA;
        Fri,  9 Nov 2018 20:25:19 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Sat, 10 Nov 2018 05:25:18 +0900
From:   Tomasz Chmielewski <tch@virtall.com>
To:     Roman Mamedov <rm@romanrm.net>
Cc:     Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: unable to mount btrfs after upgrading from 4.16.1 to 4.19.1
In-Reply-To: <ba97269113a800cdd8b9694a9c1e9760@virtall.com>
References: <2442f641ad54ce98361cf40b70e4d18d@virtall.com>
 <20181109232052.19233269@natsu>
 <62812fe46b56258a47dc9df38c76e7f0@virtall.com>
 <ba97269113a800cdd8b9694a9c1e9760@virtall.com>
Message-ID: <a2b6f4e0338ef3dc015a47da170bee20@virtall.com>
X-Sender: tch@virtall.com
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 2018-11-10 04:20, Tomasz Chmielewski wrote:
> On 2018-11-10 04:15, Tomasz Chmielewski wrote:
>> On 2018-11-10 03:20, Roman Mamedov wrote:
>>> On Sat, 10 Nov 2018 03:08:01 +0900
>>> Tomasz Chmielewski <tch@virtall.com> wrote:
>>> 
>>>> After upgrading from kernel 4.16.1 to 4.19.1 and a clean restart, 
>>>> the fs
>>>> no longer mounts:
>>> 
>>> Did you try rebooting back to 4.16.1 to see if it still mounts there?
>> 
>> Yes, just did.
>> 
>> Interestingly, it does mount when I boot back to 4.16.1 - side note -
>> it takes some 50 (!) minutes and ~8 GB of reads (according to iostat
>> -m) to mount... device size is 16 TB, on HDD.
> 
> Also - it did mount with 4.18.17.
> 
> Way faster, in some 2 min.

A few more clean reboot cycles with 4.18.17 and got:

[  113.677829] BTRFS error (device md2): open_ctree failed
[  113.692298] BTRFS info (device md2): force zstd compression, level 0
[  113.692302] BTRFS info (device md2): using free space tree
[  113.692304] BTRFS info (device md2): has skinny extents
[  113.897681] BTRFS error (device md2): super_total_bytes 
17920974913536 mismatch with fs_devices total_rw_bytes 35841949827072
[  113.897751] BTRFS error (device md2): failed to read chunk tree: -22
[  113.935149] BTRFS error (device md2): open_ctree failed


Another "mount /data" (without rebooting) mounted it fine.

Why are btrfs mounts so irregular here?

# btrfs device stats /data
[/dev/md2].write_io_errs    0
[/dev/md2].read_io_errs     0
[/dev/md2].flush_io_errs    0
[/dev/md2].corruption_errs  0
[/dev/md2].generation_errs  0


# btrfs fi usage /data
Overall:
     Device size:                  16.30TiB
     Device allocated:             14.26TiB
     Device unallocated:            2.04TiB
     Device missing:                  0.00B
     Used:                          7.99TiB
     Free (estimated):              8.27TiB      (min: 8.27TiB)
     Data ratio:                       1.00
     Metadata ratio:                   1.00
     Global reserve:              512.00MiB      (used: 0.00B)

Data,single: Size:14.15TiB, Used:7.92TiB
    /dev/md2       14.15TiB

Metadata,single: Size:111.00GiB, Used:74.78GiB
    /dev/md2      111.00GiB

System,single: Size:32.00MiB, Used:1.81MiB
    /dev/md2       32.00MiB

Unallocated:
    /dev/md2        2.04TiB



Tomasz Chmielewski
https://lxadm.com
