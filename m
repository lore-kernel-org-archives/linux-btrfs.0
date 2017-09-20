Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f53.google.com ([209.85.218.53]:45762 "EHLO
        mail-oi0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751378AbdITBxP (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 19 Sep 2017 21:53:15 -0400
Received: by mail-oi0-f53.google.com with SMTP id z73so609931oia.2
        for <linux-btrfs@vger.kernel.org>; Tue, 19 Sep 2017 18:53:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <A026785F-2C95-41B9-9D79-EE0672981C72@rqc.ru>
References: <CAGqmi74kxPpkuYCBwfdyzxUKAHE6TP9x1FGDz0FURud21u=nOA@mail.gmail.com>
 <63fd4cdb-52d4-4aee-cc82-dbb7eba72a06@redhat.com> <A026785F-2C95-41B9-9D79-EE0672981C72@rqc.ru>
From: Timofey Titovets <nefelim4ag@gmail.com>
Date: Wed, 20 Sep 2017 04:52:33 +0300
Message-ID: <CAGqmi76N5nyH-DkaYegg9O+9EHWqppF4ZAZoVXNx5eTMnYM=tQ@mail.gmail.com>
Subject: Re: Does btrfs use crc32 for error correction?
To: Marat Khalili <mkh@rqc.ru>
Cc: Eric Sandeen <sandeen@redhat.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

2017-09-19 21:04 GMT+03:00 Marat Khalili <mkh@rqc.ru>:
> Would be cool, but probably not wise IMHO, since on modern hardware you almost never get one-bit errors (usually it's a whole sector of garbage), and therefore you'd more often see an incorrect recovery than actually fixed bit.
> --
>
> With Best Regards,
> Marat Khalili

Over the past 2 months, I've thinking about some parity solution for
btrfs to have a trade-off between full duplication and single
profiles.

Something like the variable stripe len for mate(data), to fix one
sector's errors.
that is, calculate a one-time parity for each written extent.

But for now, I think that this can not be fixed without tricks or
changing the format.
(Because if you do this in FS lvl, i.e. use a space in B-Tree, this
will create one more exception, if you do this at block level, that
needs a "new" raid5, it's not cool).
But these are only my thoughts.

Therefore, I was recall that CRC in theory allow fixup one bit of error,
but for now, I do not have enough knowledge about CRC to try and
implement a proof of concept for this = \.

(I think that can be usefull not only in btrfs code, i.e. one bit CRC
correction)

But I also remember that btrfs have a lot of unused checksum space in
the checksum tree:
32 bytes of the checksum field, 4 bytes for CRC32C => 28 bytes of freedom =)

So for now I think about calculating the parity with the checksum data,
Proof of the concept (code):
https://github.com/Nefelim4ag/CRC32C_AND_8Byte_parity

As I see it:
1. Btrfs calculates parity 8/16 bytes and 4 bytes of CRC32C
    8/16 bytes stored at the end of the field.
2. Compatibility bits?
    Reason for absence:
     - For an old kernel that does not change anything, it's the same
for old btrfs progs
     - That possible to silent assume that it's have a parity and try
use it and fixup
     Because if it's missing or broken, we just fall back to old behaviour
    Reason for Yes:
     - May be we need to show by something that btrfs has parity +
CRC32 for this data?
3. For x86_64, this works comparably fast with HW CRC32
    --- Checking speed of hash / parity functions ---
    PAGE_SIZE: 4096, number of cycles: 1048576
    Parity64:   0xf7182ccbfc34f088    perf: 233750 usec, th:
18374.191641 MiB / s
    parity32:   0xb2cdc43                    perf: 464824 μs,    th:
9239.986094 MiB / s
    crc32:       0xa4aa10b2                 perf: 312446 μs,     th:
13746.270703 MiB / s
    xxhash64: 0x77e7064e1a16f422 perf: 367570 μs,     th: 11684.760171 MiB / s
4. If a CRC mismatch detected, try to correct the data by parity (for
single profile only):
4.1 Make a tmp data copy
4.2. Suppose that the 0+N block / stripe damaged
       inverse computation of that block from parity
4.3 Check CRC for page:
       - mismatch? -> N + 1 -> Go to 3.1
       - match? -> Hooray! -> Overwrite broken block

That solution will easy fix for most sort of bit flips and up to 1-16
byte -local- corruption

Possible parity combinations:
1 byte: x1 or x2 or x4 or x8 or x16
2 byte: x1 or x2 or x4 or x8
4 byte: x1 or x2 or x4
8 byte: x1 or x2 - fastest on x86_64 (i didn't have other CPUs)

That you think about that?

Thanks.

P.S.
Script for reproduction of 1 bit error case, where FS can't be mounted:
#!/bin/bash

DISK_IMAGE=$(mktemp)
MNT_TMP_DIR="$(mktemp -d)"

truncate -s 48M $DISK_IMAGE
mkfs.btrfs -f -L CRC_TEST -m single $DISK_IMAGE

TMP_DIR="$(mktemp -d)"

mount $DISK_IMAGE $MNT_TMP_DIR
echo "Test String: some_text_data" | tee $MNT_TMP_DIR/file.txt
umount $MNT_TMP_DIR

echo "Add 1 bit error: o -> n"
sed -i 's/some_text_data/snme_text_data/g' $DISK_IMAGE
btrfs check -b -p $DISK_IMAGE

echo "Fix 1 bit error: n -> o"
sed -i 's/snme_text_data/some_text_data/g' $DISK_IMAGE
btrfs check -b -p $DISK_IMAGE

mount $DISK_IMAGE $MNT_TMP_DIR
cat $MNT_TMP_DIR/file.txt
umount $MNT_TMP_DIR

rm -fv "$DISK_IMAGE"


-- 
Have a nice day,
Timofey.
