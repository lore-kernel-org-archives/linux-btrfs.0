Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:30410 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752659AbbHQCB3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 16 Aug 2015 22:01:29 -0400
Subject: Re: kernel BUG at fs/btrfs/extent-tree.c:8113! (4.1.3 kernel)
To: Marc MERLIN <marc@merlins.org>, Josef Bacik <jbacik@fb.com>
References: <20150712010229.GA5284@merlins.org>
 <20150723115558.GQ6306@suse.cz> <20150724162446.GH30815@merlins.org>
 <20150803035130.GL24824@merlins.org> <20150811050758.GF29259@merlins.org>
 <55CA177D.1050004@fb.com> <20150812144749.GY24824@merlins.org>
 <55CB631B.2080404@fb.com> <20150812160936.GK29259@merlins.org>
 <55CB71E5.1070302@fb.com> <20150812171912.GL29259@merlins.org>
CC: <dsterba@suse.com>, <clm@fb.com>, <linux-btrfs@vger.kernel.org>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <55D1406C.9040607@cn.fujitsu.com>
Date: Mon, 17 Aug 2015 10:01:16 +0800
MIME-Version: 1.0
In-Reply-To: <20150812171912.GL29259@merlins.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Marc,

Did btrfs-debug-tree also has the crash?

If not, would you please attach the output if it doesn't contain 
classified data.

Thanks,
Qu

Marc MERLIN wrote on 2015/08/12 10:19 -0700:
> On Wed, Aug 12, 2015 at 12:18:45PM -0400, Josef Bacik wrote:
>> Going to need more info to figure this one out
>
> Thanks for the patch, here's the output:
> enabling repair mode
> Checking filesystem on /dev/mapper/crypt_sdd1
> UUID: 024ba4d0-dacb-438d-9f1b-eeb34083fe49
> checking extents
> wtf, parent 575708413952 <<<<<<
> cmds-check.c:4488: add_data_backref: Assertion `back->bytes != max_size` failed.
> /tmp/btrfs[0x8066a83]
> /tmp/btrfs[0x8066ab4]
> /tmp/btrfs[0x80679d8]
> /tmp/btrfs[0x806b4f2]
> /tmp/btrfs[0x806b9ea]
> /tmp/btrfs[0x806c5f9]
> /tmp/btrfs(cmd_check+0x1088)[0x806ee26]
> /tmp/btrfs(main+0x153)[0x80557d6]
> /lib/i386-linux-gnu/libc.so.6(__libc_start_main+0xf3)[0xb75a54d3]
> /tmp/btrfs[0x80557fc]
>
> Marc
>
