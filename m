Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f176.google.com ([209.85.223.176]:33575 "EHLO
	mail-io0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753401AbbHRVKo (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 18 Aug 2015 17:10:44 -0400
Received: by iods203 with SMTP id s203so204955199iod.0
        for <linux-btrfs@vger.kernel.org>; Tue, 18 Aug 2015 14:10:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtT3kGNZ3vcvhjP==6L402Zys=a3mHexErajTSDDbNBdNw@mail.gmail.com>
References: <CAK7bmU88ZfLJmFfMiV=q9RjS+=vAWbniu9w6MUTv_xSG+-hj_g@mail.gmail.com>
	<55D1C8D3.5090501@gmail.com>
	<CAK7bmU_oXstgxwkWY_6tSc90aU-=WKh0TLH+1Xw+ec3YZogzbQ@mail.gmail.com>
	<55D31533.4040409@gmail.com>
	<CAJCQCtT3kGNZ3vcvhjP==6L402Zys=a3mHexErajTSDDbNBdNw@mail.gmail.com>
Date: Tue, 18 Aug 2015 17:10:43 -0400
Message-ID: <CAK7bmU9iREGMYAXaHU4ffpbCrBCGa_pBxgYEe6sMPdRAsU79VQ@mail.gmail.com>
Subject: Re: So, wipe it out and start over or keep debugging?
From: Timothy Normand Miller <theosib@gmail.com>
To: Chris Murphy <lists@colorremedies.com>
Cc: Austin S Hemmelgarn <ahferroin7@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I was doing it on an unmounted volume anyhow.

On Tue, Aug 18, 2015 at 5:09 PM, Chris Murphy <lists@colorremedies.com> wrote:
> On Tue, Aug 18, 2015 at 5:21 AM, Austin S Hemmelgarn
> <ahferroin7@gmail.com> wrote:
>> On 2015-08-17 14:52, Timothy Normand Miller wrote:
>>>
>>> I'm not sure if I'm doing this wrong.  Here's what I'm seeing:
>>>
>>> # btrfs-image -c9 -t4 -w /mnt/btrfs ~/btrfs_dump.z
>>> Superblock bytenr is larger than device size
>>> Open ctree failed
>>> create failed (No such file or directory)
>>
>>
>> For the source, you need to specify the underlying block device, not the top
>> of the mounted filesystem.  It's trying to read the directory as a block
>> device and getting very confused.  We should probably add some kind of check
>> to btrfs-image to warn about that.
>
> Should it even be possible to use btrfs-image on a mounted volume? If
> it's written to at all, the collected image is going to be
> inconsistent.
>
> --
> Chris Murphy



-- 
Timothy Normand Miller, PhD
Assistant Professor of Computer Science, Binghamton University
http://www.cs.binghamton.edu/~millerti/
Open Graphics Project
