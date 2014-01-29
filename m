Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:49297 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752064AbaA2Qoc convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 29 Jan 2014 11:44:32 -0500
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: Deleting subvolumes - there be dragons
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <52E8E905.8030105@gmail.com>
Date: Wed, 29 Jan 2014 09:44:30 -0700
Cc: linux-btrfs@vger.kernel.org
Message-Id: <614BCF7D-76D4-4F2C-99E5-D4132575C203@colorremedies.com>
References: <52E8E905.8030105@gmail.com>
To: KC <impactoria@googlemail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Jan 29, 2014, at 4:41 AM, KC <impactoria@googlemail.com> wrote:

> I just read this article here: https://lwn.net/Articles/579009/  which states:
> 
> ---------------------------------
> btrfs subvolume delete path
> 
> For ordinary subvolumes (as opposed to snapshots, described below), the subvolume indicated by path must be empty before it can be deleted.
> ---------------------------------

That's not correct, but maybe the author meant that a subvolume you intend to delete must not contain another subvolume. A subvolume in another subvolume will anchor the parent.


Chris Murphy