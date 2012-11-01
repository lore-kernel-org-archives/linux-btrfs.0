Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ea0-f174.google.com ([209.85.215.174]:49090 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761866Ab2KAQ1k (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 1 Nov 2012 12:27:40 -0400
Received: by mail-ea0-f174.google.com with SMTP id c13so1046240eaa.19
        for <linux-btrfs@vger.kernel.org>; Thu, 01 Nov 2012 09:27:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <50920371.7090601@gmx.net>
References: <CANmUDYsPqS9ZUVWhzxQv4G6fkQaRbGa2M3TTECp+tujJtyN4EA@mail.gmail.com>
	<CAE5mzvi0jLAm_pp0YzD=o2W86jrPSnNw3Z+3UFq9ZY1joynCew@mail.gmail.com>
	<CANmUDYuTLu5M7PAG1_w2bPORMs73yRmfSc0-2Wx7+UU+FPbs-w@mail.gmail.com>
	<50920371.7090601@gmx.net>
Date: Thu, 1 Nov 2012 08:27:38 -0800
Message-ID: <CANmUDYsoaymfjV+1eu+sg_037GczSHwC_UqQ=Xg_oK_aCuE2Kg@mail.gmail.com>
Subject: Re: find-new possibility of showing modified and deleted files/directories
From: Shane Spencer <shane@bogomip.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
To: unlisted-recipients:; (no To-header on input)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Oct 31, 2012 at 9:06 PM, Arne Jansen <sensille@gmx.net> wrote:
>
> On 11/01/2012 02:28 AM, Shane Spencer wrote:
> > That's Plan B.  I'll be making a btrfs stream decoder and doing in
> > place edits.  I need to move stuff around to other filesystem types
> > otherwise I'd just store the stream or apply the stream to a remote
> > snapshot.
>
> That's the whole point of the btrfs-send design: It's very easy to
> receive on different filesystems. A generic receiver is in preparation.
> And to make it even more generic: A sender using the same stream
> format is also in preparation for zfs.
>

You just made my day. I will probably be approaching a lot of this
from Python as well so I'm very interested in the stream format
itself.
