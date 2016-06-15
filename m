Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:60094 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752789AbcFONKH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 15 Jun 2016 09:10:07 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1bDAa5-000869-Gx
	for linux-btrfs@vger.kernel.org; Wed, 15 Jun 2016 15:10:05 +0200
Received: from c83-254-33-5.bredband.comhem.se ([83.254.33.5])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 15 Jun 2016 15:10:05 +0200
Received: from nisse by c83-254-33-5.bredband.comhem.se with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 15 Jun 2016 15:10:05 +0200
To: linux-btrfs@vger.kernel.org
From: Nisse Karlsson <nisse@xcorp.at>
Subject: Re: Balance fails with unallocated diskspace
Date: Wed, 15 Jun 2016 13:06:40 +0000 (UTC)
Message-ID: <loom.20160615T150350-100@post.gmane.org>
References: <CALy3tB3YaTAYrZLhA7X0CTCUNLm7JCAyVX0WSdp1K48TNfFAUA@mail.gmail.com> <CALy3tB28Kx6aHTj+B-g68foh2bKSb0cnPcy7D-QQw3WPb9Wz4Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I've now tried mounting with nospace_cache as suggested in another thread,
no difference.

I also tried remounting with enospc_debug, but that didn't give me more info
than before
BTRFS info (device sdb): 523 enospc errors during balance

//Nisse


