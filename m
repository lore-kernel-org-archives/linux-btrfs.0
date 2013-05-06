Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:37474 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751773Ab3EFAiE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 5 May 2013 20:38:04 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id DB2EF7C067C
	for <linux-btrfs@vger.kernel.org>; Sun,  5 May 2013 18:38:03 -0600 (MDT)
Date: Sun, 5 May 2013 20:38:01 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Maciek Sujkowski <maciej.sujkowski@gmail.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Fwd: kernel BUG at fs/btrfs/extent-tree.c:5446!
Message-ID: <20130506003801.GF12414@localhost.localdomain>
References: <CAOZ-2LFKh7VwUe577pxpLntvnzknCxYw7dnJBE9Wka7+bFhCGg@mail.gmail.com>
 <CAOZ-2LGFNrEefi2Q5ChMq8WMi5R1EwMWzcFyOoYz4sXH0x9+qQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <CAOZ-2LGFNrEefi2Q5ChMq8WMi5R1EwMWzcFyOoYz4sXH0x9+qQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, May 05, 2013 at 03:42:26PM -0600, Maciek Sujkowski wrote:
> Hi,
> 
> Attached is the log from another btrfs bug.
> My filesystem is crashed and even btrfs-restore can't recover all data.
>

Can you pull my btrfs-progs git tree here

git://github.com/josefbacik/btrfs-progs.git

build it and run ./btrfs-image -w -c9 -t4 /dev/whatever blah.img

and upload blah.img somewhere that I can pull this down.  Also please open a bug
on kernel.bugzilla.org (make sure to set the component to Btrfs) so I can track
this issue.  Thanks,

Josef 
