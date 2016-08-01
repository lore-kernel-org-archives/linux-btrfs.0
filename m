Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f49.google.com ([209.85.218.49]:36033 "EHLO
	mail-oi0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754758AbcHATNu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 1 Aug 2016 15:13:50 -0400
Received: by mail-oi0-f49.google.com with SMTP id w18so206157374oiw.3
        for <linux-btrfs@vger.kernel.org>; Mon, 01 Aug 2016 12:13:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtSisvQVVgNC-vzWzQ3yKK100wF76Zd2+j3h-ryw=1yEkA@mail.gmail.com>
References: <CAJCQCtQ4CXjBzR6eo0zibDCb9_p0jAiS2q_fCRUkUNVWiM9i6g@mail.gmail.com>
 <CAJCQCtQ8yPQf8O2LA92-Gd95GGXQiDp-ZomKZgP4bNv-MmKHYw@mail.gmail.com>
 <ac28e105-f228-de18-08c2-e504e304052d@gmail.com> <CAJCQCtQahbHJhcyKrdRGLNuzbd7MUL11nGBpiQ2U40nAn1ve2w@mail.gmail.com>
 <a582564a-e991-dd35-721f-31c807a24929@gmail.com> <CAJCQCtRgmfWVf9YB2=fVLDSRhm4-t7W+YHBabBaBsBZeSiDU1Q@mail.gmail.com>
 <ad6d5637-7d38-8527-513c-ffe000e5a2f1@gmail.com> <CAJCQCtQtxVOZ=7Phc=mjTbGbL+V5hMsjTL3vssJXH0pVZ2xrEg@mail.gmail.com>
 <66ae3161-b57e-e531-36d5-afc726912563@gmail.com> <CAJCQCtTXNAC1aNpwmhMYYct2GVFO9syFom34XYwM9rGSB5xCJA@mail.gmail.com>
 <CAJCQCtSisvQVVgNC-vzWzQ3yKK100wF76Zd2+j3h-ryw=1yEkA@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Mon, 1 Aug 2016 12:43:31 -0600
Message-ID: <CAJCQCtSYkCaG=MQkTONmYLDXByBWF5ofMb+E6U+Lwx-qnJrUhA@mail.gmail.com>
Subject: Re: systemd KillUserProcesses=yes and btrfs scrub
To: Chris Murphy <lists@colorremedies.com>
Cc: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

All of these have status R and D for their duration, and while all get
a SIGKILL from systemd on logout, none of the processes change status
or die until their kernel task is done. And each of these operations
complete successfully with no worse for the wear.

btrfs balance &
btrfs dev rem &
btrfs replace start

Only 'btrfs scrub' has status S, and once it gets SIGKILL, it goes Z
and all of its accounting is wrong. But the kernel tasks continue and
appear to complete.

I did all of this with a btrfs raid5, 3 and 4 disks, in a libvirt VM.

---
Chris Murphy
