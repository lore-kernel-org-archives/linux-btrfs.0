Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:51938 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750753Ab3INJQj convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 14 Sep 2013 05:16:39 -0400
Received: from 167.40.213.193.static.cust.telenor.com ([193.213.40.167]:59604 helo=[192.168.4.158])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.80.1)
	(envelope-from <lists@colorremedies.com>)
	id 1VKly0-003sLt-Cc
	for linux-btrfs@vger.kernel.org; Sat, 14 Sep 2013 03:16:37 -0600
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 6.5 \(1508\))
Subject: Re: btrfs-image from bad filesystem
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <CAHCa-pd=5Eo5EVUEOh8va-zmQAg3=Xb2HT8jBoWH-9RGq9UAzQ@mail.gmail.com>
Date: Sat, 14 Sep 2013 11:16:31 +0200
Message-Id: <1AC532F4-1680-4F02-992A-6E7AB8E833E7@colorremedies.com>
References: <CAHCa-pc04=k=F3KDdoTUR9NpU_xi0M+tPSTzWyP-yZUEVPU6kg@mail.gmail.com> <CAHCa-pd=5Eo5EVUEOh8va-zmQAg3=Xb2HT8jBoWH-9RGq9UAzQ@mail.gmail.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Sep 14, 2013, at 11:05 AM, Mathew Kamkar <matkam@gmail.com> wrote:

> Luckily, mounting the filesystem read-only,
> I was able to copy all my data and rebuild the filesystem.

Did you create a new btrfs volume? Or were you somehow able to repair the old one?

Chris Murphy

