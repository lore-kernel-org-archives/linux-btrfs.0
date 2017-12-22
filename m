Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:52840 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1756833AbdLVX6S (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 22 Dec 2017 18:58:18 -0500
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1eSXAj-0002Di-GE
        for linux-btrfs@vger.kernel.org; Sat, 23 Dec 2017 00:56:13 +0100
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: Btrfs allow compression on NoDataCow files? (AFAIK Not, but it
 does)
Date: Sat, 23 Dec 2017 00:58:02 +0100
Message-ID: <api0he-ufq.ln1@hurikhan77.spdns.de>
References: <CAGqmi740EcovePxQswsZ=yh9E5Y1zLKCBaTvFN0EE_AuVPpQ7A@mail.gmail.com>
        <7c9740db-b979-677f-6285-2e8073eb1853@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Thu, 21 Dec 2017 13:51:40 -0500 schrieb Chris Mason:

> On 12/20/2017 03:59 PM, Timofey Titovets wrote:
>> How reproduce:
>> touch test_file
>> chattr +C test_file
>> dd if=/dev/zero of=test_file bs=1M count=1
>> btrfs fi def -vrczlib test_file
>> filefrag -v test_file
>> 
>> test_file
>> Filesystem type is: 9123683e
>> File size of test_file is 1048576 (256 blocks of 4096 bytes)
>> ext:     logical_offset:        physical_offset: length:   expected: flags:
>>    0:        0..      31:   72917050..  72917081:     32:             encoded
>>    1:       32..      63:   72917118..  72917149:     32:   72917082: encoded
>>    2:       64..      95:   72919494..  72919525:     32:   72917150: encoded
>>    3:       96..     127:   72927576..  72927607:     32:   72919526: encoded
>>    4:      128..     159:   72943261..  72943292:     32:   72927608: encoded
>>    5:      160..     191:   72944929..  72944960:     32:   72943293: encoded
>>    6:      192..     223:   72944952..  72944983:     32:   72944961: encoded
>>    7:      224..     255:   72967084..  72967115:     32:   72944984:
>> last,encoded,eof
>> test_file: 8 extents found
>> 
>> I can't found at now, where that error happen in code,
>> but it's reproducible on Linux 4.14.8
> 
> We'll silently cow in a few cases, this is one.

I think the question was about compression, not cow.

I can reproduce this behavior:

$ touch nocow.dat
$ touch cow.dat
$ chattr +c cow.dat
$ chattr +C nocow.dat
$ dd if=/dev/zero of=cow.dat count=1 bs=1M
$ dd if=/dev/zero of=nocow.dat count=1 bs=1M

$ filefrag -v cow.dat
Filesystem type is: 9123683e
File size of cow.dat is 1048576 (256 blocks of 4096 bytes)
 ext:     logical_offset:        physical_offset: length:   expected: flags:
   0:        0..      31: 1044845154..1044845185:     32:             encoded,shared
   1:       32..      63: 1044845166..1044845197:     32: 1044845186: encoded,shared
   2:       64..      95: 1044845167..1044845198:     32: 1044845198: encoded,shared
   3:       96..     127: 1044851064..1044851095:     32: 1044845199: encoded,shared
   4:      128..     159: 1044851065..1044851096:     32: 1044851096: encoded,shared
   5:      160..     191: 1044852160..1044852191:     32: 1044851097: encoded,shared
   6:      192..     223: 1044943106..1044943137:     32: 1044852192: encoded,shared
   7:      224..     255: 1045054792..1045054823:     32: 1044943138: last,encoded,shared,eof
cow.dat: 8 extents found

$ filefrag -v nocow.dat 
Filesystem type is: 9123683e
File size of nocow.dat is 1048576 (256 blocks of 4096 bytes)
 ext:     logical_offset:        physical_offset: length:   expected: flags:
   0:        0..     255: 1196077983..1196078238:    256:             last,shared,eof
nocow.dat: 1 extent found

Now it seems to be compressed (8x 128k extents):

$ filefrag -v nocow.dat          
Filesystem type is: 9123683e
File size of nocow.dat is 1048576 (256 blocks of 4096 bytes)
 ext:     logical_offset:        physical_offset: length:   expected: flags:
   0:        0..      31: 1121866367..1121866398:     32:             encoded,shared
   1:       32..      63: 1121866369..1121866400:     32: 1121866399: encoded,shared
   2:       64..      95: 1121866370..1121866401:     32: 1121866401: encoded,shared
   3:       96..     127: 1121866371..1121866402:     32: 1121866402: encoded,shared
   4:      128..     159: 1121866372..1121866403:     32: 1121866403: encoded,shared
   5:      160..     191: 1121866373..1121866404:     32: 1121866404: encoded,shared
   6:      192..     223: 1121866374..1121866405:     32: 1121866405: encoded,shared
   7:      224..     255: 1121866375..1121866406:     32: 1121866406: last,encoded,shared,eof
nocow.dat: 8 extents found


-- 
Regards,
Kai

Replies to list-only preferred.

