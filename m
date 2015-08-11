Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f48.google.com ([209.85.213.48]:34341 "EHLO
	mail-vk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752160AbbHKVYB (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 11 Aug 2015 17:24:01 -0400
Received: by vkhl6 with SMTP id l6so75371230vkh.1
        for <linux-btrfs@vger.kernel.org>; Tue, 11 Aug 2015 14:24:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAK7bmU9DVmXoEUBd2dmQPuVUb-iohacHqXvF73uOdaiL1GwtnA@mail.gmail.com>
References: <CAK7bmU97q-oz8aSTQijHJR1MQRgOs+F9nHx2hMuqgPO6G5et9g@mail.gmail.com>
	<CAJCQCtS=v+T-qGFLeaELn7Bt+Mb8ViK+8+YgontAE=1ucAnWZg@mail.gmail.com>
	<CAK7bmU_d3RTU4HZVHB9Z7ZAOpQ8C-wZn7WpvYsJaXiGDJki7fg@mail.gmail.com>
	<CAJCQCtQ9kxpuQD3k-rO84O+0jRpiWbCJAUdog+2_Da6EK5yGsQ@mail.gmail.com>
	<CAK7bmU9X8cvPs2sn3eZRaOowoT2H5jthpessWMQSVgvojjJ5EA@mail.gmail.com>
	<CAJCQCtQvkOr0WSOa_hUTCY72esF1euc_qz_FAEVEZ4c4cc+_dQ@mail.gmail.com>
	<CAK7bmU-KrAVoj_2gVGetAyVBNyTuipi2f+VU5SNzEDWxmnizDA@mail.gmail.com>
	<CAJCQCtSzYS=eDDLt_pMBbi8SY94wAXYnZCE_oppDtm8KEwqh1A@mail.gmail.com>
	<CAK7bmU9DVmXoEUBd2dmQPuVUb-iohacHqXvF73uOdaiL1GwtnA@mail.gmail.com>
Date: Tue, 11 Aug 2015 15:24:00 -0600
Message-ID: <CAJCQCtQLv83O2DD+J97Rw-i6FsLrANisSapjxydyx0kJT_vokA@mail.gmail.com>
Subject: Re: Damaged filesystem, can read, can't repair, error says to contact devs
From: Chris Murphy <lists@colorremedies.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Aug 11, 2015 at 3:00 PM, Timothy Normand Miller
<theosib@gmail.com> wrote:
> On Tue, Aug 11, 2015 at 4:48 PM, Chris Murphy <lists@colorremedies.com> wrote:
>
>>
>> The compress is ignored, and it looks like nodatasum and nodatacow
>> apply to everything. The nodatasum means no raid1 self-healing is
>> possible for any data on the entire volume. Metadata checksumming is
>> still enabled.
>
> Ugh.  So I need to change my fstab file.  I swear, some expert on IRC
> told me that this should work fine, which is why I did it.  In fact, I
> think they recommended it on the basis that I wanted to put VM images
> on one of the subvolumes.  This discussion occurred a long time ago,
> well before RAID5 was even partially implemented.
>
> There is still data redundancy.  Will a scrub at least notice that the
> copies differ?

No, that's what I mean by "nodatasum means no raid1 self-healing is
possible". You have data redundancy, but without checksums btrfs has
no way to know if they differ. It doesn't do two reads and compares
them, it's just like md raid, it picks one device, and so long as
there's no read error from the device, that copy of the data is
assumed to be good.



-- 
Chris Murphy
