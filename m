Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yh0-f46.google.com ([209.85.213.46]:60998 "EHLO
	mail-yh0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751816Ab2KSCzs (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 18 Nov 2012 21:55:48 -0500
Date: Mon, 19 Nov 2012 00:55:40 -0200
From: Gustavo Padovan <gustavo@padovan.org>
To: chris.mason@fusionio.com
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: btrfs crash - Null dereference - 3.7.0-rc5-00068-gc5e35d6
Message-ID: <20121119025540.GA3858@joana>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

my system suddenly crashed and gave me this dump:

http://imgur.com/oO6S0

I checked and there is not btrfs commit in linus' tree since I compiled this
kernel.

	Gustavo
