Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:32977 "EHLO
	mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753864AbcESIhH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 19 May 2016 04:37:07 -0400
Received: by mail-oi0-f66.google.com with SMTP id t140so14884621oie.0
        for <linux-btrfs@vger.kernel.org>; Thu, 19 May 2016 01:37:07 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 19 May 2016 10:20:13 +0200
Message-ID: <CAJfpeguD-S=CEogqcDOYAYJBzfyJG=MMKyFfpMo55bQk7d0_TQ@mail.gmail.com>
Subject: sharing page cache pages between multiple mappings
From: Miklos Szeredi <miklos@szeredi.hu>
To: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Has anyone thought about sharing pages between multiple files?

The obvious application is for COW filesytems where there are
logically distinct files that physically share data and could easily
share the cache as well if there was infrastructure for it.

Thanks,
Miklos
