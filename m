Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46804 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757189AbcFAFiC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 1 Jun 2016 01:38:02 -0400
Date: Tue, 31 May 2016 22:38:00 -0700
From: Mark Fasheh <mfasheh@suse.de>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.com>,
        Josef Bacik <jbacik@fb.com>
Subject: Re: [PATCH] Improve balance performance when qgroups are turned on
Message-ID: <20160601053800.GE7633@wotan.suse.de>
Reply-To: Mark Fasheh <mfasheh@suse.de>
References: <20160527001806.GX7633@wotan.suse.de>
 <f65fce82-4985-8fc5-604d-399fbc7b5e3c@cn.fujitsu.com>
 <20160601005008.GD7633@wotan.suse.de>
 <32fe4f1d-0ad8-da6f-ccca-becd551b4bee@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <32fe4f1d-0ad8-da6f-ccca-becd551b4bee@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 01, 2016 at 09:31:14AM +0800, Qu Wenruo wrote:
> Thanks　for the test case.
> It would be better if you could submit a test case for it.

Yeah I'll handle this.


> Reproduced the problem. I'll track it down.
> Seems to be related with metadata.

Thanks, please CC me on any patches.
	--Mark

--
Mark Fasheh
