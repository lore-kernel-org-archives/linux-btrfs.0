Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:36747 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751558AbaF2RUF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 29 Jun 2014 13:20:05 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1X1Iln-0001ld-G3
	for linux-btrfs@vger.kernel.org; Sun, 29 Jun 2014 19:20:03 +0200
Received: from hsi-kbw-109-192-123-063.hsi6.kabel-badenwuerttemberg.de ([109.192.123.63])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 29 Jun 2014 19:20:03 +0200
Received: from mailinglists by hsi-kbw-109-192-123-063.hsi6.kabel-badenwuerttemberg.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 29 Jun 2014 19:20:03 +0200
To: linux-btrfs@vger.kernel.org
From: Florian Lindner <mailinglists@xgm.de>
Subject: Re: Scrub being stuck
Date: Sun, 29 Jun 2014 19:17:23 +0200
Message-ID: <lophn3$nj1$3@ger.gmane.org>
References: <lophhk$nj1$2@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Florian Lindner wrote:

> Hello,
> 
> I've just completed a scrub on my home filesystem and now I wanted to
> start on my Archiv btrfs RAID 0.

Amendment:

anything btrfs related dmesg shows is

[   38.240950] BTRFS info (device sdd1): csum failed ino 314 off 4129595392 
csum 1774389615 expected csum 2138618437
[   38.241365] BTRFS info (device sdd1): csum failed ino 314 off 4129595392 
csum 1774389615 expected csum 2138618437

This messages are the reason why I wanted to try a scrub.

