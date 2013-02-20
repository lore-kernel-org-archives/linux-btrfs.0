Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:52977 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933198Ab3BTPM3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 Feb 2013 10:12:29 -0500
Date: Wed, 20 Feb 2013 16:12:27 +0100
From: David Sterba <dsterba@suse.cz>
To: Josef Bacik <jbacik@fusionio.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: LAST CALL FOR BTRFS-NEXT
Message-ID: <20130220151227.GA27541@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20130220142612.GA2062@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130220142612.GA2062@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Please add this patch to next queue

btrfs: limit fallocate extent reservation to 256MB
https://patchwork.kernel.org/patch/1752311/

Tested-by: David Sterba <dsterba@suse.cz>

thanks,
david
