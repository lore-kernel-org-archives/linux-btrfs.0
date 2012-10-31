Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:41194 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933519Ab2JaVRH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 31 Oct 2012 17:17:07 -0400
Received: by mail-pa0-f46.google.com with SMTP id hz1so1241053pad.19
        for <linux-btrfs@vger.kernel.org>; Wed, 31 Oct 2012 14:17:06 -0700 (PDT)
Message-ID: <50919550.3090800@gmail.com>
Date: Thu, 01 Nov 2012 05:17:04 +0800
From: ching <lsching17@gmail.com>
MIME-Version: 1.0
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs defrag problem
References: <508FBE50.6070300@gmail.com> <20121031004027.GE3102@twin.jikos.cz>
In-Reply-To: <20121031004027.GE3102@twin.jikos.cz>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


>>     It seems that locked files cannot be defragged, is it expected behaviour?
> Yes.

but i am defragging a file, not modify it.

>> 2. Btrfs Wiki mentions that defrag directory will defrag metadata, is symlink/hardlink considered as metadata?
>>     P.S. inline data is already disabled by "max_inline=0"
> Both -links are metadata and also stored inside metadata blocks without
> any chance to move to data blocks, so max_inline does not affect this.

thank you for your explanation.

>> 3. Is any possible to online defrag a btrfs partition without hindered by mount point/polyinstantied directories?
> Sorry, I do not understand the question.
>

when a device is mounted under a directory, files in the directory is "hidden", and files in the device is "available", right?
when a directory is polyinstantied, files in the original directory is "hidden", and files in the polyinstantied directory is "available",

How to get past them and pass those "hidden" files to defrag command?


ching

