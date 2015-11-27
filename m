Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:55271 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753890AbbK0LUc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 27 Nov 2015 06:20:32 -0500
Subject: Re: PAX: size overflow detected in function try_merge_map
 fs/btrfs/extent_map.c:238
To: fdmanana@gmail.com
References: <565834B3.4020602@gmx.de>
 <CAL3q7H4F4ohPo=LK_dhT+wom7KmP7PwSqm8GzkvknPpBqbR85Q@mail.gmail.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
From: =?UTF-8?Q?Toralf_F=c3=b6rster?= <toralf.foerster@gmx.de>
Message-ID: <56583C7C.5080904@gmx.de>
Date: Fri, 27 Nov 2015 12:20:28 +0100
MIME-Version: 1.0
In-Reply-To: <CAL3q7H4F4ohPo=LK_dhT+wom7KmP7PwSqm8GzkvknPpBqbR85Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 11/27/2015 12:07 PM, Filipe Manana wrote:
> Try the following (also pasted at
> https://friendpaste.com/5O6o1cqWqJZDIKrH1YqG7y):

Doesn't apply neither against the used 4.2.6 kernel nor aginst current git HEAD :

t44 linux # patch -p1 --dry-run < /home/tfoerste/Downloads/5O6o1cqWqJZDIKrH1YqG7y.diff.patch
checking file fs/btrfs/extent_map.c
Hunk #1 FAILED at 235.
Hunk #2 FAILED at 252.
2 out of 2 hunks FAILED


tfoerste@t44 ~/devel/linux $ patch -p1 --dry-run < ~/Downloads/5O6o1cqWqJZDIKrH1YqG7y.diff.patch
checking file fs/btrfs/extent_map.c
Hunk #1 FAILED at 235.
Hunk #2 FAILED at 252.
2 out of 2 hunks FAILED

-- 
Toralf, pgp: C4EACDDE 0076E94E
