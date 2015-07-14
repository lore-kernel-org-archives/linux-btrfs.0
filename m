Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f41.google.com ([74.125.82.41]:32780 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752042AbbGNL52 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 14 Jul 2015 07:57:28 -0400
Received: by wgmn9 with SMTP id n9so6899097wgm.0
        for <linux-btrfs@vger.kernel.org>; Tue, 14 Jul 2015 04:57:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <pan$5335b$94315604$8405c6ac$de90de30@cox.net>
References: <20150604084245.GR23272@merlins.org> <20150624032008.GF20517@merlins.org>
 <CAA7pwKOA1yyA8kyB+a3iTOp8TnkRzAErF1Mo=2t5M3pFn2tjUw@mail.gmail.com> <pan$5335b$94315604$8405c6ac$de90de30@cox.net>
From: Patrik Lundquist <patrik.lundquist@gmail.com>
Date: Tue, 14 Jul 2015 13:57:07 +0200
Message-ID: <CAA7pwKNtS6UB+tXdB9c4D9J2gOk56gM-O1q+19A6SZcdcdFVtw@mail.gmail.com>
Subject: Re: counting fragments takes more time than defragmenting
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 24 June 2015 at 12:46, Duncan <1i5t5.duncan@cox.net> wrote:
>
> Regardless of whether 1 or huge -t means maximum defrag, however, the
> nominal data chunk size of 1 GiB means that 30 GiB file you mentioned
> should be considered ideally defragged at 31 extents.  This is a
> departure from ext4, which AFAIK in theory has no extent upper limit, so
> should be able to do that 30 GiB file in a single extent.
>
> But btrfs or ext4, 31 extents ideal or a single extent ideal, 150 extents
> still indicates at least some remaining fragmentation.

So I converted the VMware VMDK file to a VirtualBox VDI file:

-rw------- 1 plu plu 28845539328 jul 13 13:36 Windows7-disk1.vmdk
-rw------- 1 plu plu 28993126400 jul 13 14:04 Windows7.vdi

$ filefrag Windows7.vdi
Windows7.vdi: 15 extents found

$ btrfs filesystem defragment -t 3g Windows7.vdi
$ filefrag Windows7.vdi
Windows7.vdi: 24 extents found

How can it be less than 28 extents with a chunk size of 1 GiB?

E2fsprogs version 1.42.12
