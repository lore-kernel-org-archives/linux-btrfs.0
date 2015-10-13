Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42232 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752612AbbJML36 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 13 Oct 2015 07:29:58 -0400
Date: Tue, 13 Oct 2015 13:28:48 +0200
From: David Sterba <dsterba@suse.cz>
To: Zhao Lei <zhaolei@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, clm@fb.com
Subject: Re: [PATCH] btrfs-progs: mkfs: Enable -d dup for single device
Message-ID: <20151013112848.GH27761@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <fff170b03b5707d4b4457f36da271fadf4bdeade.1444732174.git.zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <fff170b03b5707d4b4457f36da271fadf4bdeade.1444732174.git.zhaolei@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Oct 13, 2015 at 06:29:41PM +0800, Zhao Lei wrote:
> Current code don't support dup profile in single device, except it
> is in mixed mode, because following reason:
> 1: In some ssd with deduplication function, it have no effect.
> 2: For a physical device, it the entire disk broken, -d dup can
>    not help.
> 3: Half performance comparing with single profile.
> 4: We have a workaround: Create multi-partition in single device,
>    and btefs will treat them as multi device.

While the above makes sense is true, I'm not sure that DUP was disabled
for these reasons. I'm sure that I read a comment from Chris that dup
for data is intentionally disabled because this would lead to
corruption, the code for DUP for metadata would not work for data. And I
can't find the comment, but the doubt is there. So unless I find it or
get otherwise convicend that it's ok, I won't merge the patch. I hope
you understand that.

What I remember from the comment is that "it's slightly offset that would
lead to corruption".
