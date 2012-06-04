Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vc0-f174.google.com ([209.85.220.174]:46755 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751374Ab2FDQtD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Jun 2012 12:49:03 -0400
Received: by vcbf11 with SMTP id f11so2571843vcb.19
        for <linux-btrfs@vger.kernel.org>; Mon, 04 Jun 2012 09:49:02 -0700 (PDT)
Message-ID: <4FCCE6FC.5050608@gmail.com>
Date: Mon, 04 Jun 2012 12:49:00 -0400
From: Maxim Mikheev <mikhmv@gmail.com>
MIME-Version: 1.0
To: nemesis@icequake.net
CC: "Ryan C. Underwood" <nemesis-lists@icequake.net>,
        Arne Jansen <sensille@gmx.net>, Liu Bo <liubo2009@cn.fujitsu.com>,
        linux-btrfs@vger.kernel.org, Jan Schmidt <list.btrfs@jan-o-sch.net>
Subject: Re: Help with data recovering
References: <4FCA189F.9050000@gmail.com> <4FCC0DD7.9050807@cn.fujitsu.com> <4FCC12BA.9070701@gmail.com> <4FCC1A6F.8050805@cn.fujitsu.com> <4FCC1AE1.8050802@gmail.com> <4FCC2496.6070805@cn.fujitsu.com> <4FCC6F44.2030503@gmx.net> <4FCC9C63.7000605@gmail.com> <4FCC9CD5.2050309@gmx.net> <4FCC9F6C.5090305@gmail.com> <20120604145459.GI25227@localhost.localdomain>
In-Reply-To: <20120604145459.GI25227@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--super works but my root tree 2 has many errors too.

What can I do next?

Thanks

On 06/04/2012 10:54 AM, Ryan C. Underwood wrote:
> On Mon, Jun 04, 2012 at 07:43:40AM -0400, Maxim Mikheev wrote:
>> alternate copy you wish to use. In the following example we ask for
>> using the superblock copy #2 of /dev/sda7:
>>
>> # ./btrfsck -s 2 /dev/sd7
>>
>> -----------------------------------------
>> but it gave me:
>> $ sudo btrfsck -s 2 /dev/sdb
>> btrfsck: invalid option -- 's'
>> usage: btrfsck dev
>> Btrfs Btrfs v0.19
>>
>> What can I do more?
> I have found that due to an error in getopt_long() usage, btrfsck does
> not accept the short-form option.  Use --super instead.
>
