Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:43375 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757826Ab3HHNce (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 8 Aug 2013 09:32:34 -0400
Date: Thu, 8 Aug 2013 15:32:31 +0200
From: David Sterba <dsterba@suse.cz>
To: Sergei Trofimovich <slyich@gmail.com>
Cc: linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@fusionio.com>,
        Josef Bacik <jbacik@fusionio.com>, linux-kernel@vger.kernel.org,
        Sergei Trofimovich <slyfox@gentoo.org>, miaox@cn.fujitsu.com
Subject: Re: [PATCH 4/7] btrfs: cleanup: removed unused
 'btrfs_start_transaction_lflush'
Message-ID: <20130808133231.GT5284@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1375911803-17318-1-git-send-email-slyich@gmail.com>
 <1375911803-17318-5-git-send-email-slyich@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1375911803-17318-5-git-send-email-slyich@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 08, 2013 at 12:43:20AM +0300, Sergei Trofimovich wrote:
> From: Sergei Trofimovich <slyfox@gentoo.org>
> 
> Found by uselex.rb:
> > btrfs_start_transaction_lflush: [R]: exported from: fs/btrfs/btrfs.o fs/btrfs/transaction.o fs/btrfs/built-in.o

http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg24047.html

"> btrfs_start_transaction_lflush()

Transcaction API, removing the func does not make sense without removing
BTRFS_RESERVE_FLUSH_LIMIT at the same time.
"

Miao introduced this function in 08e007d2e57744472a9424735a to enhance
flushing logic to avoid deadlocks.

david
