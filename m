Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:60902 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751395AbaAEUcD convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 5 Jan 2014 15:32:03 -0500
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: btrfs-transaction blocked for more than 120 seconds
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <52C2AE7C.5020601@gmx.at>
Date: Sun, 5 Jan 2014 13:32:01 -0700
Cc: linux-btrfs@vger.kernel.org
Message-Id: <64E70864-9830-4145-9EDF-F53A79977999@colorremedies.com>
References: <52C2AE7C.5020601@gmx.at>
To: Sulla <Sulla@gmx.at>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Dec 31, 2013, at 4:46 AM, Sulla <Sulla@gmx.at> wrote:

> Dear all!
> 
> On my Ubuntu Server 13.10 I use a RAID5 blockdevice consisting of 3 WD20EARS

Sulla is this md raid5? If so can you report the result from mdadm -D <mddevice>, I'm curious what the chunk size is. Thanks.

Chris Murphy