Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from p3nlsmtpcp01-03.prod.phx3.secureserver.net ([184.168.200.142]:54838
        "EHLO p3nlsmtpcp01-03.prod.phx3.secureserver.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728246AbeGPLGR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 16 Jul 2018 07:06:17 -0400
Date: Mon, 16 Jul 2018 16:00:46 +0530
From: "Lakshmipathi.G" <lakshmipathi.g@giis.co.in>
To: Su Yue <suy.fnst@cn.fujitsu.com>
Cc: Lakshmipathi.Ganapathi@collabora.co.uk,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] v2: btrfs-progs: Introduce 'btrfs inspect-internal
 dump-csum' option
Message-ID: <20180716103046.GA20821@giis.co.in>
References: <612cc1b7-1593-478e-ff9f-21784d387a96@cn.fujitsu.com>
 <9b443693-3219-5f62-8a79-aa3c67f93c20@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <9b443693-3219-5f62-8a79-aa3c67f93c20@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> >Sample usage:
> >btrfs inspect-internal dump-csum /btrfs/50gbfile /dev/sda4
> I'm not like the way to pass a filename as a argument.
> Just print content to stdout, let users decides where to redirect.
> And it will decrease amount of codes(part of checking and opening files).
> 

Ok, will remove default output file creation part (filename.csumdump) and
print the content to stdout. 

Cheers.
Lakshmipathi.G
