Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yh0-f53.google.com ([209.85.213.53]:36495 "EHLO
	mail-yh0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752280AbbFPVEr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 16 Jun 2015 17:04:47 -0400
Received: by yhan67 with SMTP id n67so20313823yha.3
        for <linux-btrfs@vger.kernel.org>; Tue, 16 Jun 2015 14:04:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20150616165832.GN9850@carfax.org.uk>
References: <CAOQP4cG2344VZYT8eZ4=MJzi_KsdzH7pxFJ+ZpOTXtdDOrXRyQ@mail.gmail.com>
	<20150616165832.GN9850@carfax.org.uk>
Date: Tue, 16 Jun 2015 15:04:46 -0600
Message-ID: <CAJCQCtRv-S-UDuOAk5EwvL=erA5Er+GA5zymdA_WgFWsR07=Ng@mail.gmail.com>
Subject: Re: Replacing a drive from a RAID 1 array
From: Chris Murphy <lists@colorremedies.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Another option is to shrink the file system from 4 devices to 3 by
deleting one. This assumes there's sufficient room for the data to
exist on 3 devices. At least this way the volume is never degraded.
You could do a balance after adding the new 4th device, but that's
optional. Since it's empty, all new writes will have an a copy always
going to the new 4th device and then the b copy to one of the other
three.


Chris Murphy
