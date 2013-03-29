Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ia0-f177.google.com ([209.85.210.177]:60892 "EHLO
	mail-ia0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751331Ab3C2GEp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 29 Mar 2013 02:04:45 -0400
Received: by mail-ia0-f177.google.com with SMTP id w33so204472iag.22
        for <linux-btrfs@vger.kernel.org>; Thu, 28 Mar 2013 23:04:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <221EE566-B039-426F-827D-AA20B5A2D86B@colorremedies.com>
References: <221EE566-B039-426F-827D-AA20B5A2D86B@colorremedies.com>
Date: Fri, 29 Mar 2013 00:04:44 -0600
Message-ID: <CAE5mzviUeSfT6X=hQfwCcRAhHhJDYRFhztOiEWKHSXfTcZ0r4w@mail.gmail.com>
Subject: Re: minimum kernel version for btrfsprogs.0.20?
From: cwillu <cwillu@cwillu.com>
To: Chris Murphy <lists@colorremedies.com>
Cc: "linux-btrfs@vger.kernel.org BTRFS" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Mar 28, 2013 at 11:41 PM, Chris Murphy <lists@colorremedies.com> wrote:
> Creating a btrfs file system using btrfs-progs-0.20.rc1.20130308git704a08c-1.fc19, and either kernel 3.6.10-4.fc18 or 3.9.0-0.rc3.git0.3.fc19, makes a file system that cannot be mounted by kernel 3.6.10-4.fc18. It can be mounted by kernel 3.8.4. I haven't tested any other 3.8, or any 3.7 kernels.
>
> Is this expected?
>
> dmesg reports:
> [  300.014764] btrfs: disk space caching is enabled
> [  300.024137] BTRFS: couldn't mount because of unsupported optional features (40).
> [  300.034148] btrfs: open_ctree failed

commit 1a72afaa "btrfs-progs: mkfs support for extended inode refs"
unconditionally enables extended irefs (which permits more than 4k
links to the same inode).  It's the right default imo, but there
probably should have been a mkfs option to disable it.
