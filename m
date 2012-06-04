Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.160]:51699 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751806Ab2FDNDD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Jun 2012 09:03:03 -0400
Message-ID: <4FCCB20A.7010300@giantdisaster.de>
Date: Mon, 04 Jun 2012 15:03:06 +0200
From: Stefan Behrens <sbehrens@giantdisaster.de>
MIME-Version: 1.0
To: Maxim Mikheev <mikhmv@gmail.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: Help with recover data
References: <4FC54A5D.8000600@gmail.com> <4FCCA8E3.7080209@giantdisaster.de> <4FCCA983.50400@gmail.com>
In-Reply-To: <4FCCA983.50400@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 04 Jun 2012 08:26:43 -0400, Maxim Mikheev wrote:
> It was a kernel panic from btrfs.
> I had around 40 parallel processes of reading/writing.

Do you have a stack trace for this kernel panic, something with the term
"BUG", "WARNING" and/or "Call Trace" in /var/log/kern.log or
/var/log/syslog (or in the old /var/log/syslog.?.gz /var/log/kern.log.?.gz)?

And are the disks connected via USB or how?

Is there an MD, LVM or encryption layer below btrfs in your setup?

Was the filesystem almost full?
