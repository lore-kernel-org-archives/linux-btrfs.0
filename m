Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f181.google.com ([209.85.213.181]:33332 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751996AbaBJOI2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 10 Feb 2014 09:08:28 -0500
Received: by mail-ig0-f181.google.com with SMTP id j1so6613977iga.2
        for <linux-btrfs@vger.kernel.org>; Mon, 10 Feb 2014 06:08:27 -0800 (PST)
Message-ID: <52F8DD59.6060903@gmail.com>
Date: Mon, 10 Feb 2014 09:08:25 -0500
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
MIME-Version: 1.0
To: Brendan Hide <brendan@swiftspirit.co.za>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Issue with btrfs balance
References: <52F83A69.8080503@gmail.com> <52F8D70B.1090201@swiftspirit.co.za>
In-Reply-To: <52F8D70B.1090201@swiftspirit.co.za>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2014-02-10 08:41, Brendan Hide wrote:
> On 2014/02/10 04:33 AM, Austin S Hemmelgarn wrote:
>> <snip>
>> Apparently, trying to use -mconvert=dup or -sconvert=dup on a
>> multi-device filesystem using one of the RAID profiles for metadata
>> fails with a statement to look at the kernel log, which doesn't show
>> anything at all about the failure.
> ^ If this is the case then it is definitely a bug. Can you provide some
> version info? Specifically kernel, btrfs-tools, and Distro.
In this case, btrfs-progs 3.12, kernel 3.13.2, and Gentoo.
>> <snip> it appears
>> that the kernel stops you from converting to a dup profile for metadata
>> in this case because it thinks that such a profile doesn't work on
>> multiple devices, despite the fact that you can take a single device
>> filesystem, and a device, and it will still work fine even without
>> converting the metadata/system profiles.
> I believe dup used to work on multiple devices but the facility was
> removed. In the standard case it doesn't make sense to use dup with
> multiple devices: It uses the same amount of diskspace but is more
> vulnerable than the RAID1 alternative.
>> <snip> Ideally, this
>> should be changed to allow converting to dup so that when converting a
>> multi-device filesystem to single-device, you never have to have
>> metadata or system chunks use a single profile.
> This is a good use-case for having the facility. I'm thinking that, if
> it is brought back in, the only caveat is that appropriate warnings
> should be put in place to indicate that it is inappropriate.
> 
> My guess on how you'd like to migrate from raid1/raid1 to single/dup,
> assuming sda and sdb:
> btrfs balance start -dconvert=single -mconvert=dup /
> btrfs device delete /dev/sdb /
> 
Ideally, yes.  The exact command I tried to use was:
btrfs balance start -dconvert=single -mconvert=dup -sconvert=dup -f -v /
Trying again without the system chunk conversion also failed.
