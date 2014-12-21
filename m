Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f181.google.com ([209.85.213.181]:36698 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752891AbaLUDGr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 20 Dec 2014 22:06:47 -0500
Received: by mail-ig0-f181.google.com with SMTP id l13so2726706iga.2
        for <linux-btrfs@vger.kernel.org>; Sat, 20 Dec 2014 19:06:46 -0800 (PST)
MIME-Version: 1.0
Date: Sun, 21 Dec 2014 08:36:46 +0530
Message-ID: <CAHoHJEjqg-TrwAAZeYBTMC=-bPm4zFxh1LoGAWG-QA-Zq09zuw@mail.gmail.com>
Subject: BTRFS for eMMC on Beaglebone Based custom board
From: Ankur Tank <artfri2@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello All,

We are developing Beagle-bone black based Custom board with eMMC.
We want to decide the file-system for RFS partition of eMMC.
We are in process of testing/Benchmarking different file-system on BBB
itself.
Major contributor to writes to the file-system is done by logging process.

To finalize the file-system we need some clarification from developers.
Below are our specific questions. Kindly guide us.

1. We are using Linux kernel 3.12, is Btrfs stable for that version?
2. Is Btrfs suitable for embedded platform and for eMMC kind of memory of
around 2GB/4GB ? Is there any special care to be taken while tuning it ?
Any guidelines ?
3. Some benchmark results shows small sync writes are terrible. How bad is
it ? if it can be tuned, how much can it be tuned?
4. Latest version of btrfs and its compilation(for us cross compilation)
steps are not available in README or in any link, can you provide the steps
?
5. Is there any tuning option to reduce the data loss during sudden power
loss/failures. OR Minimize the delayed allocation.
6. Is Btrfs being used for any embedded platform ?

Sorry if you have received multiple mails,
My previous two mails seems to be rejected because they were HTML format.

Thank you,

Regards,
Ankur
