Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from nm14-vm9.bullet.mail.ir2.yahoo.com ([212.82.96.197]:44486 "EHLO
	nm14-vm9.bullet.mail.ir2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753217AbaENI5F convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 14 May 2014 04:57:05 -0400
Message-ID: <1400057388.37889.YahooMailNeo@web172202.mail.ir2.yahoo.com>
Date: Wed, 14 May 2014 09:49:48 +0100 (BST)
From: Astro Xe <astroxeu@yahoo.it>
Reply-To: Astro Xe <astroxeu@yahoo.it>
Subject: Error in btrfs wiki - "How much space will I get with my multi-device configuration?"
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

The content of the FAQ "How much space will I get with my multi-device configuration?" (https://btrfs.wiki.kernel.org/index.php/FAQ#How_much_space_will_I_get_with_my_multi-device_configuration.3F) is currently wrong. The usable space is the sum of the space of the devices. I'm using multi-device btrfs (data: single, metadata: single or DUP) on kernels from 3.2 to 3.14 and I have never seen the behavior described in the answer.

Please remove this question.


Thanks,

