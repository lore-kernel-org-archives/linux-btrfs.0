Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f176.google.com ([209.85.223.176]:33951 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752219AbaARAtk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 17 Jan 2014 19:49:40 -0500
Received: by mail-ie0-f176.google.com with SMTP id lx4so6311124iec.21
        for <linux-btrfs@vger.kernel.org>; Fri, 17 Jan 2014 16:49:40 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <AE93F05D-BEE7-4CE6-970E-137EA41D1C7B@aei.mpg.de>
References: <AE93F05D-BEE7-4CE6-970E-137EA41D1C7B@aei.mpg.de>
Date: Fri, 17 Jan 2014 18:49:39 -0600
Message-ID: <CAE5mzvi9SZ5oz+xppZT5B-EE1J6K1p1M00iMFzmG-s+Q6S14iQ@mail.gmail.com>
Subject: Re: btrfs and ECC RAM
From: cwillu <cwillu@cwillu.com>
To: Ian Hinder <ian.hinder@aei.mpg.de>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jan 17, 2014 at 6:23 PM, Ian Hinder <ian.hinder@aei.mpg.de> wrote:
> Hi,
>
> I have been reading a lot of articles online about the dangers of using ZFS with non-ECC RAM.  Specifically, the fact that when good data is read from disk and compared with its checksum, a RAM error can cause the read data to be incorrect, causing a checksum failure, and the bad data might now be written back to the disk in an attempt to correct it, corrupting it in the process.  This would be exacerbated by a scrub, which could run through all your data and potentially corrupt it.  There is a strong current of opinion that using ZFS without ECC RAM is "suicide for your data".

That sounds entirely silly:  a scrub will only write data to the disk
that has actually passed a checksum. In order for that to corrupt
something on disk, you'd have to have a perfect storm of correct and
corrupt reads, and in every such case thta I can think of, you'd be
worse off without checksums than if you had them.
