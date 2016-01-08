Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f173.google.com ([209.85.217.173]:34441 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750766AbcAHGg2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 8 Jan 2016 01:36:28 -0500
Received: by mail-lb0-f173.google.com with SMTP id cl12so2322884lbc.1
        for <linux-btrfs@vger.kernel.org>; Thu, 07 Jan 2016 22:36:28 -0800 (PST)
Subject: Re: btrfs trim erases bootloader area
To: Christoph Anton Mitterer <calestyo@scientia.net>, fdmanana@gmail.com,
        Chris Murphy <lists@colorremedies.com>
References: <568EB86F.7070800@gmail.com>
 <CAL3q7H5VsDHfwwnoHc9_N9cg1KrtFro6gW59-XRoPj_orUyKVw@mail.gmail.com>
 <CAJCQCtTCx4MBQyxNTyq1EpbxHTvuQrjJPehNR4jqw=9ZZu98Tg@mail.gmail.com>
 <CAL3q7H5Ac2OBhQvGA77=HmcgdRcV1UDPjWiyzkB7zWJF=upiHw@mail.gmail.com>
 <1452217455.6686.10.camel@scientia.net>
Cc: The development of GNU GRUB <grub-devel@gnu.org>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
From: Andrei Borzenkov <arvidjaar@gmail.com>
Message-ID: <568F58E8.8020707@gmail.com>
Date: Fri, 8 Jan 2016 09:36:24 +0300
MIME-Version: 1.0
In-Reply-To: <1452217455.6686.10.camel@scientia.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

08.01.2016 04:44, Christoph Anton Mitterer пишет:
> Hey.
> 
> Just a followup on this:
> GPT and some others (e.g MD RAID) store data in the end of the device.
> 
> It's clear that when the fs is made inside a partition, this shouldn't
> be seen (and thus TRIMmed) anyway... but can btrfs be installed e.g.
> directly on the device while that continues to hold the GPT (by btrfs
> simply always starting at some byte offset)?

If btrfs size includes metadata at the end of device - arguably it is
user error; it should not happen.

If user explicitly excluded metadata (mkfs.btrfs -b <size>) but btrfs
still attempts to trim beyond end of filesystem - this is obviously bug
and should not happen. I do not understand much of btrfs internals to
know if this is possible.

Note that corner case is when filesystem size is not multiple of trim
units size. Then incomplete chunks(s) at the beginning and end should
always be skipped.

> If so, then one may possibly need to extend that patch for the end of
> the device.
> 
> Cheers,
> Chris.
> 

