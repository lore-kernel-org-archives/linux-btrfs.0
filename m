Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f171.google.com ([209.85.213.171]:38006 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753627AbbDRQXf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 18 Apr 2015 12:23:35 -0400
Received: by igbhj9 with SMTP id hj9so33458532igb.1
        for <linux-btrfs@vger.kernel.org>; Sat, 18 Apr 2015 09:23:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <u6ca0c-12c.ln1@hurikhan77.spdns.de>
References: <1429312124.8371.62.camel@scientia.net>
	<u6ca0c-12c.ln1@hurikhan77.spdns.de>
Date: Sat, 18 Apr 2015 10:23:34 -0600
Message-ID: <CAJCQCtRCvO5hE1Fo6Y=2rk7Amg6KQtm2gcUvFQTu2r=9kErvNQ@mail.gmail.com>
Subject: Re: how to clone a btrfs filesystem
From: Chris Murphy <lists@colorremedies.com>
To: Kai Krakow <hurikhan77@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Apr 18, 2015 at 10:09 AM, Kai Krakow <hurikhan77@gmail.com> wrote:

> You could simply "btrfs device add" the new device, then "btrfs device del"
> the old device...

That wipes the btrfs signature (maybe the entire superblock, I'm not
sure) from the deleted device. It needs to be a seed device first to
prevent that, which makes it ro.


-- 
Chris Murphy
