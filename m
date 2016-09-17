Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:35327 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754121AbcIQS5G (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 17 Sep 2016 14:57:06 -0400
Received: by mail-oi0-f67.google.com with SMTP id 2so9345831oif.2
        for <linux-btrfs@vger.kernel.org>; Sat, 17 Sep 2016 11:57:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <b205136c-5680-c7cd-0862-b81d24a4b8e0@oracle.com>
References: <20160917065831.GA14388@google.com> <b205136c-5680-c7cd-0862-b81d24a4b8e0@oracle.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Sat, 17 Sep 2016 12:57:04 -0600
Message-ID: <CAJCQCtRiNbxu0W9tdJ+qvo7LyKMXpF=pvGbMU1h=i9rrb4gkEQ@mail.gmail.com>
Subject: Re: [RFC] Preliminary BTRFS Encryption
To: Anand Jain <anand.jain@oracle.com>
Cc: Eric Biggers <ebiggers@google.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>, eternaleye@gmail.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Sep 17, 2016 at 10:12 AM, Anand Jain <anand.jain@oracle.com> wrote:

>   btrfs keeps it only in-memory and key hash goes to the disk.
>   Further in the long we need an integration with key management
>   system as well.

Maybe LUKS2 is usable for this part, and still adaptable since it's
not finished yet? It looks to me like essentially unlimited keyslots
compared to the current 8. You don't really care about the dm-crypt
part of it, but the key management part of it, perhaps.

Both the original and new subvolumes initially share one DEK that go
with the shared encrypted extents, but upon snapshot happening the new
extents in each subvolume need their own DEK. Policy wise these DEKs
can be wrapped in the same or separate passphrases or KEKs, as there
could be hundreds or thousands of DEKs that apply to the many possible
shared encrypted extents in a subvolume. If that's true, then it's an
explosive number of keys per subvolume potentially. It doesn't depend
on space as much as it depends on fs lifetime

Otherwise I don't see how this is different than using a single DEK
across all company hard drives. Compromise one, you've compromised
them all.



-- 
Chris Murphy
