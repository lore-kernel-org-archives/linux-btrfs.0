Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fw7a-meaghan.wadns.net ([41.185.62.72]:56090 "EHLO
	fw7a.wadns.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752250AbaJBSjE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 2 Oct 2014 14:39:04 -0400
Received: from lnxwebr01.cpt.wa.co.za ([41.185.8.51])
	by fw7a.wadns.net with esmtp (Exim 4.80)
	(envelope-from <brendan@swiftspirit.co.za>)
	id 1XZlH9-0000rf-5q
	for linux-btrfs@vger.kernel.org; Thu, 02 Oct 2014 20:38:58 +0200
Received: from [196.215.171.153] (port=49526 helo=[192.168.88.35])
	by lnxwebr01.cpt.wa.co.za with esmtpsa (TLSv1:DHE-RSA-CAMELLIA256-SHA:256)
	(Exim 4.82)
	(envelope-from <brendan@swiftspirit.co.za>)
	id 1XZlH8-0041TA-0f
	for linux-btrfs@vger.kernel.org; Thu, 02 Oct 2014 20:38:50 +0200
Message-ID: <542D9BB9.40507@swiftspirit.co.za>
Date: Thu, 02 Oct 2014 20:38:49 +0200
From: Brendan Hide <brendan@swiftspirit.co.za>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Re: btrfs check segfaults after flipping 2 Bytes
References: <542C6443.1010809@niklasfi.de> <pan$36400$3ee14aa9$ee1e5a94$415ce7b2@cox.net> <542CE7CC.4020904@swiftspirit.co.za>
In-Reply-To: <542CE7CC.4020904@swiftspirit.co.za>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2014/10/02 07:51, Brendan Hide wrote:
> On 2014/10/02 01:31, Duncan wrote:
> [snip]
>
> I'm not sure if there is a mount option for this use case however. The 
> option descriptions for "nodatasum" and "nodatacow" imply that *new* 
> checksums are not generated. In this case the checksums already exist.
>
Looks like btrfsck has a relevant option, albeit likely more destructive 
than absolutely necessary:
--init-csum-tree
    create a new CRC tree.

^ Also, mail was sent as HTML 12 hours ago thus was never delivered. 
Thunderbird has been disciplined.

-- 
__________
Brendan Hide
http://swiftspirit.co.za/
http://www.webafrica.co.za/?AFF1E97

