Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46738 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751488AbdISQv1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 19 Sep 2017 12:51:27 -0400
Subject: Re: Does btrfs use crc32 for error correction?
To: Timofey Titovets <nefelim4ag@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <CAGqmi74kxPpkuYCBwfdyzxUKAHE6TP9x1FGDz0FURud21u=nOA@mail.gmail.com>
From: Eric Sandeen <sandeen@redhat.com>
Message-ID: <63fd4cdb-52d4-4aee-cc82-dbb7eba72a06@redhat.com>
Date: Tue, 19 Sep 2017 11:51:24 -0500
MIME-Version: 1.0
In-Reply-To: <CAGqmi74kxPpkuYCBwfdyzxUKAHE6TP9x1FGDz0FURud21u=nOA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 9/19/17 10:35 AM, Timofey Titovets wrote:
> Stupid question:
> Does btrfs use crc32 for error correction?
> If no, why?
> 
> (AFAIK if using CRC that possible to fix 1 bit flip)
> 
> P.S. I try check that (i create image, create text file, flip bit, try
> read and btrfs show IO-error)
> 
> Thanks!

I wasn't aware that crc32 could (in general) be used for single bit correction; I've read up on that, and it seems pretty cool.
 
However, I don't think that the generator polynomial used in crc32c /can/ be used for error correction.  I just skimmed some reading, but that seems to be the case if I understand it correctly.

-Eric
