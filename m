Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f43.google.com ([74.125.82.43]:56672 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752524AbaG0Ury (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 27 Jul 2014 16:47:54 -0400
MIME-Version: 1.0
Date: Sun, 27 Jul 2014 16:47:52 -0400
Message-ID: <CAPDOMViXEgN1U8Og52Fd7EaM86Ad2Dfex9TVQ-+tRZ9SL9Kcig@mail.gmail.com>
Subject: Multi Core Support for compression in compression.c
From: Nick Krause <xerofoify@gmail.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-btrfs@vger.kernel.org SYSTEM list:BTRFS FILE"
	<linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This may be a bad idea , but compression in brtfs seems to be only
using one core to compress.
Depending on the CPU used and the amount of cores in the CPU we can
make this much faster
with multiple cores. This seems bad by my reading at least I would
recommend for writing compression
we write a function to use a certain amount of cores based on the load
of the system's CPU not using
more then 75% of the system's CPU resources as my system when idle has
never needed more
then one core of my i5 2500k to run when with interrupts for opening
eclipse are running. For reading
compression on good core seems fine to me as testing other compression
software for reads , it's
way less CPU intensive.
Cheers Nick
