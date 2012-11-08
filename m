Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.fusionio.com ([66.114.96.30]:33325 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754689Ab2KHA7s (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 7 Nov 2012 19:59:48 -0500
Date: Wed, 7 Nov 2012 19:59:46 -0500
From: Chris Mason <chris.mason@fusionio.com>
To: Stefan Behrens <sbehrens@giantdisaster.de>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 00/26] Btrfs: Add device replace code
Message-ID: <20121108005946.GD16468@shiny>
References: <cover.1352214751.git.sbehrens@giantdisaster.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <cover.1352214751.git.sbehrens@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Nov 06, 2012 at 09:38:18AM -0700, Stefan Behrens wrote:
> This patch series adds support for replacing disks at runtime.
> 
> It replaces the following steps in case a disk was lost:
>     mount ... -o degraded
>     btrfs device add new_disk
>     btrfs device delete missing
> 
> Or in case a disk just needs to be replaced because the error rate
> is increasing:
>     btrfs device add new_disk
>     btrfs device delete old_disk
> 
> Instead just run:
>     btrfs replace mountpoint old_disk new_disk
> 

This is just fantastic.  I'm pulling it down and doing a test
integration with RAID56.  More comments as I hash through things.

-chris
