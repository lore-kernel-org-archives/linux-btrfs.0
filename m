Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f176.google.com ([74.125.82.176]:48909 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752390Ab3JHQeV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 8 Oct 2013 12:34:21 -0400
Received: by mail-we0-f176.google.com with SMTP id w62so7325506wes.21
        for <linux-btrfs@vger.kernel.org>; Tue, 08 Oct 2013 09:34:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAP9B-Qm=BkJH_GrNfYxRAuo94zMz9DXu7yQ2aN7H7_OABFF9TQ@mail.gmail.com>
References: <1381130508-8458-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
	<1381130508-8458-11-git-send-email-wangsl.fnst@cn.fujitsu.com>
	<20131008153439.GE4322@twin.jikos.cz>
	<CAP9B-Qm=BkJH_GrNfYxRAuo94zMz9DXu7yQ2aN7H7_OABFF9TQ@mail.gmail.com>
Date: Wed, 9 Oct 2013 00:34:19 +0800
Message-ID: <CAP9B-Qm+hpHVO3+b3=Gvv+gy2N_Q0oA_R-KmFAio_X8s-e3sAQ@mail.gmail.com>
Subject: Re: [PATCH v3 10/12] Btrfs-progs: add '--block-size' option to
 control print result
From: Shilong Wang <wangshilong1991@gmail.com>
To: David Sterba <dsterba@suse.cz>, Wang Shilong <wangsl.fnst@cn.fujitsu.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Sorry, This should to reply to the bug that you find, not this thread.
Anyway, you are smart enough to get this .....

2013/10/9 Shilong Wang <wangshilong1991@gmail.com>:
> Thanks for finding this, the problem comes to patch [v3 9/12].
> When updating max columns len of child_qgroup, i miswrite qgroup->member to
> qgroup->parent, i have updated this patch and send a v4, it can be
> appiled without conflicts with later.
>
> Thanks,
> Wang
> 2013/10/8 David Sterba <dsterba@suse.cz>:
>> On Mon, Oct 07, 2013 at 03:21:46PM +0800, Wang Shilong wrote:
>>> You can use it like:
>>>       btrfs qgroup show --block-size=m <mnt>
>>>
>>> Here, block size supports k/K/m/M/g/G/t/T/p/P/e/E.
>>
>> There is no distinction between the 1000 and 1024 based prefixes, also
>> no way to get the raw values in bytes. I don't have a suggestion how to
>> do that, merely letting you know that this could go separately (this and
>> the "-h" patch, the rest shall be integrated).
>>
>> Also, the numbers in the table should be aligned to the right:
>>
>> $ btrfs qgroup show -h -p /mnt/
>> qgroupid rfer      excl      parent
>> -------- ----      ----      ------
>> 0/5      900.00KiB 900.00KiB ---
>> 0/267    688.00KiB 12.00KiB  1/5
>> 0/268    684.00KiB 8.00KiB   1/5
>> 0/269    6.71GiB   4.00KiB   1/1
>> 0/277    6.71GiB   4.00KiB   1/1
>> 0/278    39.74GiB  39.74GiB  1/2
>> 1/1      6.71GiB   6.71GiB   ---
>> 1/2      39.74GiB  39.74GiB  ---
>> 1/5      696.00KiB 696.00KiB ---
>>
>>
>> david
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
