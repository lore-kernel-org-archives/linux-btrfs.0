Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:50664 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751325AbbK3Fo4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 30 Nov 2015 00:44:56 -0500
Subject: potential btrfs-progs clean up
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
References: <1448453300-8449-1-git-send-email-anand.jain@oracle.com>
 <5656683C.6060001@cn.fujitsu.com> <5656A18E.9050607@oracle.com>
 <5656AC64.3030304@cn.fujitsu.com>
Cc: dsterba@suse.cz, calestyo@scientia.net, ahferroin7@gmail.com,
        1i5t5.duncan@cox.net
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <565BE23C.3010400@oracle.com>
Date: Mon, 30 Nov 2015 13:44:28 +0800
MIME-Version: 1.0
In-Reply-To: <5656AC64.3030304@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



(this is a different topic, updated the subject)

> Totally agree with this point. Too many non-sense in btrfs-progs codes
> copied from kernel, and due to lack of update, it's very buggy now.
> Just check volume.c for allocating data chunk.

   Which functions in volume.c in particular ?

Thanks, Anand
