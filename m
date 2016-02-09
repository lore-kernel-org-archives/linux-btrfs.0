Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:36623 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932333AbcBILN7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 9 Feb 2016 06:13:59 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1aT6F2-0007fS-3r
	for linux-btrfs@vger.kernel.org; Tue, 09 Feb 2016 12:13:56 +0100
Received: from cpc80685-stap13-2-0-cust475.12-2.cable.virginm.net ([86.9.3.220])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 09 Feb 2016 12:13:56 +0100
Received: from m_btrfs by cpc80685-stap13-2-0-cust475.12-2.cable.virginm.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 09 Feb 2016 12:13:56 +0100
To: linux-btrfs@vger.kernel.org
From: Martin <m_btrfs@ml1.co.uk>
Subject: USB memory sticks wear & speed: btrfs vs f2fs?
Date: Tue, 09 Feb 2016 11:13:50 +0000
Message-ID: <n9chle$q0h$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

How does btrfs compare to f2fs for use on (128GByte) USB memory sticks?

Particularly for wearing out certain storage blocks?

Does btrfs heavily use particular storage blocks that will prematurely
"wear out"?

(That is, could the whole 128GBytes be lost due to one 4kByte block
having been re-written excessively too many times due to a fixed
repeatedly used filesystem block?)

Any other comparisons/thoughts for btrfs vs f2fs?


Thanks for any comment,
Martin

