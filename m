Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fw10b.wadns.net ([196.220.39.29]:23812 "EHLO fw10a.wadns.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752749Ab3CCKlp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 3 Mar 2013 05:41:45 -0500
Message-ID: <513326FA.3070607@swiftspirit.co.za>
Date: Sun, 03 Mar 2013 12:33:30 +0200
From: Brendan Hide <brendan@swiftspirit.co.za>
MIME-Version: 1.0
To: Holger Hoffstaette <holger.hoffstaette@googlemail.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: User feedback: raise the default leaf size to 16k
References: <pan.2013.02.13.10.33.45.439956@googlemail.com>
In-Reply-To: <pan.2013.02.13.10.33.45.439956@googlemail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2013/02/13 12:33 PM, Holger Hoffstaette wrote:
> - raise the leaf size to 16k
> - use single metadata profile
>
> ...
>
> the difference in behaviour on a single disk is *very* noticeable.
Did you try an isolated change of leaf size? I think the devs would be 
willing to look into the default size if it makes a dramatic difference 
on its own. Personally I think you are seeing an improvement more as a 
result of the metadata profile rather than the leafsize.

I don't think changing the default profile for metadata will be easily 
entertained as this is very important for protecting against corruption 
due to bitrot.

-- 
__________
Brendan Hide
http://swiftspirit.co.za/
http://www.webafrica.co.za/?AFF1E97

