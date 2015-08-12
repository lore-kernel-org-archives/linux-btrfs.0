Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f170.google.com ([209.85.213.170]:34073 "EHLO
	mail-ig0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750769AbbHLUXW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 12 Aug 2015 16:23:22 -0400
Received: by igui7 with SMTP id i7so69487284igu.1
        for <linux-btrfs@vger.kernel.org>; Wed, 12 Aug 2015 13:23:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtTmdwbLYbCQviNETy_w6Rv8=cu_hWtpVSeUMkGX_SX1Yg@mail.gmail.com>
References: <CAK7bmU97q-oz8aSTQijHJR1MQRgOs+F9nHx2hMuqgPO6G5et9g@mail.gmail.com>
	<CAJCQCtS=v+T-qGFLeaELn7Bt+Mb8ViK+8+YgontAE=1ucAnWZg@mail.gmail.com>
	<CAK7bmU_d3RTU4HZVHB9Z7ZAOpQ8C-wZn7WpvYsJaXiGDJki7fg@mail.gmail.com>
	<CAJCQCtQ9kxpuQD3k-rO84O+0jRpiWbCJAUdog+2_Da6EK5yGsQ@mail.gmail.com>
	<CAK7bmU9X8cvPs2sn3eZRaOowoT2H5jthpessWMQSVgvojjJ5EA@mail.gmail.com>
	<CAJCQCtQvkOr0WSOa_hUTCY72esF1euc_qz_FAEVEZ4c4cc+_dQ@mail.gmail.com>
	<CAK7bmU-KrAVoj_2gVGetAyVBNyTuipi2f+VU5SNzEDWxmnizDA@mail.gmail.com>
	<CAJCQCtSzYS=eDDLt_pMBbi8SY94wAXYnZCE_oppDtm8KEwqh1A@mail.gmail.com>
	<CAK7bmU9DVmXoEUBd2dmQPuVUb-iohacHqXvF73uOdaiL1GwtnA@mail.gmail.com>
	<CAJCQCtQLv83O2DD+J97Rw-i6FsLrANisSapjxydyx0kJT_vokA@mail.gmail.com>
	<CAK7bmU9SL7Fxqe+hAbe229Y7Fzegs2Dx42tLXyZ5Wttk+UeZDQ@mail.gmail.com>
	<CAJCQCtTmdwbLYbCQviNETy_w6Rv8=cu_hWtpVSeUMkGX_SX1Yg@mail.gmail.com>
Date: Wed, 12 Aug 2015 16:23:21 -0400
Message-ID: <CAK7bmU9onrSNnPhHu+3j1CsUozVU_WV2HM91k30r=CkhcGcgZw@mail.gmail.com>
Subject: Re: Damaged filesystem, can read, can't repair, error says to contact devs
From: Timothy Normand Miller <theosib@gmail.com>
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Aug 12, 2015 at 2:10 PM, Chris Murphy <lists@colorremedies.com> wrote:

>
> Anyway it looks like it's hardware related, but I don't know what
> device ata4.00 is, so maybe this helps:
> http://superuser.com/questions/617192/mapping-ata-device-number-to-logical-device-name

# ata=4; ls -l /sys/block/sd* | grep $(grep $ata
/sys/class/scsi_host/host*/unique_id | awk -F'/' '{print $5}')
lrwxrwxrwx 1 root root 0 Aug 12 16:21 /sys/block/sde ->
../devices/pci0000:00/0000:00:1f.5/ata4/host3/target3:0:0/3:0:0:0/block/sde

sde is the newly attached drive, replacing the one that had appeared
to have bad sectors.  So it looks like either this new motherboard has
a bad connector, or the cable is bad.  I'm going to swap it out for a
different SATA cable.  How do I resume the failed operation?  And
should I reboot because of the OOPSes?

-- 
Timothy Normand Miller, PhD
Assistant Professor of Computer Science, Binghamton University
http://www.cs.binghamton.edu/~millerti/
Open Graphics Project
