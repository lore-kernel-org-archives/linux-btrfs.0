Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailout03.t-online.de ([194.25.134.81]:59789 "EHLO
	mailout03.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753790Ab3JPTMz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 16 Oct 2013 15:12:55 -0400
Received: from nas2.weinberger.local ([192.168.0.1] ident=zarafa)
	by nas2.weinberger.local with esmtp (Exim 4.80)
	(envelope-from <christian.weinberger@t-online.de>)
	id 1VWWWT-00055k-Ql
	for linux-btrfs@vger.kernel.org; Wed, 16 Oct 2013 21:12:45 +0200
Subject: [BUG] Reflinking fails for files >2GB on 32-bit platform [SOLVED ->
 NO BUG]
From: =?utf-8?Q?Christian_Weinberger?= <christian.weinberger@t-online.de>
To: =?utf-8?Q?linux-btrfs=40vger=2Ekernel=2Eorg?=
	<linux-btrfs@vger.kernel.org>
Date: Wed, 16 Oct 2013 21:12:45 +0200
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Message-Id: <zarafa.525ee52d.4c75.31a740822e21b082@nas2.weinberger.local>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Please ignore the previous post.
I have to correct myself, this is not a btrfs issue. In fact, the wrong (non 64 bit) calls have been used in the test program.


