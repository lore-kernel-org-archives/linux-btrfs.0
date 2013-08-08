Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:44746 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965275Ab3HHOCT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 8 Aug 2013 10:02:19 -0400
Date: Thu, 8 Aug 2013 16:02:18 +0200
From: David Sterba <dsterba@suse.cz>
To: Sergei Trofimovich <slyich@gmail.com>
Cc: linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@fusionio.com>,
        Josef Bacik <jbacik@fusionio.com>, linux-kernel@vger.kernel.org,
        Sergei Trofimovich <slyfox@gentoo.org>
Subject: Re: [PATCH 7/7] btrfs: cleanup: removed unused
 'btrfs_get_inode_ref_index'
Message-ID: <20130808140218.GV5284@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1375911803-17318-1-git-send-email-slyich@gmail.com>
 <1375911803-17318-8-git-send-email-slyich@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1375911803-17318-8-git-send-email-slyich@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 08, 2013 at 12:43:23AM +0300, Sergei Trofimovich wrote:
> From: Sergei Trofimovich <slyfox@gentoo.org>
> 
> Found by uselex.rb:
> > btrfs_get_inode_ref_index: [R]: exported from: fs/btrfs/inode-item.o fs/btrfs/btrfs.o fs/btrfs/built-in.o
> 
> Signed-off-by: Sergei Trofimovich <slyfox@gentoo.org>

Safe to remove.

Reviewed-by: David Sterba <dsterba@suse.cz>
