Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:52600 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761286AbbKUArZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 20 Nov 2015 19:47:25 -0500
Subject: Re: bad extent [5993525264384, 5993525280768), type mismatch with
 chunk
To: Christoph Anton Mitterer <calestyo@scientia.net>,
        Laurent Bonnaud <L.Bonnaud@laposte.net>, quwenruo@cn.fujitsu.com,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <56455073.1060406@cn.fujitsu.com> <564F48FE.4000400@laposte.net>
 <1448047478.6878.4.camel@scientia.net>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <564FBF0F.4050705@gmx.com>
Date: Sat, 21 Nov 2015 08:47:11 +0800
MIME-Version: 1.0
In-Reply-To: <1448047478.6878.4.camel@scientia.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 11/21/2015 03:24 AM, Christoph Anton Mitterer wrote:
> On Fri, 2015-11-20 at 17:23 +0100, Laurent Bonnaud wrote:
>> So here is the output of "btrfs-debug-tree -t 2 <dev>" in case it may
> Gosh... 15M via mail?! o.O
>
> Anyway an update from my side...
> I've copied all data from the fs in question to a new btrfs,... done
> under Linux 4.2.6 and btrfs-progs v4.3.
> No data was lost or anyhow corrupted (also shown by extensive tests
> using my XATTR hashsums and other backups I've had).
>
> On the new fs, btrfs doesn't report that error anymore.
> No snapshots/etc made so far on the new fs.
>
>
>
> Qu, have you had a look at btrfs check already?

Nothing interesting found...
And if the codes go crazy, it should also infect your new filesystem, 
but it doesn't...

>
> And you've explained that the fs was okay and only the check was
> wrong... but since the false positive errors don't appear on my copied
> fs, does that really mean that the skinny metadata changed so much, or
> was anything changed in the kernel that the same didn't appear on the
> new fs anymore (or was it perhaps because I was using snapshots?)
>

Hard to say, but we'd better keep an eye on this issue.
At least, if it happens again, we should know if it's related to 
something like newer kernel or snapshots.

Thanks,
Qu

>
> Cheers,
> Chris.
>
