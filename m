Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:32695 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751996AbaGGAiW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 6 Jul 2014 20:38:22 -0400
Message-ID: <53B9EC3D.7090101@cn.fujitsu.com>
Date: Mon, 7 Jul 2014 08:39:25 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v4] btrfs-progs: Add minimum device size check
References: <1404458957-23621-1-git-send-email-quwenruo@cn.fujitsu.com> <20140704141746.GP1553@twin.jikos.cz> <20140704152140.GQ1553@twin.jikos.cz>
In-Reply-To: <20140704152140.GQ1553@twin.jikos.cz>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


-------- Original Message --------
Subject: Re: [PATCH v4] btrfs-progs: Add minimum device size check
From: David Sterba <dsterba@suse.cz>
To: dsterba@suse.cz, Qu Wenruo <quwenruo@cn.fujitsu.com>, 
linux-btrfs@vger.kernel.org
Date: 2014年07月04日 23:21
> On Fri, Jul 04, 2014 at 04:17:46PM +0200, David Sterba wrote:
>> On Fri, Jul 04, 2014 at 03:29:17PM +0800, Qu Wenruo wrote:
>>> v4: Fix a variant reuse bug which causes mkfs.btrfs use wrong first device.
>> Can you please send this incremental change only? The v3 patch is deep
>> in the v3.15.x branch that's supposed to comprise patches for the 3.15
>> release. The diff between v3 and v4 is pretty small, such mistakes
>> happen, no big deal (unlike rebasing a branch that was public for some
>> time already).
> Oh crap, I left my note in subject of the v3 patch in git. I'd rather
> not let it to the final branch, but the rebase is be necessary.
> Sorry. I'll take v4 then.
Sorry for the extra rebase work.

Thanks anyway.
Qu
