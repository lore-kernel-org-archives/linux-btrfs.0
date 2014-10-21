Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from resqmta-ch2-08v.sys.comcast.net ([69.252.207.40]:55159 "EHLO
	resqmta-ch2-08v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750978AbaJUPEZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 21 Oct 2014 11:04:25 -0400
Message-ID: <544675F7.3010808@pobox.com>
Date: Tue, 21 Oct 2014 08:04:23 -0700
From: Robert White <rwhite@pobox.com>
MIME-Version: 1.0
To: Cristian Falcas <cristi.falcas@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: downgrade from kernel 3.17 to 3.10
References: <CAMo7R_e9=wdGhEm9P+DZgXrKQ+qrKqdELzwwi-OMTCp6Mk8aTg@mail.gmail.com>
In-Reply-To: <CAMo7R_e9=wdGhEm9P+DZgXrKQ+qrKqdELzwwi-OMTCp6Mk8aTg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 10/21/2014 01:13 AM, Cristian Falcas wrote:
> Can I downgrade the kernel from 3.17.1 to latest 3.10 if I have a
> btrfs partition formatted and used on 3.17.1?

I went back from 3.17.0 to 3.16.3 when 3.17 acted flaky, and since then 
gone up to 3.16.5 with nice results. 3.17.2 is, I think, expected to 
contain the actual fixes

Did you upgrade straight from 3.10 to 3.17?

Going all the way back to 3.10 is probably a bad thing. There's been a 
lot of work since then. I'd build a new 3.16.5 and switch to that.

DONT go back further, and DONT run btrfsck until the mainline and tools 
that fix the "read-only snapshot bug" are in your system. I think that's 
going to be 3.17.2 and the 3.17 btrfs tools. If you use older tools you 
may end up having to recreate the partition completely.



