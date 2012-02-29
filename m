From: lutz.euler@freenet.de (Lutz Euler)
Subject: Re: Bulk discard doesn't work after add/delete of devices
Date: Wed, 29 Feb 2012 01:17:19 +0100
Message-ID: <20301.28303.484287.126799@localhost.localdomain>
References: <20270.59513.240729.662692@localhost.localdomain>
	<4F3386D8.6010108@cn.fujitsu.com>
	<20275.60248.386622.516828@localhost.localdomain>
	<4F34795B.2020004@cn.fujitsu.com>
	<20279.61547.888033.662423@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20279.61547.888033.662423@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I have seen that in the meantime a patch for this issue has found
its way into 3.3-rc5. Unfortunately with this kernel my filesystem still
says "0 bytes were trimmed", so the bug is not fixed for me.

Now that might just have been caused by the fact that the patch that
went into 3.3-rc5 (as commit 2cac13e41bf5b99ffc426bd28dfd2248df1dfa67)
is the one from Liu Bo's mail <4F3386D8.6010108@cn.fujitsu.com>, which
I already responded to by saying it didn't help my issue.

But the next patch Liu sent (in the mail
<4F34795B.2020004@cn.fujitsu.com>) also does not help.
At first I responded to that mail:

> Thanks for providing the new patch. I think it will work in the case
> that "fstrim" is called without specifying a range to trim (that is,
> defaulting to the whole filesystem), but I didn't test that yet, sorry.

I was too optimistic. I have now tested this second patch and still get
"0 bytes were trimmed".

Thanks again and regards,

Lutz
