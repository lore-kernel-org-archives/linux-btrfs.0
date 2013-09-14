Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:41172 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752815Ab3INMkH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 14 Sep 2013 08:40:07 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1VKp8t-0001yx-KN
	for linux-btrfs@vger.kernel.org; Sat, 14 Sep 2013 14:40:03 +0200
Received: from 50-0-92-173.dsl.dynamic.sonic.net ([50.0.92.173])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 14 Sep 2013 14:40:03 +0200
Received: from matkam by 50-0-92-173.dsl.dynamic.sonic.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 14 Sep 2013 14:40:03 +0200
To: linux-btrfs@vger.kernel.org
From: Mathew Kamkar <matkam@gmail.com>
Subject: Re: btrfs-image from bad filesystem
Date: Sat, 14 Sep 2013 12:37:54 +0000 (UTC)
Message-ID: <loom.20130914T143413-947@post.gmane.org>
References: <CAHCa-pc04=k=F3KDdoTUR9NpU_xi0M+tPSTzWyP-yZUEVPU6kg@mail.gmail.com> <CAHCa-pd=5Eo5EVUEOh8va-zmQAg3=Xb2HT8jBoWH-9RGq9UAzQ@mail.gmail.com> <1AC532F4-1680-4F02-992A-6E7AB8E833E7@colorremedies.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris Murphy <lists <at> colorremedies.com> writes:
> Did you create a new btrfs volume? Or were you somehow able to repair the
old one?

No I wasn't able to repair the old one. I used rsync to copy the data,
created a new volume, then rsync copied it back.

