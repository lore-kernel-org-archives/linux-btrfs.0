Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f49.google.com ([209.85.160.49]:44777 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751301AbaBCNS5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 3 Feb 2014 08:18:57 -0500
Received: by mail-pb0-f49.google.com with SMTP id up15so6999664pbc.22
        for <linux-btrfs@vger.kernel.org>; Mon, 03 Feb 2014 05:18:56 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <52E9721D.6000908@matthewlai.ca>
References: <52E9721D.6000908@matthewlai.ca>
Date: Mon, 3 Feb 2014 14:18:56 +0100
Message-ID: <CAFTPBc+G+KvtR8deP47Nygq1PhjpjKwjRkPP-YPazWiXNp0vUQ@mail.gmail.com>
Subject: Re: Receive on same subvolume
From: Felix Blanke <felixblanke@gmail.com>
To: Matthew Lai <m@matthewlai.ca>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Matthew,

I'm not sure what you are trying to achive. Couldn't you simply do
another snapshot of the subvolume? I don't understand why you want to
use send/receive on the same subvolume to be honest.

Regards,
Felix

On Wed, Jan 29, 2014 at 10:26 PM, Matthew Lai <m@matthewlai.ca> wrote:
> Hello,
>
> Is this supposed to work? (/data is the root volume, /data/a is a subvolume)
>
> btrfs subvolume snapshot /data/a /data/b
> # make some changes in b
> btrfs send -p /data/a /data/b > delta
> btrfs receive /data/a < delta
>
> I'm getting "ERROR: could not find parent subvolume" on receive.
>
> What I'm trying to do is to back up using send/receive, but I don't have 50%
> free space, and (please correct me if I'm wrong) since receive doesn't do
> deduplication, I want to use snapshot to do the initial bootstrapping,
> instead of send/receive without a parent.
>
> Thanks!
> Matthew
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
