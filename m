Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw0-f170.google.com ([209.85.161.170]:33912 "EHLO
        mail-yw0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754252AbdDORGZ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 15 Apr 2017 13:06:25 -0400
Received: by mail-yw0-f170.google.com with SMTP id k13so44214584ywk.1
        for <linux-btrfs@vger.kernel.org>; Sat, 15 Apr 2017 10:06:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <552552ec-6366-04f2-482f-d93d166081e1@gmail.com>
References: <CACh0r45KQb+wLCbRP50WUfe8Loa=zF-Y13n2MhgUbRKi=UT8bw@mail.gmail.com>
 <20170411210023.vfqck3h6nepdow3z@angband.pl> <CAJCQCtTyNUx-P2aPNBE0x2W01qUfrBcHyA-46frM4X+suKMxrw@mail.gmail.com>
 <fdb571b4-0069-b124-8a22-7de09346bee7@gmail.com> <ec5a00c8-5eb8-b7fa-c1e5-5eb72cb3512c@gmail.com>
 <8bc0e7b3-8df9-0def-de34-1a774d361f35@gmail.com> <CAJCQCtTJ-G9_18KSkt-YqL5y+ORRVXACfj80Azq579CSGzKacA@mail.gmail.com>
 <552552ec-6366-04f2-482f-d93d166081e1@gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Sat, 15 Apr 2017 11:06:24 -0600
Message-ID: <CAJCQCtQ6PxF4Y8xbdJaCRxijG3sTyVTN3tnjctOqNXy8GRWhCQ@mail.gmail.com>
Subject: Re: Btrfs disk layout question
To: Andrei Borzenkov <arvidjaar@gmail.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        Adam Borowski <kilobyte@angband.pl>,
        Amin Hassani <ahassani@chromium.org>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Apr 15, 2017 at 12:14 AM, Andrei Borzenkov <arvidjaar@gmail.com> wrote:
> 12.04.2017 20:21, Chris Murphy пишет:
>> btrfs-map-logical is the tool that will convert logical to physical
>> and also give what device it's on; but the device notation is copy 1
>> and copy 2, so you have to infer what device that is, it's not
>> explicit.
>>
>
> Actually I just checked with btrfsprogs 4.5.3 on RAID5 and it does print
> OS device name for each data chunk. It does not show checksum chunk for
> RAID56 though.

There is no checksum chunk. The data csums are in their own tree, and
only data is csum'd. The parity strip is contained within a raid56
chunk but is itself not csum'd.

Another thing that I just thought of might be useful is btrfs-debugfs
which is a python script in btrfs-progs, but typically not packaged.
The -f option pointed at a file will show extents with Btrfs logical
bytenr. So that'd be a way to get all the extents, their addresses and
lengths, to then dump into btrfs-map-logical.

For what it's worth, btrfs-map-logical's physical address it reports
is not device LBA. It's a byte offset on the selected device. So if
the device is a partition, the value is the number of bytes from the
start of that partition.



-- 
Chris Murphy
