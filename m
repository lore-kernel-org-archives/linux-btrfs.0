Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:41058 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753453Ab3F0PBd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 27 Jun 2013 11:01:33 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 007737C069A
	for <linux-btrfs@vger.kernel.org>; Thu, 27 Jun 2013 09:01:33 -0600 (MDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>
From: Chris Mason <chris.mason@fusionio.com>
In-Reply-To: <20130627145824.GA21540@redhat.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>, <linux-btrfs@vger.kernel.org>
References: <20130627145824.GA21540@redhat.com>
Message-ID: <20130627150130.14981.39849@localhost.localdomain>
Subject: Re: btrfs triggered lockdep WARN.
Date: Thu, 27 Jun 2013 11:01:30 -0400
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Quoting Dave Jones (2013-06-27 10:58:24)
> Another bug caused by this script. https://github.com/kernelslacker/io-tests/blob/master/setup.sh

I'm still struggling to reproduce that one here.  I've tried every
variation I can think of but I'll try again.

I really hope you don't already have CONFIG_DEBUG_PAGE_ALLOC turned on,
maybe it will catch this?

-chris
