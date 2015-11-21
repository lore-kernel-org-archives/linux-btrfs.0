Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from vs2.lukas-pirl.de ([5.45.100.90]:40462 "EHLO pim.lukas-pirl.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750734AbbKZCMc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 25 Nov 2015 21:12:32 -0500
Subject: Re: 4.2.6: livelock in recovery (free_reloc_roots)?
To: Alexander Fougner <fougner89@gmail.com>
References: <564EE213.3060007@lukas-pirl.de> <564FBCD1.1020009@lukas-pirl.de>
 <pan$3f62e$32bded6f$af93867e$b809a854@cox.net> <565032DA.5010602@gmail.com>
Cc: linux-btrfs@vger.kernel.org
From: Lukas Pirl <btrfs@lukas-pirl.de>
Message-ID: <56503BB0.3070702@lukas-pirl.de>
Date: Sat, 21 Nov 2015 22:38:56 +1300
MIME-Version: 1.0
In-Reply-To: <565032DA.5010602@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 11/21/2015 10:01 PM, Alexander Fougner wrote as excerpted:
> This is fixed in btrfs-progs 4.3.1, that allows you to delete a
> device again by the 'missing' keyword.

Thanks Alexander! I just found the thread reporting the bug but not the
patch with the corresponding btrfs-tools version it was merged in.

Lukas
