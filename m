Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from kolab.zavadatar.com ([46.101.124.0]:57147 "EHLO
	kolab.zavadatar.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751760AbcDERxm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 5 Apr 2016 13:53:42 -0400
Received: by mail-vk0-f43.google.com with SMTP id e6so27683561vkh.2
        for <linux-btrfs@vger.kernel.org>; Tue, 05 Apr 2016 10:53:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160330184327.GO29474@carfax.org.uk>
References: <loom.20160330T155403-473@post.gmane.org>
	<20160330184327.GO29474@carfax.org.uk>
Date: Tue, 5 Apr 2016 10:53:37 -0700
Message-ID: <CAKWEGV5tsEJHmb_Y0aQD0fsc4v3Un4rWBzS5QUUGhFz2HyTGKg@mail.gmail.com>
Subject: Re: good documentation on btrfs internals and on disk layout
From: Yauhen Kharuzhy <yauhen.kharuzhy@zavadatar.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I try to understand btrfs logic in mounting of multi-device filesystem
when device generations are different. All my questions are related to
RAID5/6 for system, metadata, and data case.

Kernel can mount FS with different device generations (if drive was
physically removed before last unmount and returned back after, for
example) now but scrub will report uncorrectable errors after this
(but second run doesn't show any errors). Does any documentation about
algorithm of multiple device handling in such case exist? Does the
case with different device generations is allowed in general and what
worst cases can be here?

What should happen if device was removed and returned back after some
time when filesystem is online? Should some kind of device
reopening be possible or one possible way to guarantee FS consistensy
is  to mark such device as missing and to replace it?

If any sources of such information exist (except btrfs code) please
point me to them.
