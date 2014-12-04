Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58268 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932254AbaLDRUW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 4 Dec 2014 12:20:22 -0500
Date: Thu, 4 Dec 2014 18:20:22 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>,
        Ed Tomlinson <edt@aei.ca>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/6] More generic inode nlink repair function
Message-ID: <20141204172022.GG9754@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1417580312-8516-1-git-send-email-quwenruo@cn.fujitsu.com>
 <2026580.dXZxrES2AW@grover>
 <547EB7F1.9090408@jp.fujitsu.com>
 <547EBE9F.3070805@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <547EBE9F.3070805@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Dec 03, 2014 at 03:41:19PM +0800, Qu Wenruo wrote:
> > How about making lost+found on mkfs.btrfs like ext4?
> >
> I hope most user won't see the lost+found dir.
...
> So lost+found should only occur when it is needed, and when it is needed 
> it will be created.

Ack, as was mentioned before, lost+found is local to the containing
subvolume so creating one for the whole filesystem at mkfs time is of no
use.

The usecase for creating the directory (compared to copying the files
somewhere else) is to give a direct access to the files once the
repaired filesystem is mounted again. Both should be implemented in the
end.
