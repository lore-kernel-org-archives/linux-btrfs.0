Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.161]:44697 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752511Ab3FEJRJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 5 Jun 2013 05:17:09 -0400
Message-ID: <51AF0218.8040602@giantdisaster.de>
Date: Wed, 05 Jun 2013 11:17:12 +0200
From: Stefan Behrens <sbehrens@giantdisaster.de>
MIME-Version: 1.0
To: Alex Lyakas <alex.btrfs@zadarastorage.com>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: wait_block_group_cache_progress() waits forever in case of drive
 failure
References: <CAOcd+r1Z665=5E-8Z_70tQoPDAv2A8MFdfgHQgv10jq6K-faSw@mail.gmail.com>
In-Reply-To: <CAOcd+r1Z665=5E-8Z_70tQoPDAv2A8MFdfgHQgv10jq6K-faSw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 4 Jun 2013 19:23:18 +0300, Alex Lyakas wrote:
[...]
> P.S: should I open a bugzilla for this?

Yes.
Otherwise the bug report gets lost.
