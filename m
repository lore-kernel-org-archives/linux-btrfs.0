Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f175.google.com ([209.85.223.175]:33930 "EHLO
	mail-io0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752627AbbHKVcM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 11 Aug 2015 17:32:12 -0400
Received: by iodb91 with SMTP id b91so1413531iod.1
        for <linux-btrfs@vger.kernel.org>; Tue, 11 Aug 2015 14:32:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtQLv83O2DD+J97Rw-i6FsLrANisSapjxydyx0kJT_vokA@mail.gmail.com>
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
Date: Tue, 11 Aug 2015 17:32:12 -0400
Message-ID: <CAK7bmU_fQhG2mP4x6n-Ga-WmiqJLU5cvRqAPk1Rr9JGYnyMZ2g@mail.gmail.com>
Subject: Re: Damaged filesystem, can read, can't repair, error says to contact devs
From: Timothy Normand Miller <theosib@gmail.com>
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Aug 11, 2015 at 5:24 PM, Chris Murphy <lists@colorremedies.com> wrote:

>> There is still data redundancy.  Will a scrub at least notice that the
>> copies differ?
>
> No, that's what I mean by "nodatasum means no raid1 self-healing is
> possible". You have data redundancy, but without checksums btrfs has
> no way to know if they differ. It doesn't do two reads and compares
> them, it's just like md raid, it picks one device, and so long as
> there's no read error from the device, that copy of the data is
> assumed to be good.

Ok, that makes sense.  I'm guessing it wouldn't be worth it to add a
feature like this because (a) few people use nodatacow or end up in my
situation, and (b) if they did, and the two copies were inconsistent,
what would you do?  I suppose for me, it would be nice to know which
files were affected.


-- 
Timothy Normand Miller, PhD
Assistant Professor of Computer Science, Binghamton University
http://www.cs.binghamton.edu/~millerti/
Open Graphics Project
