Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f48.google.com ([209.85.213.48]:34517 "EHLO
	mail-vk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753611AbbHLRDB (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 12 Aug 2015 13:03:01 -0400
Received: by vkhl6 with SMTP id l6so8285315vkh.1
        for <linux-btrfs@vger.kernel.org>; Wed, 12 Aug 2015 10:03:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20150812130758.GA26529@rus.uni-stuttgart.de>
References: <20150812130758.GA26529@rus.uni-stuttgart.de>
Date: Wed, 12 Aug 2015 11:03:00 -0600
Message-ID: <CAJCQCtRTvn-Xu_ipM7pCTtVuxUm0m7kjqt=F=+q6cj0vOOhF7g@mail.gmail.com>
Subject: Re: RAID0 wrong (raw) device?
From: Chris Murphy <lists@colorremedies.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Aug 12, 2015 at 7:07 AM, Ulli Horlacher
<framstag@rus.uni-stuttgart.de> wrote:

> /dev/sdb and /dev/sde are in reality the same physical disk!

When does all of this confusion happen? Is it already confused before
mkfs or only after mkfs or only after mount? I would find out what
instigates it, wipe all signatures from everything, reboot, start from
scratch, and then strace the command that causes the confusion. And
attach that output as well as the entire dmesg to a bug report. Just
my 2 cents, I have no idea what's going on but sounds like a block
layer and/or drdb bug that's triggered by Btrfs multiple device
setups.

-- 
Chris Murphy
