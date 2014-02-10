Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qc0-f178.google.com ([209.85.216.178]:50695 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751371AbaBJOGR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 10 Feb 2014 09:06:17 -0500
Received: by mail-qc0-f178.google.com with SMTP id m20so10419353qcx.23
        for <linux-btrfs@vger.kernel.org>; Mon, 10 Feb 2014 06:06:17 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <pan$9975$a22e4391$1abcb3d9$aba51d08@cox.net>
References: <CABgvyo-rw8To-=8_Kt+j8gXiJyX43oWPrWxhAGWqhpE83oCCAw@mail.gmail.com>
 <C0AD9885-8F81-4642-809F-BDC3933A5932@colorremedies.com> <20140130175831.GU3314@carfax.org.uk>
 <C3B0EA86-0CBA-4500-81A8-7F3A99306E76@colorremedies.com> <CABgvyo8ZG=pk=i-7iXzoOWqZj_fVvUd6xiaXef1KWR8QLibhXg@mail.gmail.com>
 <6C293A14-9A38-4DAA-A720-1F77B9CB083D@colorremedies.com> <CABgvyo-cZ1bw7Gyd5sUYK11mMUp3N2w6v=SNEdXBRYqbNSNNFQ@mail.gmail.com>
 <CABgvyo8iS-8i-NKDUPX30B+Mk-B8-ZjLU7p_N7XefXtcSDvCFg@mail.gmail.com>
 <C37F3250-AA5B-4C75-8ECB-D1E7B6FFEADD@colorremedies.com> <CABgvyo89WYpOFqb7fE4Ls5U63c_Kc8bLeNGebge87Up9H+NBiQ@mail.gmail.com>
 <pan$9975$a22e4391$1abcb3d9$aba51d08@cox.net>
From: =?UTF-8?Q?Johan_Kr=C3=B6ckel?= <johan.kroeckel@gmail.com>
Date: Mon, 10 Feb 2014 15:05:35 +0100
Message-ID: <CABgvyo_3o0mtPGJsv6zcb9P7SZqF=MurCJ=cS=vYkCNN6wqL5Q@mail.gmail.com>
Subject: Re: lost with degraded RAID1
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
To: unlisted-recipients:; (no To-header on input)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thanks, that explains something.  There was indeed a BIOS-Problem (the
drive vanished was disabled in BIOS suddenly and was only useable
again after reactivating it in the BIOS again). So should have been a
BIOS-problem.

2014-02-09 Duncan <1i5t5.duncan@cox.net>:
> Johan Kröckel posted on Sat, 08 Feb 2014 12:09:46 +0100 as excerpted:
>
>> Ok, I did nuke it now and created the fs again using 3.12 kernel. So far
>> so good. Runs fine.
>> Finally, I know its kind of offtopic, but can some help me interpreting
>> this (I think this is the error in the smart-log which started the whole
>> mess)?
>>
>> Error 1 occurred at disk power-on lifetime: 2576 hours (107 days + 8
>> hours)
>>   When the command that caused the error occurred, the device was
>> active or idle.
>>
>>   After command completion occurred, registers were:
>>   ER ST SC SN CL CH DH
>>   -- -- -- -- -- -- --
>>   04 71 00 ff ff ff 0f
>>  Device Fault; Error: ABRT at LBA = 0x0fffffff = 268435455
>
> I'm no SMART expert, but that LBA number is incredibly suspicious.  With
> standard 512-byte sectors that's the 128 GiB boundary, the old 28-bit LBA
> limit (LBA28, introduced with ATA-1 in 1994, modern drives are LBA48,
> introduced in 2003 with ATA-6 and offering an addressing capacity of 128
> PiB, according to wikipedia's article on LBA).
>
> It looks like something flipped back to LBA28, and when a continuing
> operation happened to write past that value... it triggered the abort you
> see in the SMART log.
>
> Double-check your BIOS to be sure it didn't somehow revert to the old
> LBA28 compatibility mode or some such, and the drives, to make sure they
> aren't "clipped" to LBA28 compatibility mode as well.
>
> --
> Duncan - List replies preferred.   No HTML msgs.
> "Every nonfree program has a lord, a master --
> and if you use the program, he is your master."  Richard Stallman
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
