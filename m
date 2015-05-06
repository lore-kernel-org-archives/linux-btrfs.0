Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f178.google.com ([209.85.213.178]:38574 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752662AbbEFDqh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 5 May 2015 23:46:37 -0400
Received: by igbhj9 with SMTP id hj9so5970233igb.1
        for <linux-btrfs@vger.kernel.org>; Tue, 05 May 2015 20:46:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <55490697.8020702@linuxmail.org>
References: <5548F177.1040309@linuxmail.org>
	<pan.2015.05.05.17.03.19@googlemail.com>
	<55490697.8020702@linuxmail.org>
Date: Tue, 5 May 2015 20:46:37 -0700
Message-ID: <CAN05THQbAqQCqGcgNSx5f5h58LnX7z8XqB60434Eed+5gbFLHw@mail.gmail.com>
Subject: Re: hard lockup while balance was running killed my raid5
From: ronnie sahlberg <ronniesahlberg@gmail.com>
To: Perry Gilfillan <perrye@linuxmail.org>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In my experience,
parent transid verify failed on 27198603952128 wanted 291431 found 291859

This probably means your filesystem is toast and you have total dataloss.


On Tue, May 5, 2015 at 11:06 AM, Perry Gilfillan <perrye@linuxmail.org> wrote:
>
>
> On 05/05/2015 12:03 PM, Holger Hoffstätte wrote:
>>
>> I've also had a hard lockup just the other day during a balance (on a
>> single device though), so this points to some changes in the 4.1 merge
>> window.
>>
>> Just to confirm: by "hard lockup" you mean that the entire box is frozen,
>> no longer shows any signs of life and no longer responds to anything?
>
> The crash occured while running vmlinuz-3.19.5-200.fc21.x86_64 kernel image,
> and the console had the tail end of a crash dump.  I wasn't even able to use
> SysRq magic as a last resort.
>>
>> One thing you could try is to mount your devices without the free-space
>> cache (-o clear_cache,nospace_cache) and try to run the balance.
>>
>> Would be interesting to see if that helps.
>
> No joy:
>
> mount -o clear_cache,nospace_cache /dev/sdf5 /media/mythstore-q/
> mount: wrong fs type, bad option, bad superblock on /dev/sdf5,
>        missing codepage or helper program, or other error
>
>        In some cases useful info is found in syslog - try
>        dmesg | tail or so.
> [root@lightmyfire btrfs-progs-unstable]# dmesg | tail
> [156582.161467] BTRFS: failed to read chunk tree on sde5
> [156582.199621] BTRFS: open_ctree failed
> [157176.918989] BTRFS info (device sde5): force clearing of disk cache
> [157176.919007] BTRFS info (device sde5): disabling disk space caching
> [157176.923126] BTRFS (device sde5): parent transid verify failed on
> 27198602870784 wanted 291859 found 291431
> [157176.928355] BTRFS (device sde5): parent transid verify failed on
> 27198602887168 wanted 291859 found 291431
> [157176.975898] BTRFS (device sde5): parent transid verify failed on
> 27198604001280 wanted 291640 found 291420
> [157176.982158] BTRFS (device sde5): bad tree block start 889192477
> 27198604001280
> [157176.986004] BTRFS: failed to read chunk tree on sde5
> [157177.020060] BTRFS: open_ctree failed
>
>
> btrfs-image throws a different error,
> bytenr mismatch, want=27198603952128, have=13057557201204318535,
> where the 'have' seems to be pointing some where out past Pluto!
>
> [root@lightmyfire btrfs-progs-unstable]# ./btrfs-image /dev/sdf5 ~/text.txt
> parent transid verify failed on 27198602870784 wanted 291859 found 291431
> parent transid verify failed on 27198602870784 wanted 291859 found 291431
> checksum verify failed on 27198602870784 found C273E746 wanted 26905AF0
> parent transid verify failed on 27198602870784 wanted 291859 found 291431
> Ignoring transid failure
> parent transid verify failed on 27198603952128 wanted 291431 found 291859
> parent transid verify failed on 27198603952128 wanted 291431 found 291859
> checksum verify failed on 27198603952128 found BC5A7A89 wanted 90B199E8
> checksum verify failed on 27198603952128 found BC5A7A89 wanted 90B199E8
> bytenr mismatch, want=27198603952128, have=13057557201204318535
> Couldn't read chunk tree
> Open ctree failed
> create failed (Success)
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
