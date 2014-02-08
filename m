Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qa0-f44.google.com ([209.85.216.44]:56677 "EHLO
	mail-qa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751228AbaBHLK0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 8 Feb 2014 06:10:26 -0500
Received: by mail-qa0-f44.google.com with SMTP id w5so6828982qac.17
        for <linux-btrfs@vger.kernel.org>; Sat, 08 Feb 2014 03:10:26 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <C37F3250-AA5B-4C75-8ECB-D1E7B6FFEADD@colorremedies.com>
References: <CABgvyo-rw8To-=8_Kt+j8gXiJyX43oWPrWxhAGWqhpE83oCCAw@mail.gmail.com>
 <C0AD9885-8F81-4642-809F-BDC3933A5932@colorremedies.com> <20140130175831.GU3314@carfax.org.uk>
 <C3B0EA86-0CBA-4500-81A8-7F3A99306E76@colorremedies.com> <CABgvyo8ZG=pk=i-7iXzoOWqZj_fVvUd6xiaXef1KWR8QLibhXg@mail.gmail.com>
 <6C293A14-9A38-4DAA-A720-1F77B9CB083D@colorremedies.com> <CABgvyo-cZ1bw7Gyd5sUYK11mMUp3N2w6v=SNEdXBRYqbNSNNFQ@mail.gmail.com>
 <CABgvyo8iS-8i-NKDUPX30B+Mk-B8-ZjLU7p_N7XefXtcSDvCFg@mail.gmail.com> <C37F3250-AA5B-4C75-8ECB-D1E7B6FFEADD@colorremedies.com>
From: =?UTF-8?Q?Johan_Kr=C3=B6ckel?= <johan.kroeckel@gmail.com>
Date: Sat, 8 Feb 2014 12:09:46 +0100
Message-ID: <CABgvyo89WYpOFqb7fE4Ls5U63c_Kc8bLeNGebge87Up9H+NBiQ@mail.gmail.com>
Subject: Re: lost with degraded RAID1
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Ok, I did nuke it now and created the fs again using 3.12 kernel. So
far so good. Runs fine.
Finally, I know its kind of offtopic, but can some help me
interpreting this (I think this is the error in the smart-log which
started the whole mess)?

Error 1 occurred at disk power-on lifetime: 2576 hours (107 days + 8 hours)
  When the command that caused the error occurred, the device was
active or idle.

  After command completion occurred, registers were:
  ER ST SC SN CL CH DH
  -- -- -- -- -- -- --
  04 71 00 ff ff ff 0f  Device Fault; Error: ABRT at LBA = 0x0fffffff
= 268435455

  Commands leading to the command that caused the error were:
  CR FR SC SN CL CH DH DC   Powered_Up_Time  Command/Feature_Name
  -- -- -- -- -- -- -- --  ----------------  --------------------
  61 00 08 ff ff ff 4f 00   5d+04:53:11.169  WRITE FPDMA QUEUED
  61 00 08 80 18 00 40 00   5d+04:52:45.129  WRITE FPDMA QUEUED
  61 00 08 ff ff ff 4f 00   5d+04:52:44.701  WRITE FPDMA QUEUED
  61 00 08 ff ff ff 4f 00   5d+04:52:44.700  WRITE FPDMA QUEUED
  61 00 08 ff ff ff 4f 00   5d+04:52:44.679  WRITE FPDMA QUEUED

2014-02-07 Chris Murphy <lists@colorremedies.com>:
>
> On Feb 7, 2014, at 4:34 AM, Johan Kröckel <johan.kroeckel@gmail.com> wrote:
>
>> Is there anything else I should do with this setup or may I nuke the
>> two partitions and reuse them?
>
> Well I'm pretty sure once you run 'btrfs check --repair' that you've hit the end of the road. Possibly btrfs restore can still extract some files, it might be worth testing whether that works.
>
> Otherwise blow it away. I'd say test with 3.14-rc2 with a new file system and see if you can reproduce the sequence that caused this problem in the first place. If it's reproducible, I think there's a bug here somewhere.
>
>
> Chris Murphy
