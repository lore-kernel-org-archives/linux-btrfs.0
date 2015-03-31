Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:60168 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751398AbbCaRh7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 31 Mar 2015 13:37:59 -0400
Date: Tue, 31 Mar 2015 19:37:56 +0200
From: David Sterba <dsterba@suse.cz>
To: Martin <m_btrfs@ml1.co.uk>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: ERROR: error removing the device '/dev/sdXN' - Inappropriate
 ioctl for device
Message-ID: <20150331173756.GF6821@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <mfcdep$d97$1@ger.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <mfcdep$d97$1@ger.gmane.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Mar 30, 2015 at 09:59:05PM +0100, Martin wrote:
> btrfs device delete /dev/sdf5 /mnt/data2
> 
> ERROR: error removing the device '/dev/sdf5' - Inappropriate ioctl for
> device

Strange, that would mean that the ioctl number is not handled at all. I
haven't found any change in device delete on the userspace side. This
would mean that /mnt/data2 is not mounted. Did you try to do lazy
unmount?
