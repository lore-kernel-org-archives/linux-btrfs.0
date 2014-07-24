Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:49292 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758500AbaGXDT2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Jul 2014 23:19:28 -0400
Received: from kw-mxoi1.gw.nic.fujitsu.com (unknown [10.0.237.133])
	by fgwmail5.fujitsu.co.jp (Postfix) with ESMTP id 592AE3EE1D5
	for <linux-btrfs@vger.kernel.org>; Thu, 24 Jul 2014 12:19:27 +0900 (JST)
Received: from s4.gw.fujitsu.co.jp (s4.gw.fujitsu.co.jp [10.0.50.94])
	by kw-mxoi1.gw.nic.fujitsu.com (Postfix) with ESMTP id 34F85AC0230
	for <linux-btrfs@vger.kernel.org>; Thu, 24 Jul 2014 12:19:11 +0900 (JST)
Received: from g01jpfmpwyt03.exch.g01.fujitsu.local (g01jpfmpwyt03.exch.g01.fujitsu.local [10.128.193.57])
	by s4.gw.fujitsu.co.jp (Postfix) with ESMTP id D42251DB803E
	for <linux-btrfs@vger.kernel.org>; Thu, 24 Jul 2014 12:19:10 +0900 (JST)
Message-ID: <53D07B26.4060106@jp.fujitsu.com>
Date: Thu, 24 Jul 2014 12:19:02 +0900
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
MIME-Version: 1.0
To: <dsterba@suse.cz>, Anand Jain <Anand.Jain@oracle.com>,
        <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 1/2] btrfs: syslog when quota is enabled
References: <1404758489-7085-1-git-send-email-Anand.Jain@oracle.com> <20140722174704.GD1553@twin.jikos.cz>
In-Reply-To: <20140722174704.GD1553@twin.jikos.cz>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

(2014/07/23 2:47), David Sterba wrote:
> On Tue, Jul 08, 2014 at 02:41:28AM +0800, Anand Jain wrote:
>> must syslog when btrfs working config changes so is to support
>> offline investigation of the issues.
>
> Missing Signed-off-by line
>
> Reviewed-by: David Sterba <dsterba@suse.cz>

Reviewed-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>

> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

