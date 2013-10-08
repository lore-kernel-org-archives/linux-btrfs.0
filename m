Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f194.google.com ([209.85.212.194]:47467 "EHLO
	mail-wi0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752888Ab3JHQyE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 8 Oct 2013 12:54:04 -0400
Received: by mail-wi0-f194.google.com with SMTP id l12so15536wiv.5
        for <linux-btrfs@vger.kernel.org>; Tue, 08 Oct 2013 09:54:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20131008153439.GE4322@twin.jikos.cz>
References: <1381130508-8458-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
	<1381130508-8458-11-git-send-email-wangsl.fnst@cn.fujitsu.com>
	<20131008153439.GE4322@twin.jikos.cz>
Date: Wed, 9 Oct 2013 00:54:03 +0800
Message-ID: <CAP9B-Qm_PmpNiKk_jmvQvti5djvbtk-hbZgT9NjFqaYWGrpGeg@mail.gmail.com>
Subject: Re: [PATCH v3 10/12] Btrfs-progs: add '--block-size' option to
 control print result
From: Shilong Wang <wangshilong1991@gmail.com>
To: David Sterba <dsterba@suse.cz>, Wang Shilong <wangsl.fnst@cn.fujitsu.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi David,

2013/10/8 David Sterba <dsterba@suse.cz>:
> On Mon, Oct 07, 2013 at 03:21:46PM +0800, Wang Shilong wrote:
>> You can use it like:
>>       btrfs qgroup show --block-size=m <mnt>
>>
>> Here, block size supports k/K/m/M/g/G/t/T/p/P/e/E.
>
> There is no distinction between the 1000 and 1024 based prefixes, also
> no way to get the raw values in bytes. I don't have a suggestion how to
> do that, merely letting you know that this could go separately (this and
> the "-h" patch, the rest shall be integrated).

I implement this like the command 'du'.

In default, we print result in bytes. And block size don't give a byte
unit implicitly.Aslo i don't know why we need to distinct 1000 and
1024, i don't have any ideas about this.

>
> Also, the numbers in the table should be aligned to the right:

Yes, this should be fixed.

Thanks,
Wang
>
> $ btrfs qgroup show -h -p /mnt/
> qgroupid rfer      excl      parent
> -------- ----      ----      ------
> 0/5      900.00KiB 900.00KiB ---
> 0/267    688.00KiB 12.00KiB  1/5
> 0/268    684.00KiB 8.00KiB   1/5
> 0/269    6.71GiB   4.00KiB   1/1
> 0/277    6.71GiB   4.00KiB   1/1
> 0/278    39.74GiB  39.74GiB  1/2
> 1/1      6.71GiB   6.71GiB   ---
> 1/2      39.74GiB  39.74GiB  ---
> 1/5      696.00KiB 696.00KiB ---
>
>
> david
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
