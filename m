Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f54.google.com ([209.85.213.54]:35037 "EHLO
	mail-vk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751780AbbHYQjk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Aug 2015 12:39:40 -0400
Received: by vkfi73 with SMTP id i73so76546105vkf.2
        for <linux-btrfs@vger.kernel.org>; Tue, 25 Aug 2015 09:39:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1440516154.040713246@apps.rackspace.com>
References: <1440516154.040713246@apps.rackspace.com>
Date: Tue, 25 Aug 2015 10:39:39 -0600
Message-ID: <CAJCQCtTSU08EjVrYGyL5TuXsEtTEmkAkpZ4XjM5rMXVZLQsjPA@mail.gmail.com>
Subject: Re: Response to Bcachefs Claims
From: Chris Murphy <lists@colorremedies.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Aug 25, 2015 at 9:22 AM, Vincent Olivier <vincent@up4.com> wrote:

> For my own sake and other's I would like to maintain (if nobody is already working on that nor needs any help) a centralized human-readable digest of known issues that would be featured prominently on top of the Btrfs wiki. I would merge the Gotchas page and the various known issues pages (including the various multi-device mount gotchas here and there).

Some way to organize problems by distribution would be needed to be complete.

For example I don't have the discover & mount by label or uuid problem
you mention on Fedora, since forever. I haven't experienced it on
Fedora 19/20 which is approximately what CentOS 7 is based on. To
figure that out means using one or more boot parameters:
systemd.log_level=debug or rd.udev.debug or rd.debug to find out
what's happening.

The one problem case I still have with the latest versions is multiple
device Btrfs volume UUID doesn't exist when 1 or more devices are
missing.


-- 
Chris Murphy
