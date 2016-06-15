Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f53.google.com ([209.85.213.53]:34216 "EHLO
	mail-vk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752559AbcFOT3G (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 15 Jun 2016 15:29:06 -0400
Received: by mail-vk0-f53.google.com with SMTP id t129so43826589vka.1
        for <linux-btrfs@vger.kernel.org>; Wed, 15 Jun 2016 12:29:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJtFHUQ5-UeH4NdagESOeZz6+wya_HpnZJH_jFWfGDG5+oifYg@mail.gmail.com>
References: <CAKzrAgSGRQk_wEairoCUhK6GDCFOVbVWJLub4M_fu7uHC-pO0w@mail.gmail.com>
 <CAKzrAgSP31D+qAVF7fVMRY4qsXMpXDhJxxBAKdbE8=0fkh3N7w@mail.gmail.com> <CAJtFHUQ5-UeH4NdagESOeZz6+wya_HpnZJH_jFWfGDG5+oifYg@mail.gmail.com>
From: "ojab //" <ojab@ojab.ru>
Date: Wed, 15 Jun 2016 19:29:04 +0000
Message-ID: <CAKzrAgTzrZN58SxkZWVJFrf8DJ4mU5ta8cSo+rf5GcbdukmeqA@mail.gmail.com>
Subject: Re: Cannot balance FS (No space left on device)
To: E V <eliventer@gmail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 15, 2016 at 12:41 PM, E V <eliventer@gmail.com> wrote:
> In my experience phantom ENOSPC messages are frequently due to the
> free space cache being corrupt. Mounting with nospace_cache or
> space_cache=v2 may help.

Unfortunately this is not the case.

//wbr ojab
