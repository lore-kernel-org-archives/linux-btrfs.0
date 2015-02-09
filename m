Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from asuka.romanrm.net ([128.199.122.184]:45308 "EHLO
	asuka.romanrm.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932308AbbBIR1h (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 9 Feb 2015 12:27:37 -0500
Date: Mon, 9 Feb 2015 22:27:31 +0500
From: Roman Mamedov <rm@romanrm.net>
To: "Devon B." <devon.b@virtualcomplete.com>, linux-btrfs@vger.kernel.org
Subject: Re: Accepting discard to free space from disk images
Message-ID: <20150209222731.5bc0f15b@natsu>
In-Reply-To: <54D8E946.8060900@virtualcomplete.com>
References: <54D842FD.1010806@virtualcomplete.com>
	<20150209114023.137402bf@natsu>
	<54D8D1A9.1070006@virtualcomplete.com>
	<20150209204256.51278106@natsu>
	<20150209204521.7b556d93@natsu>
	<54D8E946.8060900@virtualcomplete.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 09 Feb 2015 12:07:18 -0500
"Devon B." <devon.b@virtualcomplete.com> wrote:

> Thanks for your testing.  I haven't tried 3.14.  I tried on CentOS 6 box 
> (2.6.32 - which is experimental) and Ubuntu 14.04 (3.13) and neither 
> worked.  So the question remains, what is the difference?  Possibly a 
> small difference between the 3.13 and 3.14 kernels, I don't think it is 
> any of the mount options.  I guess if anyone else has insight on this, 
> that would be great.  Otherwise, I'll see if I can get a newer kernel 
> loaded up and do some more testing.

Use "Reply to all" and not just "Reply", or "anyone else" won't see your
question.

BTW it is not a good idea to use Btrfs on 2.6.32.

-- 
With respect,
Roman
