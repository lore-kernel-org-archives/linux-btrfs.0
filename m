Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f45.google.com ([209.85.214.45]:34595 "EHLO
        mail-it0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755006AbdBGPnQ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 7 Feb 2017 10:43:16 -0500
Received: by mail-it0-f45.google.com with SMTP id k200so28077187itb.1
        for <linux-btrfs@vger.kernel.org>; Tue, 07 Feb 2017 07:43:16 -0800 (PST)
Subject: Re: BTRFS for OLTP Databases
To: Timofey Titovets <nefelim4ag@gmail.com>
References: <CA+RUij3aW1ZYyJPNRLzckwOCCmoWa15Eu4h142jB_-qKc49hBw@mail.gmail.com>
 <20170207140058.GA4249@carfax.org.uk>
 <CA+RUij02VMTa-L59AD9B3G+g_dS3HO7-Ttsz-qWgJtMyf58sPQ@mail.gmail.com>
 <CAGqmi759eH6QT3Qx_S47_hWKajhwnc0UxyaLhayMEZ4D+bnvGQ@mail.gmail.com>
 <62994104-e9b2-6544-1f3b-bf37df4275f9@gmail.com>
 <CAGqmi772WF8KqMWUowtG2_8uS7KTu3u4vJkNbhTHams_x13jWg@mail.gmail.com>
Cc: Peter Zaitsev <pz@percona.com>, Hugo Mills <hugo@carfax.org.uk>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <716741d9-deef-ebc1-b418-da9f8d23d791@gmail.com>
Date: Tue, 7 Feb 2017 10:43:11 -0500
MIME-Version: 1.0
In-Reply-To: <CAGqmi772WF8KqMWUowtG2_8uS7KTu3u4vJkNbhTHams_x13jWg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-02-07 10:20, Timofey Titovets wrote:
>>> I think that you have a problem with extent bookkeeping (if i
>>> understand how btrfs manage extents).
>>> So for deal with it, try enable compression, as compression will force
>>> all extents to be fragmented with size ~128kb.
>>
>> No, it will compress everything in chunks of 128kB, but it will not fragment
>> things any more than they already would have been (it may actually _reduce_
>> fragmentation because there is less data being stored on disk).  This
>> representation is a bug in the FIEMAP ioctl, it doesn't understand the way
>> BTRFS represents things properly.  IIRC, there was a patch to fix this, but
>> I don't remember what happened with it.
>>
>> That said, in-line compression can help significantly, especially if you
>> have slow storage devices.
>
>
> I mean that:
> You have a 128MB extent, you rewrite random 4k sectors, btrfs will not
> split 128MB extent, and not free up data, (i don't know internal algo,
> so i can't predict when this will hapen), and after some time, btrfs
> will rebuild extents, and split 128 MB exten to several more smaller.
> But when you use compression, allocator rebuilding extents much early
> (i think, it's because btrfs also operates with that like 128kb
> extent, even if it's a continuos 128MB chunk of data).
>
The allocator has absolutely nothing to do with this, it's a function of 
the COW operation.  Unless you're using nodatacow, that 128MB extent 
will get split the moment the data hits the storage device (either on 
the next commit cycle (at most 30 seconds with the default commit 
cycle), or when fdatasync is called, whichever is sooner).  In the case 
of compression, it's still one extent (although on disk it will be less 
than 128MB) and will be split at _exactly_ the same time under _exactly_ 
the same circumstances as an uncompressed extent.  IOW, it has 
absolutely nothing to do with the extent handling either.

The difference arises in that compressed data effectively has a on-media 
block size of 128k, not 16k (the current default block size) or 4k (the 
old default).  This means that the smallest fragment possible for a file 
with in-line compression enabled is 128k, while for a file without it 
it's equal to the filesystem block size.  A larger minimum fragment size 
means that the maximum number of fragments a given file can have is 
smaller (8 times smaller in fact than without compression when using the 
current default block size), which means that there will be less 
fragmentation.

Some rather complex and tedious math indicates that this is not the 
_only_ thing improving performance when using in-line compression, but 
it's probably the biggest thing doing so for the workload being discussed.
