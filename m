Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f47.google.com ([209.85.215.47]:33219 "EHLO
        mail-lf0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752836AbdBGPVd (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 7 Feb 2017 10:21:33 -0500
Received: by mail-lf0-f47.google.com with SMTP id x1so64949585lff.0
        for <linux-btrfs@vger.kernel.org>; Tue, 07 Feb 2017 07:21:32 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <62994104-e9b2-6544-1f3b-bf37df4275f9@gmail.com>
References: <CA+RUij3aW1ZYyJPNRLzckwOCCmoWa15Eu4h142jB_-qKc49hBw@mail.gmail.com>
 <20170207140058.GA4249@carfax.org.uk> <CA+RUij02VMTa-L59AD9B3G+g_dS3HO7-Ttsz-qWgJtMyf58sPQ@mail.gmail.com>
 <CAGqmi759eH6QT3Qx_S47_hWKajhwnc0UxyaLhayMEZ4D+bnvGQ@mail.gmail.com> <62994104-e9b2-6544-1f3b-bf37df4275f9@gmail.com>
From: Timofey Titovets <nefelim4ag@gmail.com>
Date: Tue, 7 Feb 2017 18:20:50 +0300
Message-ID: <CAGqmi772WF8KqMWUowtG2_8uS7KTu3u4vJkNbhTHams_x13jWg@mail.gmail.com>
Subject: Re: BTRFS for OLTP Databases
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: Peter Zaitsev <pz@percona.com>, Hugo Mills <hugo@carfax.org.uk>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

>> I think that you have a problem with extent bookkeeping (if i
>> understand how btrfs manage extents).
>> So for deal with it, try enable compression, as compression will force
>> all extents to be fragmented with size ~128kb.
>
> No, it will compress everything in chunks of 128kB, but it will not fragment
> things any more than they already would have been (it may actually _reduce_
> fragmentation because there is less data being stored on disk).  This
> representation is a bug in the FIEMAP ioctl, it doesn't understand the way
> BTRFS represents things properly.  IIRC, there was a patch to fix this, but
> I don't remember what happened with it.
>
> That said, in-line compression can help significantly, especially if you
> have slow storage devices.


I mean that:
You have a 128MB extent, you rewrite random 4k sectors, btrfs will not
split 128MB extent, and not free up data, (i don't know internal algo,
so i can't predict when this will hapen), and after some time, btrfs
will rebuild extents, and split 128 MB exten to several more smaller.
But when you use compression, allocator rebuilding extents much early
(i think, it's because btrfs also operates with that like 128kb
extent, even if it's a continuos 128MB chunk of data).

-- 
Have a nice day,
Timofey.
