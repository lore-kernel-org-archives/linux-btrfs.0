Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:32910 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754695AbdLUSvw (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 21 Dec 2017 13:51:52 -0500
Subject: Re: Btrfs allow compression on NoDataCow files? (AFAIK Not, but it
 does)
To: Timofey Titovets <nefelim4ag@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <CAGqmi740EcovePxQswsZ=yh9E5Y1zLKCBaTvFN0EE_AuVPpQ7A@mail.gmail.com>
From: Chris Mason <clm@fb.com>
Message-ID: <7c9740db-b979-677f-6285-2e8073eb1853@fb.com>
Date: Thu, 21 Dec 2017 13:51:40 -0500
MIME-Version: 1.0
In-Reply-To: <CAGqmi740EcovePxQswsZ=yh9E5Y1zLKCBaTvFN0EE_AuVPpQ7A@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 12/20/2017 03:59 PM, Timofey Titovets wrote:
> How reproduce:
> touch test_file
> chattr +C test_file
> dd if=/dev/zero of=test_file bs=1M count=1
> btrfs fi def -vrczlib test_file
> filefrag -v test_file
> 
> test_file
> Filesystem type is: 9123683e
> File size of test_file is 1048576 (256 blocks of 4096 bytes)
> ext:     logical_offset:        physical_offset: length:   expected: flags:
>    0:        0..      31:   72917050..  72917081:     32:             encoded
>    1:       32..      63:   72917118..  72917149:     32:   72917082: encoded
>    2:       64..      95:   72919494..  72919525:     32:   72917150: encoded
>    3:       96..     127:   72927576..  72927607:     32:   72919526: encoded
>    4:      128..     159:   72943261..  72943292:     32:   72927608: encoded
>    5:      160..     191:   72944929..  72944960:     32:   72943293: encoded
>    6:      192..     223:   72944952..  72944983:     32:   72944961: encoded
>    7:      224..     255:   72967084..  72967115:     32:   72944984:
> last,encoded,eof
> test_file: 8 extents found
> 
> I can't found at now, where that error happen in code,
> but it's reproducible on Linux 4.14.8

We'll silently cow in a few cases, this is one.

-chris
