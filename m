Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:51986 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753096Ab3A3A1A (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Jan 2013 19:27:00 -0500
Received: from relay2.suse.de (unknown [195.135.220.254])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mx2.suse.de (Postfix) with ESMTP id 2FCCDA4EB7
	for <linux-btrfs@vger.kernel.org>; Wed, 30 Jan 2013 01:26:59 +0100 (CET)
Date: Wed, 30 Jan 2013 01:26:58 +0100
From: David Sterba <dsterba@suse.cz>
To: David Sterba <dsterba@suse.cz>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Integration branch of btrfs-progs 2013-01-30
Message-ID: <20130130002658.GE30535@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20130130002427.GD30535@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130130002427.GD30535@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jan 30, 2013 at 01:24:28AM +0100, David Sterba wrote:
>   git://repo.or.cz/btrfs-progs-unstable/devel.git integration-20130130
> 
> (top commit 78b35a43988163dbf71d9)

Shortlog:

Anand Jain (1):
      Btrfs-progs: move open_file_or_dir() to utils.c

Ben Peddell (1):
      btrfs-progs: fix unaligned accesses v2

David Sterba (1):
      btrfs-progs: fix build warnings in btrfslabel.c

Gene Czarcinski (1):
      Btrfs-progs: Fix trival compiler error in cmds-qgroup.c

Stefan Behrens (3):
      Btrfs-progs: make two utility functions globally available
      Btrfs-progs: add command to get/reset device stats via ioctl
      Btrfs-progs: add support for device replace procedure

