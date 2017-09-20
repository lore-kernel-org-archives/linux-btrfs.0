Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f49.google.com ([209.85.218.49]:51905 "EHLO
        mail-oi0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751009AbdITI4i (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 20 Sep 2017 04:56:38 -0400
Received: by mail-oi0-f49.google.com with SMTP id i6so1635130oih.8
        for <linux-btrfs@vger.kernel.org>; Wed, 20 Sep 2017 01:56:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAP9W88ifgTWGE_9Xpro=wUJkMSs9263e0Sw6yeG8Km16rdD6AA@mail.gmail.com>
References: <CAP9W88j+UZCiF6-Bj6Nyh83L=jpTfM5vF-Pz0y09TJ5dsbciZw@mail.gmail.com>
 <CAGqmi74XQkpRwhZ23qyNg7EuGi=aC8aKymUU8g8XeMsLmNHkVA@mail.gmail.com>
 <CAP9W88gs6xYh4MxU--ktS-Ozv8vqs3q84vp52x8OM=Rz3a12vg@mail.gmail.com>
 <CAGqmi74Es55Ptfkyd=sBHdfSoE_rqqyis4juZBbiKc9+LAwMGA@mail.gmail.com>
 <CAP9W88ig1fXyrE0KURbP-1Z0-t63ODADA4HO0tO4KM3eVrRtLg@mail.gmail.com> <CAP9W88ifgTWGE_9Xpro=wUJkMSs9263e0Sw6yeG8Km16rdD6AA@mail.gmail.com>
From: Timofey Titovets <nefelim4ag@gmail.com>
Date: Wed, 20 Sep 2017 11:55:56 +0300
Message-ID: <CAGqmi75DoErKwwHu7+abu62sUbbEgjMZ1ExzpCpQ68JKmTF==g@mail.gmail.com>
Subject: Re: using fio to test btrfs compression
To: shally verma <shallyvermacavium@gmail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>,
        "Verma, Shally" <shally.verma@cavium.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

2017-09-20 11:44 GMT+03:00 shally verma <shallyvermacavium@gmail.com>:
> One more catch... I am initiating fio from non-btrfs filesystem i.e.
> pwd is ext4 based fs where as mount point is btrfs.
> Could that make difference?
>
>> Thanks
>> Shally

Only matter are where you store test file =)
If you store test file on btrfs, pwd does nothing.

-- 
Have a nice day,
Timofey.
