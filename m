Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:53173 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751155AbcEHAzE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 7 May 2016 20:55:04 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1azCzs-0000fQ-RF
	for linux-btrfs@vger.kernel.org; Sun, 08 May 2016 02:55:00 +0200
Received: from cpc80685-stap13-2-0-cust475.12-2.cable.virginm.net ([86.9.3.220])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 08 May 2016 02:55:00 +0200
Received: from m_btrfs by cpc80685-stap13-2-0-cust475.12-2.cable.virginm.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 08 May 2016 02:55:00 +0200
To: linux-btrfs@vger.kernel.org
From: Martin <m_btrfs@ml1.co.uk>
Subject: Re: btrfs-tools: missing device delete/remove cancel option on disk
 failure
Date: Sun, 08 May 2016 01:54:54 +0100
Message-ID: <ngm2ou$he4$1@ger.gmane.org>
References: <1ba2f46d66b988069f861df8526e4cba@email.freenet.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
In-Reply-To: <1ba2f46d66b988069f861df8526e4cba@email.freenet.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 07/05/16 10:39, g6094199@freenet.de wrote:
> a brand new disk which has an upcounting raw error rate

Note that is the "raw error rate".

For a brand new disk being run for the first time at maximum data
writes, the "raw error rate" may well be expected to increase. Hard
disks deliberately make use of error correction for normal operation.

More importantly, what do the other smart values show?

For myself, my concern would only be raised for sector failures.


And... A very good test for a new disk is to first run "badblocks" to
test the disk surface. Read the man page first. (Hint: Non-destructive
is slow, destructive write is fast...)

Good luck,
Martin


