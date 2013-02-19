Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-p05-ob.rzone.de ([81.169.146.182]:61221 "EHLO
	mo-p05-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932103Ab3BSIL5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 19 Feb 2013 03:11:57 -0500
Message-ID: <512333C5.2070405@jan-o-sch.net>
Date: Tue, 19 Feb 2013 09:11:49 +0100
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
MIME-Version: 1.0
To: Alex Lyakas <alex.btrfs@zadarastorage.com>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>,
        Alexander Block <ablock84@googlemail.com>
Subject: Re: backref for an extent not found in send_root (!backref_ctx->found_itself)
References: <CAOcd+r36TOugPs+5P3W6v6m5pzojGnqZ3YUNS-zzFK2pdm1A8A@mail.gmail.com> <51079151.4070905@jan-o-sch.net> <CAOcd+r0u=nF9V9wWGttQGMDbO7GJ+o-_CuaVf5Qi+-929WZt_A@mail.gmail.com> <CAOcd+r1wVvxwDZE7SK5iVpCMK5nMq-VD7kXo91f4+AX9LALMgw@mail.gmail.com>
In-Reply-To: <CAOcd+r1wVvxwDZE7SK5iVpCMK5nMq-VD7kXo91f4+AX9LALMgw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Alex,

On Tue, February 19, 2013 at 08:58 (+0100), Alex Lyakas wrote:
> any luck reproducing this?

Just yesterday, yes. I was busy doing non-btrfs things, I've got an idea about
the problem, but unfortunately I'm again busy doing other things right now. That
will hopefully be the last distraction before fixing this.

Thanks again for your good reproducer!
-Jan
