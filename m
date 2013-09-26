Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dub0-omc1-s32.dub0.hotmail.com ([157.55.0.231]:16958 "EHLO
	dub0-omc1-s32.dub0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756952Ab3IZMWu convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 26 Sep 2013 08:22:50 -0400
Message-ID: <DUB116-W69F1EBEC6C7619457E5D82A6280@phx.gbl>
From: miaou sami <miaousami@hotmail.com>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: [raidX vs single/dup]
Date: Thu, 26 Sep 2013 12:22:49 +0000
Content-Type: text/plain; charset=US-ASCII
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi btrfs guys,

could someone explain to me the differences in mkfs.btrfs:

- between -d raid0 and -d single

- between -m raid1 and -m dup

- between -m raid0 and -m single

My understanding is that raidX should be used in case of multi devices and single/dup should be used in case of single device to allow duplication, but it is not 100% clear to me...

As btrfs raid concepts are quite different from traditionnal raid, shouldn't we use the words "stripped" and "mirrored" instead of raid0/raid1? or even "single" and "duplicated"?
Then there would be no difference between single/raid0 and duplicated/raid1...

Regards,
Sam 		 	   		  