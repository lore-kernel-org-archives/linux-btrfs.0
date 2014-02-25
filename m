Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:59609 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752960AbaBYRog convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Feb 2014 12:44:36 -0500
Received: from c-50-183-15-223.hsd1.co.comcast.net ([50.183.15.223]:54096 helo=[192.168.1.145])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.82)
	(envelope-from <lists@colorremedies.com>)
	id 1WIM3X-003gc7-HE
	for linux-btrfs@vger.kernel.org; Tue, 25 Feb 2014 10:44:35 -0700
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: VM nocow, should VM software set +C by default?
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <530C5F65.6020607@internetionals.nl>
Date: Tue, 25 Feb 2014 10:44:36 -0700
Message-Id: <4C05BCCD-ED77-4D8D-B9C7-47CB6D1B4ACC@colorremedies.com>
References: <A2EE3F12-97D9-46CD-8360-ACCFF71F149B@colorremedies.com> <530C5F65.6020607@internetionals.nl>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Feb 25, 2014, at 2:16 AM, Justin Ossevoort <justin@internetionals.nl> wrote:

> I think in principle: No.
> 
> It is something that should be documented as advise in the VM software documentation. But things like storage management is the domain of the distribution or systems administrator.

No, that's a recipe for users having a chaotic experience. Either the VM managing application needs to set +C on image files, or the file system needs to be optimized for this use case. Consider the Gnome Boxes user. They're not in a good position to do this themselves, and each distro doing this causes fragmented experience. It's better if the application developer (Gnome Boxes, VMM) or possibly libvirt to set +C on VM images; or as a general purpose file system for it to be optimized for this use case.

Either way it leaves the end user out of what amounts to esoteric configuration.


> There might be a situation where the VM software can directly use a btrfs filesystem for it's storage engines where it could be sensible to add such a thing, but in that case it's already directly managing it's subvolumes and can turn nodatacow on/off when appropriate.

I don't expect VM's to use subvolumes directly, instead of image files (qcow2, raw, vmdk, etc) for a while, and also I'm not sure if there's enough separation between VMs, or VM and host sharing what is really one file system. If there's any possibility a misbehaving VM could corrupt the file system and not merely its own tree, then it's unlikely a best practice.



Chris Murphy

