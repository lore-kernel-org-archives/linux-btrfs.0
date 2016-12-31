Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from len.romanrm.net ([195.154.117.182]:51708 "EHLO len.romanrm.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752580AbcLaIIu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 31 Dec 2016 03:08:50 -0500
Date: Sat, 31 Dec 2016 13:08:40 +0500
From: Roman Mamedov <rm@romanrm.net>
To: Rich Gannon <rich@richgannon.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Can't add/replace a device on degraded filesystem
Message-ID: <20161231130840.45e7230f@natsu>
In-Reply-To: <86f5b7b9-b54e-8b80-26a9-6f13f3609a7b@richgannon.net>
References: <86f5b7b9-b54e-8b80-26a9-6f13f3609a7b@richgannon.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 29 Dec 2016 19:27:30 -0500
Rich Gannon <rich@richgannon.net> wrote:

> I can mount my filesystem with -o degraded, but I can not do btrfs 
> replace or btrfs device add as the filesystem is in read-only mode, and 
> I can not mount read-write.

You can try my patch which removes that limitation 
https://patchwork.kernel.org/patch/9419189/

Also as Duncan said there's a "more proper" patch to fix this in the works
somewhere, which does a per-chunk check for degraded, and would also allow to
mount the FS read-write in your case.

-- 
With respect,
Roman
