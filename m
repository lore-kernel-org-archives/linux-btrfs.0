Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f45.google.com ([74.125.82.45]:43224 "EHLO
        mail-wm0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752529AbdLDNqe (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Dec 2017 08:46:34 -0500
Received: by mail-wm0-f45.google.com with SMTP id n138so5899576wmg.2
        for <linux-btrfs@vger.kernel.org>; Mon, 04 Dec 2017 05:46:33 -0800 (PST)
Message-ID: <1512395190.1707.113.camel@gmail.com>
Subject: Re: command to get quota limit
From: ST <smntov@gmail.com>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: linux-btrfs@vger.kernel.org
Date: Mon, 04 Dec 2017 15:46:30 +0200
In-Reply-To: <d06860e1-f905-30ff-941a-92ed61355483@gmx.com>
References: <1512389667.1707.109.camel@gmail.com>
         <d06860e1-f905-30ff-941a-92ed61355483@gmx.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> > Hello,
> > 
> > what is the command to get btrfs quota limit on certain subvolume?
> 
> btrfs qgroup show -re
> 
> The result is for all subvolumes, then just find the subvolume you need.
> 

I need to use the quota number in a script... is there a more specific
command, otherwise I need to get the groupID first and then to parse the
output...

Thank you!

