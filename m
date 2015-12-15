Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:48500 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S933012AbbLOBQy (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 14 Dec 2015 20:16:54 -0500
Subject: Re: bad extent [5993525264384, 5993525280768), type mismatch with
 chunk
To: Laurent Bonnaud <L.Bonnaud@laposte.net>,
        Qu Wenruo <quwenruo.btrfs@gmx.com>
References: <56455073.1060406@cn.fujitsu.com> <564F48FE.4000400@laposte.net>
 <1448047478.6878.4.camel@scientia.net> <564FBF0F.4050705@gmx.com>
 <564FC3FE.9020905@lukas-pirl.de> <565122AA.90904@gmx.com>
 <56519644.8060105@laposte.net> <56526543.4090301@cn.fujitsu.com>
 <565462F7.8040601@laposte.net> <5654F6BC.8020900@gmx.com>
 <565579DB.2040105@laposte.net> <56607848.5040705@laposte.net>
 <5660E2BD.3050000@cn.fujitsu.com> <566ADBF6.9090507@laposte.net>
 <566EBA5D.5030200@laposte.net>
CC: Lukas Pirl <btrfs@lukas-pirl.de>, <linux-btrfs@vger.kernel.org>,
        <calestyo@scientia.net>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <566F69FB.4060105@cn.fujitsu.com>
Date: Tue, 15 Dec 2015 09:16:43 +0800
MIME-Version: 1.0
In-Reply-To: <566EBA5D.5030200@laposte.net>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Laurent Bonnaud wrote on 2015/12/14 13:47 +0100:
> On 11/12/2015 15:21, Laurent Bonnaud wrote:
>
>> The next step will we to run a "btrfs scrub" to check if data loss did happen...
>
> Scrubbing is now finished and it detected no errors.
>
Glad to hear that.

Your fs should be OK now.

Thanks,
Qu


