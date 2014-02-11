Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f172.google.com ([209.85.192.172]:38987 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752211AbaBKDfh (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 10 Feb 2014 22:35:37 -0500
Received: by mail-pd0-f172.google.com with SMTP id p10so6944611pdj.31
        for <linux-btrfs@vger.kernel.org>; Mon, 10 Feb 2014 19:35:37 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAE5mzvh+1EY-eF_frWHTBkmjOFgwEWva5UysF6PHjeaOajEytg@mail.gmail.com>
References: <52F9014F.6070901@fb.com>
	<20140210170606.GK6490@carfax.org.uk>
	<CAE5mzvgFLfQoaNx1eWB2z_kJW-pe1bFY_3LxDMV9XbtKApo=xw@mail.gmail.com>
	<ldbsqr$dlg$1@ger.gmane.org>
	<CAE5mzvh+1EY-eF_frWHTBkmjOFgwEWva5UysF6PHjeaOajEytg@mail.gmail.com>
Date: Mon, 10 Feb 2014 19:35:37 -0800
Message-ID: <CAN05THSux8=CcQpTD4Ydqhyq6E-fyQ9OfRX69nC2U_z2yohjFw@mail.gmail.com>
Subject: Re: What to do about df and btrfs fi df
From: ronnie sahlberg <ronniesahlberg@gmail.com>
To: cwillu <cwillu@cwillu.com>
Cc: Roger Binns <rogerb@rogerbinns.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Feb 10, 2014 at 7:13 PM, cwillu <cwillu@cwillu.com> wrote:
> On Mon, Feb 10, 2014 at 7:02 PM, Roger Binns <rogerb@rogerbinns.com> wrote:
>> -----BEGIN PGP SIGNED MESSAGE-----
>> Hash: SHA1
>>
>> On 10/02/14 10:24, cwillu wrote:
>>> The regular df data used number should be the amount of space required
>>> to hold a backup of that content (assuming that the backup maintains
>>> reflinks and compression and so forth).
>>>
>>> There's no good answer for available space;
>>
>> I think the flipside of the above works well.  How large a group of files
>> can you expect to create before you will get ENOSPC?
>>
>> That for example is the check code does that looks at df - "I need to put
>> in XGB of files - will it fit?"  It is also what users do.
>
> But the answer changes dramatically depending on whether it's large
> numbers of small files or a small number of large files, and the
> conservative worst-case choice means we report a number that is half
> what is probably expected.

I don't think that is a problem, as long as the "avail guesstimate" is
conservative.

Scenario:
A user has 10G of files and df reports that there are 11G available.
I think the expectation is that copying these 10G into the filesystem
will not ENOSPC.
After the copy completes, whether the new avail number is ==1G or >>1G
is less important IMHO.

I.e. I like to see df output as a "you can write AT LEAST this much
more data until the filesystem is full".


That was my 5 cent.
