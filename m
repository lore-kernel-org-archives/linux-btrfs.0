Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:33212 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751760Ab3KXXDB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 24 Nov 2013 18:03:01 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Vkihf-0000TH-SX
	for linux-btrfs@vger.kernel.org; Mon, 25 Nov 2013 00:02:59 +0100
Received: from cpc21-stap10-2-0-cust974.12-2.cable.virginm.net ([86.0.163.207])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 25 Nov 2013 00:02:59 +0100
Received: from m_btrfs by cpc21-stap10-2-0-cust974.12-2.cable.virginm.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 25 Nov 2013 00:02:59 +0100
To: linux-btrfs@vger.kernel.org
From: Martin <m_btrfs@ml1.co.uk>
Subject: Re: Clean crash... (USB memory sticks mount)
Date: Sun, 24 Nov 2013 23:02:47 +0000
Message-ID: <l6u0id$u2r$1@ger.gmane.org>
References: <CAK-xaQbp8Yfgpu-Tx5CV2yhACxku6_8Zv0cXFCudyFKqoq0D=w@mail.gmail.com> <ce5ama-6he.ln1@hurikhan77.spdns.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
In-Reply-To: <ce5ama-6he.ln1@hurikhan77.spdns.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 24/11/13 20:50, Kai Krakow wrote:

> something about device mapper and write barriers not working correctly which 
> are needed for btrfs being able to rely on transactions working correctly.

Re USB memory sticks:

I've found write barriers not to work for USB memory sticks (for at
least the ones I have tried) for ext4 and btrfs. You must mount with the
"nobarrier" option...


Regards,
Martin



