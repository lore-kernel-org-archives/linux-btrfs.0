Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:52747 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161523Ab3FUQSo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 21 Jun 2013 12:18:44 -0400
Date: Fri, 21 Jun 2013 18:18:42 +0200
From: David Sterba <dsterba@suse.cz>
To: Filipe David Manana <fdmanana@gmail.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 5/5] Btrfs-progs: Validate super block checksum
Message-ID: <20130621161842.GD6009@suse.cz>
Reply-To: dsterba@suse.cz
References: <1370893895-24884-1-git-send-email-fdmanana@gmail.com>
 <1370893895-24884-6-git-send-email-fdmanana@gmail.com>
 <CAL3q7H46KuUFpYpGZ1S_d2MtarOTzqQf4KuqoRTz8xQM4dZD6w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAL3q7H46KuUFpYpGZ1S_d2MtarOTzqQf4KuqoRTz8xQM4dZD6w@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 20, 2013 at 06:08:29PM +0100, Filipe David Manana wrote:
> Is there any reason why the btrfs progs (except for btrfs-show-super)
> don't validate the super block's checksum?

btrfsck accepts broken filesystems, so open_ctree_broken should possibly
detect but skip the checksum mismatch.

david
