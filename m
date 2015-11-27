Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from static.68.134.40.188.clients.your-server.de ([188.40.134.68]:33472
	"EHLO mail02.iobjects.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753262AbbK0LvX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 27 Nov 2015 06:51:23 -0500
Subject: Re: PAX: size overflow detected in function try_merge_map
 fs/btrfs/extent_map.c:238
To: =?UTF-8?Q?Toralf_F=c3=b6rster?= <toralf.foerster@gmx.de>,
        fdmanana@gmail.com
References: <565834B3.4020602@gmx.de>
 <CAL3q7H4F4ohPo=LK_dhT+wom7KmP7PwSqm8GzkvknPpBqbR85Q@mail.gmail.com>
 <56583C7C.5080904@gmx.de>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
From: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?=
	<holger.hoffstaette@googlemail.com>
Message-ID: <565843B8.1050205@googlemail.com>
Date: Fri, 27 Nov 2015 12:51:20 +0100
MIME-Version: 1.0
In-Reply-To: <56583C7C.5080904@gmx.de>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 11/27/15 12:20, Toralf Förster wrote:
> On 11/27/2015 12:07 PM, Filipe Manana wrote:
>> Try the following (also pasted at
>> https://friendpaste.com/5O6o1cqWqJZDIKrH1YqG7y):
> 
> Doesn't apply neither against the used 4.2.6 kernel nor aginst current git HEAD :
> 
> t44 linux # patch -p1 --dry-run < /home/tfoerste/Downloads/5O6o1cqWqJZDIKrH1YqG7y.diff.patch
> checking file fs/btrfs/extent_map.c
> Hunk #1 FAILED at 235.
> Hunk #2 FAILED at 252.
> 2 out of 2 hunks FAILED
> 
> 
> tfoerste@t44 ~/devel/linux $ patch -p1 --dry-run < ~/Downloads/5O6o1cqWqJZDIKrH1YqG7y.diff.patch
> checking file fs/btrfs/extent_map.c
> Hunk #1 FAILED at 235.
> Hunk #2 FAILED at 252.
> 2 out of 2 hunks FAILED
> 

Toralf,

try with --ignore-whitespace, that works for me. Seems the pastebin ate
some formatting.

-h

