Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f53.google.com ([209.85.215.53]:36654 "EHLO
        mail-lf0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754088AbdBGPBg (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 7 Feb 2017 10:01:36 -0500
Received: by mail-lf0-f53.google.com with SMTP id z134so64504446lff.3
        for <linux-btrfs@vger.kernel.org>; Tue, 07 Feb 2017 07:01:35 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CA+RUij02VMTa-L59AD9B3G+g_dS3HO7-Ttsz-qWgJtMyf58sPQ@mail.gmail.com>
References: <CA+RUij3aW1ZYyJPNRLzckwOCCmoWa15Eu4h142jB_-qKc49hBw@mail.gmail.com>
 <20170207140058.GA4249@carfax.org.uk> <CA+RUij02VMTa-L59AD9B3G+g_dS3HO7-Ttsz-qWgJtMyf58sPQ@mail.gmail.com>
From: Timofey Titovets <nefelim4ag@gmail.com>
Date: Tue, 7 Feb 2017 18:00:53 +0300
Message-ID: <CAGqmi759eH6QT3Qx_S47_hWKajhwnc0UxyaLhayMEZ4D+bnvGQ@mail.gmail.com>
Subject: Re: BTRFS for OLTP Databases
To: Peter Zaitsev <pz@percona.com>
Cc: Hugo Mills <hugo@carfax.org.uk>, linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

2017-02-07 17:13 GMT+03:00 Peter Zaitsev <pz@percona.com>:
> Hi Hugo,
>
> For the use case I'm looking for I'm interested in having snapshot(s)
> open at all time.  Imagine  for example snapshot being created every
> hour and several of these snapshots  kept at all time providing quick
> recovery points to the state of 1,2,3 hours ago.  In  such case (as I
> think you also describe)  nodatacow  does not provide any advantage.
>
> I have not seen autodefrag helping much but I will try again.     Is
> there any autodefrag documentation available about how is it expected
> to work and if it can be tuned in any way
>
> I noticed remounting already fragmented filesystem with autodefrag
> and putting workload  which does more fragmentation does not seem to
> improve over time
>
>
>
>>    Well, nodatacow will still allow snapshots to work, but it also
>> allows the data to fragment. Each snapshot made will cause subsequent
>> writes to shared areas to be CoWed once (and then it reverts to
>> unshared and nodatacow again).
>>
>>    There's another approach which might be worth testing, which is to
>> use autodefrag. This will increase data write I/O, because where you
>> have one or more small writes in a region, it will also read and write
>> the data in a small neghbourhood around those writes, so the
>> fragmentation is reduced. This will improve subsequent read
>> performance.
>>
>>    I could also suggest getting the latest kernel you can -- 16.04 is
>> already getting on for a year old, and there may be performance
>> improvements in upstream kernels which affect your workload. There's
>> an Ubuntu kernel PPA you can use to get the new kernels without too
>> much pain.
>
>
>
>
>
>
>
> --
> Peter Zaitsev, CEO, Percona
> Tel: +1 888 401 3401 ext 7360   Skype:  peter_zaitsev
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

I think that you have a problem with extent bookkeeping (if i
understand how btrfs manage extents).
So for deal with it, try enable compression, as compression will force
all extents to be fragmented with size ~128kb.

I did have a similar problem with MySQL (Zabbix as a workload, i.e.
most time load are random write), and i fix it, by enabling
compression. (I use debian with latest kernel from backports)
At now it just works with stable speed under stable load.

P.S.
(And i also use your percona MySQL some time, it's cool).

-- 
Have a nice day,
Timofey.
