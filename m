Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yk0-f176.google.com ([209.85.160.176]:40053 "EHLO
	mail-yk0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752893AbaLUDnd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 20 Dec 2014 22:43:33 -0500
Received: by mail-yk0-f176.google.com with SMTP id q200so1431161ykb.21
        for <linux-btrfs@vger.kernel.org>; Sat, 20 Dec 2014 19:43:32 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAHoHJEjqg-TrwAAZeYBTMC=-bPm4zFxh1LoGAWG-QA-Zq09zuw@mail.gmail.com>
References: <CAHoHJEjqg-TrwAAZeYBTMC=-bPm4zFxh1LoGAWG-QA-Zq09zuw@mail.gmail.com>
Date: Sat, 20 Dec 2014 20:43:32 -0700
Message-ID: <CAJCQCtSL5guOtdYSJkf4Q+dAA3WcHsp-k5Dv+-cuwTiVWqbi4w@mail.gmail.com>
Subject: Re: BTRFS for eMMC on Beaglebone Based custom board
From: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
To: unlisted-recipients:; (no To-header on input)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Dec 20, 2014 at 8:06 PM, Ankur Tank <artfri2@gmail.com> wrote:
> Hello All,
>
> We are developing Beagle-bone black based Custom board with eMMC.
> We want to decide the file-system for RFS partition of eMMC.
> We are in process of testing/Benchmarking different file-system on BBB
> itself.
> Major contributor to writes to the file-system is done by logging process.
>
> To finalize the file-system we need some clarification from developers.
> Below are our specific questions. Kindly guide us.
>
> 1. We are using Linux kernel 3.12, is Btrfs stable for that version?
> 2. Is Btrfs suitable for embedded platform and for eMMC kind of memory of
> around 2GB/4GB ? Is there any special care to be taken while tuning it ?
> Any guidelines ?
> 3. Some benchmark results shows small sync writes are terrible. How bad is
> it ? if it can be tuned, how much can it be tuned?
> 4. Latest version of btrfs and its compilation(for us cross compilation)
> steps are not available in README or in any link, can you provide the steps
> ?
> 5. Is there any tuning option to reduce the data loss during sudden power
> loss/failures. OR Minimize the delayed allocation.
> 6. Is Btrfs being used for any embedded platform ?
>
> Sorry if you have received multiple mails,
> My previous two mails seems to be rejected because they were HTML format.
>

Ran across this the other day. But it's much newer kernels than what
you're targeting. My expectation is that at a minimum you need to test
your actual use case in-progress while sabotaging it with the expected
failure vectors. You may have back porting work to do.

http://events.linuxfoundation.jp/sites/events/files/slides/linux_file_system_analysis_for_IVI_systems.pdf

-- 
Chris Murphy
