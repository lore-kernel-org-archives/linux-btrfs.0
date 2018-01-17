Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail02.iobjects.de ([188.40.134.68]:49646 "EHLO
        mail02.iobjects.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752868AbeAQVvK (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 17 Jan 2018 16:51:10 -0500
Subject: Re: Can rsync use reflink to synchronize directories?
To: MegaBrutal <megabrutal@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <CAE8gLhkWRUO=UQh6cvM=D=7AYsuNxDG3yjUSCkuyTUVPnFW4Yw@mail.gmail.com>
From: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>
Message-ID: <3d5595fb-1da6-d67d-0660-f3d21dd9665c@applied-asynchrony.com>
Date: Wed, 17 Jan 2018 22:51:07 +0100
MIME-Version: 1.0
In-Reply-To: <CAE8gLhkWRUO=UQh6cvM=D=7AYsuNxDG3yjUSCkuyTUVPnFW4Yw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 01/17/18 18:35, MegaBrutal wrote:
> Does rsync support copying files with reflink on local btrfs file
> system? Of course it could only work if the necessary conditions for
> reflinking are met, but it would be very useful.

Not yet: https://bugzilla.samba.org/show_bug.cgi?id=10170

-h
