From: lutz.euler@freenet.de (Lutz Euler)
Subject: Re: Bulk discard doesn't work after add/delete of devices
Date: Tue, 10 Apr 2012 19:34:03 +0200
Message-ID: <20356.28427.586846.710401@localhost.localdomain>
References: <20270.59513.240729.662692@localhost.localdomain>
	<4F3386D8.6010108@cn.fujitsu.com>
	<20275.60248.386622.516828@localhost.localdomain>
	<4F34795B.2020004@cn.fujitsu.com>
	<20279.61547.888033.662423@localhost.localdomain>
	<20301.28303.484287.126799@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20301.28303.484287.126799@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

the issue I raised in this thread is still not fixed. Please, could
someone look into it? A fix should be simple, especially as the issue is
easily reproducable. (In case the information in this thread so far is
not sufficient for that I will happily provide a recipe; just ask.)
Also, I believe so far not even a regression test has been added for
this issue.

Here's the state of affairs again, as I mailed previously:

> I have seen that in the meantime a patch for this issue has found
> its way into 3.3-rc5. Unfortunately with this kernel my filesystem still
> says "0 bytes were trimmed", so the bug is not fixed for me.
> 
> Now that might just have been caused by the fact that the patch that
> went into 3.3-rc5 (as commit 2cac13e41bf5b99ffc426bd28dfd2248df1dfa67)
> is the one from Liu Bo's mail <4F3386D8.6010108@cn.fujitsu.com>, which
> I already responded to by saying it didn't help my issue.
> 
> But the next patch Liu sent (in the mail
> <4F34795B.2020004@cn.fujitsu.com>) also does not help.
> At first I responded to that mail:
> 
> > Thanks for providing the new patch. I think it will work in the case
> > that "fstrim" is called without specifying a range to trim (that is,
> > defaulting to the whole filesystem), but I didn't test that yet, sorry.
> 
> I was too optimistic. I have now tested this second patch and still get
> "0 bytes were trimmed".

Thanks for providing btrfs! Greetings,

Lutz
