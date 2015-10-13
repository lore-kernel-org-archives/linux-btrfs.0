Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:26684 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752242AbbJMLkn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 13 Oct 2015 07:40:43 -0400
From: Zhao Lei <zhaolei@cn.fujitsu.com>
To: <dsterba@suse.cz>
CC: <linux-btrfs@vger.kernel.org>, <clm@fb.com>
References: <fff170b03b5707d4b4457f36da271fadf4bdeade.1444732174.git.zhaolei@cn.fujitsu.com> <20151013112848.GH27761@twin.jikos.cz>
In-Reply-To: <20151013112848.GH27761@twin.jikos.cz>
Subject: RE: [PATCH] btrfs-progs: mkfs: Enable -d dup for single device
Date: Tue, 13 Oct 2015 19:40:30 +0800
Message-ID: <002001d105ab$f6a96c60$e3fc4520$@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi, David Sterba

Thanks for review.

> -----Original Message-----
> From: David Sterba [mailto:dsterba@suse.cz]
> Sent: Tuesday, October 13, 2015 7:29 PM
> To: Zhao Lei <zhaolei@cn.fujitsu.com>
> Cc: linux-btrfs@vger.kernel.org; clm@fb.com
> Subject: Re: [PATCH] btrfs-progs: mkfs: Enable -d dup for single device
> 
> On Tue, Oct 13, 2015 at 06:29:41PM +0800, Zhao Lei wrote:
> > Current code don't support dup profile in single device, except it is
> > in mixed mode, because following reason:
> > 1: In some ssd with deduplication function, it have no effect.
> > 2: For a physical device, it the entire disk broken, -d dup can
> >    not help.
> > 3: Half performance comparing with single profile.
> > 4: We have a workaround: Create multi-partition in single device,
> >    and btefs will treat them as multi device.
> 
> While the above makes sense is true, I'm not sure that DUP was disabled for
> these reasons. I'm sure that I read a comment from Chris that dup for data is
> intentionally disabled because this would lead to corruption, the code for DUP
> for metadata would not work for data. And I can't find the comment, but the
> doubt is there. So unless I find it or get otherwise convicend that it's ok, I won't
> merge the patch. I hope you understand that.
> 
> What I remember from the comment is that "it's slightly offset that would lead
> to corruption".

Before this patch, I had done git blame to search why the condition was added,
and hadn't found the exact reason.

I will queue xfstests(btrfs/generic) at this profile with all mount option
for multi-times, to check is something wrong with this.

Thanks
Zhaolei


