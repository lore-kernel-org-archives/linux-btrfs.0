Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:58155 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752026Ab3IVPUF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 22 Sep 2013 11:20:05 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1VNlS7-00049h-1u
	for linux-btrfs@vger.kernel.org; Sun, 22 Sep 2013 17:20:03 +0200
Received: from cpe-174-109-089-140.nc.res.rr.com ([174.109.89.140])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 22 Sep 2013 17:20:03 +0200
Received: from dustymabe by cpe-174-109-089-140.nc.res.rr.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 22 Sep 2013 17:20:03 +0200
To: linux-btrfs@vger.kernel.org
From: Dusty Mabe <dustymabe@gmail.com>
Subject: Re: [PATCH 0/9] enhance btrfs qgroup show command
Date: Sun, 22 Sep 2013 15:14:35 +0000 (UTC)
Message-ID: <loom.20130922T170658-776@post.gmane.org>
References: <50C068D4.6020105@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Miao Xie <miaox <at> cn.fujitsu.com> writes:

> 
> The patchset enhanced btrfs qgroup show command.
> 
> Firstly, we restructure show_qgroups, make it easy to add new features.
> 
> And then we add '-p' '-c', '-l',and '-e' options to print the parent
> qgroup id, child qgroup id, max referenced size and max exclusive size
> of qgroup respectively, add '-F' and '-f' option to list qgroups that
> impact the given path.


Hi,

What is the status of this patch? I don't ever think it made it in upstream. 
Was it flawed or just forgotten? 

Thanks,
Dusty 

