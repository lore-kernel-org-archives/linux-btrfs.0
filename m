Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:41274 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752899AbbF2Khq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 29 Jun 2015 06:37:46 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1Z9WRd-00054J-KU
	for linux-btrfs@vger.kernel.org; Mon, 29 Jun 2015 12:37:45 +0200
Received: from barriere.frankfurter-softwarefabrik.de ([217.11.197.1])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 29 Jun 2015 12:37:45 +0200
Received: from lvml by barriere.frankfurter-softwarefabrik.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 29 Jun 2015 12:37:45 +0200
To: linux-btrfs@vger.kernel.org
From: Lutz Vieweg <lvml@5t9.de>
Subject: Re: WARNING:  at /fs/btrfs/extent-tree.c:4029 btrfs_free_reserved_data_space
Date: Mon, 29 Jun 2015 12:37:33 +0200
Message-ID: <mmr75d$vbi$1@ger.gmane.org>
References: <6617728.KSCQs1dauk@o3-3>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
In-Reply-To: <6617728.KSCQs1dauk@o3-3>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 06/29/2015 11:35 AM, David Weber wrote:
> we are testing Btrfs as a kvm storage system with
> "defaults,space_cache,nodatacow" mount options and regular snapshots.

That sounds brave - even with "nodatacow" it appeared to me
that using btrfs with often partially overwritten files like
VM images results in excessively fragmented files.
And taking snapshots kind of counteracts "nodatacow".

What does "filefrag" tell about your VM images on btrfs?

(As much as I like btrfs for other purposes, I currently stay
with XFS for VM images, database files and alike.)

Regards,

Lutz Vieweg

