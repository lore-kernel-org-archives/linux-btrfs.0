Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:53513 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751346AbaDUFjY convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 21 Apr 2014 01:39:24 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: Planning for subvolumes of subvolumes and btrfs send/receive
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <20140420194627.GO7884@merlins.org>
Date: Sun, 20 Apr 2014 23:39:22 -0600
Message-Id: <5B1404BF-F985-4201-87FD-CBB3E6776531@colorremedies.com>
References: <20140420194627.GO7884@merlins.org>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>, Marc MERLIN <marc@merlins.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Apr 20, 2014, at 1:46 PM, Marc MERLIN <marc@merlins.org> wrote:

> Can you help me design this right?
> 
> Long story short, I'm wondering if I can use btrfs send to copy sub
> subvolumes (by snapshotting a parent subvolume, and hopefully getting
> all the children underneath). My reading so far, says no.

That's my understanding thus far also. Seems like first a recursive read-only snapshot creation is a pre-requisite, since a read-only snapshot is needed first in order to send it.

I think the seed device method is a better way to do this, though I'm not sure what state its in.


Chris Murphy

