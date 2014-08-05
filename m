Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 220-245-31-42.static.tpgi.com.au ([220.245.31.42]:41621 "EHLO
	smtp.sws.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753469AbaHEMRi (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 5 Aug 2014 08:17:38 -0400
From: Russell Coker <russell@coker.com.au>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Reply-To: russell@coker.com.au
Subject: Re: ENOSPC with mkdir and rename
Date: Tue, 05 Aug 2014 22:17:34 +1000
Message-ID: <5946755.iXasy4PIFE@xev>
In-Reply-To: <53E09B20.4020305@cn.fujitsu.com>
References: <CAFChkqtpb+xMhFk+7RBux-o-FOO0oaxx28Wz-LZZZVpvq2nRFQ@mail.gmail.com> <CAFChkqttiPWQ+FquT2FfKE54US7vkeEyQsUT8fuD1BWNhS3k=w@mail.gmail.com> <53E09B20.4020305@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 5 Aug 2014 16:51:44 Qu Wenruo wrote:
> In fact such "defeat"(or whatever) is not really btrfs only problem.
> In ext*, there is still similiar behavior: ext* has a up limit on the 
> number of inode after mkfs.
> (When you mkfs.ext*, you are prompt the up limit of inodes)
> However other metadata in ext* is stored together with data, so no 
> ENOSPC problem like btrfs.

There is a huge difference between BTRFS and Ext* in this regard.

The way that Ext* has always worked is that if you delete one file, pipe or 
socket that isn't hard-linked, or one sym-link or directory then you free up 1 
Inode.  1 free Inode allows you to create 1 file, pipe, socket, sym-link, or 
directory.

Deleting a file or directory on BTRFS takes MORE metadata space (at least 
temporarily) because it  writes a new copy of the tree.  So not only will 
deleting files not immediately solve a lack of metadata space on BTRFS but it 
might even make things worse.

-- 
My Main Blog         http://etbe.coker.com.au/
My Documents Blog    http://doc.coker.com.au/

