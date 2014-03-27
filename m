Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fw7a-shanna.wadns.net ([196.220.39.217]:19642 "EHLO
	fw7a.wadns.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753406AbaC0Hfw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 27 Mar 2014 03:35:52 -0400
Message-ID: <5333D4CD.6030605@swiftspirit.co.za>
Date: Thu, 27 Mar 2014 09:35:41 +0200
From: Brendan Hide <brendan@swiftspirit.co.za>
MIME-Version: 1.0
To: Gui Hecheng <guihc.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: add btrfs resize unit t/p/e support
References: <1395888673-28433-1-git-send-email-guihc.fnst@cn.fujitsu.com>
In-Reply-To: <1395888673-28433-1-git-send-email-guihc.fnst@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2014/03/27 04:51 AM, Gui Hecheng wrote:
> [snip]
>
> We add t/p/e support by replacing lib/cmdline.c:memparse
> with btrfs_memparse. The btrfs_memparse copies memparse's code
> and add unit t/p/e parsing.
Is there a conflict preventing adding this to memparse directly?

-- 
__________
Brendan Hide
http://swiftspirit.co.za/
http://www.webafrica.co.za/?AFF1E97

