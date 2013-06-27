Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f180.google.com ([209.85.223.180]:33277 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751408Ab3F0PHl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 27 Jun 2013 11:07:41 -0400
Received: by mail-ie0-f180.google.com with SMTP id f4so1777807iea.11
        for <linux-btrfs@vger.kernel.org>; Thu, 27 Jun 2013 08:07:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201306272356.01246.russell@coker.com.au>
References: <CAFwaWH=iuaq2W05GrpitARq3L9w+ZNGPkC1C4p=Bd0AP6p84FQ@mail.gmail.com>
 <201306272356.01246.russell@coker.com.au>
From: Kelvin <kelvin9302104@gmail.com>
Date: Thu, 27 Jun 2013 23:07:20 +0800
Message-ID: <CAFwaWHnyUZgyFv+Xot5r8UoN1q1RL3HiMjVfQCz+03uBJkcZkg@mail.gmail.com>
Subject: Re: Transparent Tagging?
To: russell@coker.com.au
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

That's a great idea to use XATTR values to implement this! The
simulated directory can be a transparent way provided to search for
the XATTR containing the corresponding tags.

2013/6/27 Russell Coker <russell@coker.com.au>:
> On Thu, 27 Jun 2013, Kelvin <kelvin9302104@gmail.com> wrote:
>> It seems that there are some tagging systems, but they are not native
>> for the filesystem. It means that when we read the filesystem from an
>> OS without that system installed, everything will be in a mess (or we
>> can arrange the files in traditional way as well, but this is
>> inconvenient). Also, we need to manage the files through the utilities
>> provided, and this is not convenient.
>
> I think it would be useful to have a way of searching for XATTR values.  One
> example of how this could be used is when analysing a SE Linux system it would
> be useful to be able to quickly get a list of all files with a particular
> security label (value for the security.selinux XATTR).
>
> But it's probably best that developers concentrate on reliability,
> performance, and more commonly desired features such as RAID5/6 support.
>
> --
> My Main Blog         http://etbe.coker.com.au/
> My Documents Blog    http://doc.coker.com.au/
