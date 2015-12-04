Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from static.68.134.40.188.clients.your-server.de ([188.40.134.68]:42354
	"EHLO mail02.iobjects.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753130AbbLDMul (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 4 Dec 2015 07:50:41 -0500
Received: from tux.wizards.de (p4FF582A1.dip0.t-ipconnect.de [79.245.130.161])
	by mail02.iobjects.de (Postfix) with ESMTPSA id BF32C416046B
	for <linux-btrfs@vger.kernel.org>; Fri,  4 Dec 2015 13:50:39 +0100 (CET)
Received: from [192.168.100.223] (ragnarok [192.168.100.223])
	by tux.wizards.de (Postfix) with ESMTP id 5CD9811C01CE
	for <linux-btrfs@vger.kernel.org>; Fri,  4 Dec 2015 13:50:39 +0100 (CET)
Subject: Re: [PATCH 04/12] btrfs: change how delay_iput is tracked in
 btrfs_delalloc_work
To: linux-btrfs@vger.kernel.org
References: <cover.1449161602.git.dsterba@suse.com>
 <a4469a31e3b0cc55ebba9c3aee26cd5632743056.1449161602.git.dsterba@suse.com>
 <20151204022537.GH19589@localhost.localdomain>
 <20151204123625.GF31035@suse.cz>
From: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?=
	<holger.hoffstaette@googlemail.com>
Message-ID: <56618C1F.70805@googlemail.com>
Date: Fri, 4 Dec 2015 13:50:39 +0100
MIME-Version: 1.0
In-Reply-To: <20151204123625.GF31035@suse.cz>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 12/04/15 13:36, David Sterba wrote:
[snip]
> As the use of the inode pointer is limited, I don't think this would
> cause surprises. And it's commented where used which should help during
> debugging.

When I read through those bits (mostly pondering portability) I was wondering
whether it might make sense to provide thin wrap/unwrap functions for the tag
bit instead of relying on open code and comments only. Just an idea, not sure
if it's worth the trouble. The code itself is functional and works fine as it
is, I'm running it right now.

-h

