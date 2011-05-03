From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH 1/3] fs: remove FS_COW_FL
Date: Tue, 03 May 2011 07:20:11 -0400
Message-ID: <1304421568-sup-4709@think>
References: <4DA7B559.8060800@cn.fujitsu.com> <4DBFC6D0.3010105@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
To: Li Zefan <lizf@cn.fujitsu.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-reply-to: <4DBFC6D0.3010105@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from Li Zefan's message of 2011-05-03 05:11:44 -0400:
> Any comments? If this patch is acceptable, it should be queued for .39?
> since fs.h is exported to userspace.
>
> Li Zefan wrote:
> > FS_COW_FL and FS_NOCOW_FL were newly introduced to control per file
> > COW in btrfs, but FS_NOCOW_FL is sufficient.
> > 

Good point, I'll send this in.

-chris
