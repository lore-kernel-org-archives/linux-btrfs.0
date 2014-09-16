Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:65177 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751754AbaIPBqn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Sep 2014 21:46:43 -0400
Message-ID: <1410831965.14842.4.camel@localhost.localdomain>
Subject: Re: How to deal with "The chunks in memory can not match the
 metadata of the fs. Repair failed."?
From: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
To: Karl-Philipp Richter <richter@richtercloud.de>
CC: <linux-btrfs@vger.kernel.org>
Date: Tue, 16 Sep 2014 09:46:05 +0800
In-Reply-To: <5416FECF.5030709@richtercloud.de>
References: <5416FECF.5030709@richtercloud.de>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 2014-09-15 at 16:59 +0200, Karl-Philipp Richter wrote:
> Hi together,
> I'm currently encountering another issue with `btrfs rescue 
> chunk-recover`. After some seconds of maximal I/O activity, the program 
> is idle for some seconds and then prints
> 
>      The chunks in memory can not match the metadata of the fs. Repair 
> failed.
>      Fail to recover the chunk tree.
> 
> I don't find any mention of this output except in the source code (this 
> is as well the only thing $SEARCH_ENGINE points me to). What is the 
> recommended next step? It would be nice to see the situation (The chunks 
> in memory can not match the metadata of the fs) or the output mentioned 
> in `man btrfs rescue`.
> 
> Any help is appreciated.
> 
> -Kalle

Hi Kalle,
If you are encountering the above msg, it means the chunk tree has some
inconsistent stuff with other trees like device tree & extent tree.
You can specify the '-v' option for chunk-recover to see more details.

And also, the btrfs check cmd may tell more about the story.

Thanks,
Gui


> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


