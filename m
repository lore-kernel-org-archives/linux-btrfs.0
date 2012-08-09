Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:53085 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755149Ab2HIGsR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 9 Aug 2012 02:48:17 -0400
Date: Thu, 9 Aug 2012 08:48:02 +0200
From: David Sterba <dave@jikos.cz>
To: Miao Xie <miaox@cn.fujitsu.com>
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>, David Sterba <dave@jikos.cz>
Subject: Re: [RFC PATCH] Btrfs: fix full backref problem when inserting
 shared block reference
Message-ID: <20120809064802.GB17430@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <50232A19.2010704@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <50232A19.2010704@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 09, 2012 at 11:10:17AM +0800, Miao Xie wrote:
> I chose the 1st way to fix it.

The least I can say now is that it fixed the crash! The approach is
minimalistic and I think we can take it for now. I didn't review it,
only tested with reproducer you described plus modified the numbers up
and down, no problems so far, and the "wikipedia" test-subvol stresstest
that caused trouble to one of your patches is also ok. I'll do some more
testing on other machines and will report problems eventually.

Thanks!

david
