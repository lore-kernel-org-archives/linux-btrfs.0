From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH 1/2 v2] Btrfs: kill location key of in-memory inode
Date: Mon, 27 Jun 2011 21:54:16 -0400
Message-ID: <1309226015-sup-8915@shiny>
References: <1308538756-31203-1-git-send-email-liubo2009@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>,
	t-itoh <t-itoh@jp.fujitsu.com>, dave <dave@jikos.cz>
To: Liu Bo <liubo2009@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <1308538756-31203-1-git-send-email-liubo2009@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from Liu Bo's message of 2011-06-19 22:59:15 -0400:
> In btrfs's in-memory inode, there is a btrfs_key which has the structure:
> - key.objectid
> - key.type
> - key.offset
> 
> however, we only use key.objectid to search, to check or something else,
> and to reduce in-memory inode size I just keep what is valuable.

I'm still reviewing this, mostly because I had plans on using the full
location as part of the inodes for tree roots.  But this might not
really be required anymore.

-chris
