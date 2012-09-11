Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:52188 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751073Ab2IKFYi (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 11 Sep 2012 01:24:38 -0400
Received: by lbbgj3 with SMTP id gj3so115788lbb.19
        for <linux-btrfs@vger.kernel.org>; Mon, 10 Sep 2012 22:24:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <504A6F67.3060506@gmx.net>
References: <504A4CBF.7000605@gmail.com>
	<504A6F67.3060506@gmx.net>
Date: Tue, 11 Sep 2012 01:24:37 -0400
Message-ID: <CAAdM646auV2U43HnoYG=32RipWU8hzaKa5RBNia+krCYWY6muA@mail.gmail.com>
Subject: Re: Cannot create subvolume with quota enabled
From: Marios Titas <redneb8888@gmail.com>
To: Arne Jansen <sensille@gmx.net>
Cc: Andreas Philipp <philipp.andreas@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 7, 2012 at 6:04 PM, Arne Jansen <sensille@gmx.net> wrote:
> Hi Andreas,
>
>
> Thanks for giving quota a try. I sent a fix separately with
> the subject
>
> [PATCH] Btrfs: btrfs_qgroup_inherit wrongly returns an error
>
> Could you please see if it fixes the problem?

Even with this patch I still have a similar problem: When I try to
create a snapshot of an old subvolume that was created before I
enabled quotas, it fails. For new subvolumes it works just fine.
Here's an example ouput:

virtual ~ # btrfs sub snap /mnt/butter/old /mnt/butter/old-snap
Create a snapshot of '/mnt/butter/old' in '/mnt/butter/old-snap'
ERROR: cannot snapshot '/mnt/butter/old' - Invalid argument
