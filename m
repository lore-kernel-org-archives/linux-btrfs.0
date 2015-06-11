Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f196.google.com ([209.85.220.196]:36720 "EHLO
	mail-qk0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752208AbbFKRNn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 11 Jun 2015 13:13:43 -0400
Received: by qkby64 with SMTP id y64so1884546qkb.3
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Jun 2015 10:13:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20150611170901.GG6761@twin.jikos.cz>
References: <CAGnHSEkjM2LVCvHgtpL6BKu8tabnZO5pcBaJQdf=B4P10UC3OQ@mail.gmail.com>
	<20150611170901.GG6761@twin.jikos.cz>
Date: Fri, 12 Jun 2015 01:13:43 +0800
Message-ID: <CAGnHSEk630JETZuPhpuUAfpw_2J2BdQryNidBRgYcB1EXAFFLg@mail.gmail.com>
Subject: Re: What is `mkfs.btrfs -r $rootdir` supposed to be used with?
From: Tom Yan <tom.ty89@gmail.com>
To: dsterba@suse.cz, Tom Yan <tom.ty89@gmail.com>, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

So I assume this option is mainly used for preparation of an btrfs image?

On 12 June 2015 at 01:09, David Sterba <dsterba@suse.cz> wrote:
> On Thu, Jun 11, 2015 at 08:44:35PM +0800, Tom Yan wrote:
>> I know `mkfs.btrfs -r $rootdir` copies whatever in $rootdir to the
>> newly created filesystem.
>>
>> When I try to use it for a block device, it creates a "minimal"
>> filesystem which can only be mounted read-only.
>>
>> When I use it for an (qemu raw) image, it seems to work but it also gives:
>>  ERROR: device scan failed 'test.img' - Block device required
>> in the process.
>>
>> So what is it supposed to be used with?
>
> That's a bug (will be fixed in btrfs-progs 4.1). The device scan ioctl
> should not be called on a file. Otherwise it's harmless.
