Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:39433 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750787AbaIBMSo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 2 Sep 2014 08:18:44 -0400
Date: Tue, 2 Sep 2014 14:18:41 +0200
From: David Sterba <dsterba@suse.cz>
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/2] Build system fixes/improvements
Message-ID: <20140902121841.GG5888@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1409402890-22860-1-git-send-email-thomas.petazzoni@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1409402890-22860-1-git-send-email-thomas.petazzoni@free-electrons.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Aug 30, 2014 at 02:48:08PM +0200, Thomas Petazzoni wrote:
> Here are two patches that we have in the Buildroot embedded Linux
> build system against btrfs-progs. The first patch allows to disable
> the build and installation of the docmentation, the second patch
> improves static building and installation.

Good fixes, thanks.
