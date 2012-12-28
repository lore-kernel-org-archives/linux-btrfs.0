Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f43.google.com ([209.85.160.43]:34708 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753711Ab2L1TGn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 28 Dec 2012 14:06:43 -0500
Received: by mail-pb0-f43.google.com with SMTP id um15so6095652pbc.30
        for <linux-btrfs@vger.kernel.org>; Fri, 28 Dec 2012 11:06:43 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CACCfv7ot+WTV1eiBCujcyPkSt7SGqVvVCKpFo4rn8Y=FEZu_7w@mail.gmail.com>
References: <CACCfv7ot+WTV1eiBCujcyPkSt7SGqVvVCKpFo4rn8Y=FEZu_7w@mail.gmail.com>
Date: Fri, 28 Dec 2012 12:59:18 -0600
Message-ID: <CAE5mzvhOMZopeVqb4A7PihLuyM2zo_ETN1G3wE_OJi27NfSzVg@mail.gmail.com>
Subject: Re: parent transid verify failed on -- After moving btrfs closer to
 the beginning of drive with dd
From: cwillu <cwillu@cwillu.com>
To: Jordan Windsor <jordanw2@gmail.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Dec 28, 2012 at 12:09 PM, Jordan Windsor <jordanw2@gmail.com> wrote:
> Hello,
> I moved my btrfs to the beginning of my drive & updated the partition
> table & also restarted, I'm currently unable to mount it, here's the
> output in dmesg.
>
> [  481.513432] device label Storage devid 1 transid 116023 /dev/sdb1
> [  481.514277] btrfs: disk space caching is enabled
> [  481.522611] parent transid verify failed on 1229060423680 wanted
> 116023 found 116027
> [  481.522789] parent transid verify failed on 1229060423680 wanted
> 116023 found 116027
> [  481.522790] btrfs: failed to read tree root on sdb1
> [  481.523656] btrfs: open_ctree failed
>
> What command should I run from here?

The filesystem wasn't uncleanly unmounted, likely on an older kernel.

Try mounting with -o recovery
