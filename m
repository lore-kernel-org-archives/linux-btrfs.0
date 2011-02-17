From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH 2/2] Btrfs: Avoid accessing unmapped kernel address
Date: Wed, 16 Feb 2011 21:05:38 -0500
Message-ID: <1297908324-sup-3306@think>
References: <4D5B6971.2040006@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
	Juan Francisco Cantero Hurtado <iam@juanfra.info>
To: Li Zefan <lizf@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <4D5B6971.2040006@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from Li Zefan's message of 2011-02-16 01:06:41 -0500:
> When decompressing a chunk of data, we'll copy the data out to
> a working buffer if the data is stored in more than one page,
> otherwise we'll use the mapped page directly to avoid memory
> copy.
> 
> In the latter case, we'll end up accessing the kernel address
> after we've unmapped the page in a corner case.

Great, thanks I've got this running here now.

-chris
