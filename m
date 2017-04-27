Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f44.google.com ([74.125.82.44]:37977 "EHLO
        mail-wm0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754562AbdD0O6M (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 27 Apr 2017 10:58:12 -0400
Received: by mail-wm0-f44.google.com with SMTP id r190so21255782wme.1
        for <linux-btrfs@vger.kernel.org>; Thu, 27 Apr 2017 07:58:12 -0700 (PDT)
Received: from [192.168.77.22] (val06-1-88-182-161-34.fbx.proxad.net. [88.182.161.34])
        by smtp.gmail.com with ESMTPSA id 72sm9496911wmx.23.2017.04.27.07.58.08
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 27 Apr 2017 07:58:09 -0700 (PDT)
From: Christophe de Dinechin <dinechin@redhat.com>
Content-Type: text/plain; charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Subject: Re: File system corruption, btrfsck abort
Date: Thu, 27 Apr 2017 16:58:07 +0200
References: <D64BF81E-58B3-4B19-AD65-F5056768466C@redhat.com>
To: linux-btrfs@vger.kernel.org
In-Reply-To: <D64BF81E-58B3-4B19-AD65-F5056768466C@redhat.com>
Message-Id: <0A381C78-EC2E-42A8-92D6-E9465F0F86FE@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> On 25 Apr 2017, at 19:50, Christophe de Dinechin <dinechin@redhat.com> wrote:

> The cause of the abort is that we call set_extent_dirty from check_extent_refs with rec->max_size == 0. I’ve instrumented to try to see where we set this to 0 (see https://github.com/c3d/btrfs-progs/tree/rhbz1435567), and indeed, we do sometimes see max_size set to 0 in a few locations. My instrumentation shows this:
> 
> 78655 [1.792241:0x451fe0] MAX_SIZE_ZERO: Add extent rec 0x139eb80 max_size 16384 tmpl 0x7fffffffd120
> 78657 [1.792242:0x451cb8] MAX_SIZE_ZERO: Set max size 0 for rec 0x139ec50 from tmpl 0x7fffffffcf80
> 78660 [1.792244:0x451fe0] MAX_SIZE_ZERO: Add extent rec 0x139ed50 max_size 16384 tmpl 0x7fffffffd120
> 
> I don’t really know what to make of it.

I dig a bit deeper. We set rec->max_size = 0 in add_extent_rec_nolookup called from add_tree_backref, where we cleared the extent_record tmpl with a memset, so indeed, max_size is 0. However, we immediately after that do a lookup_cache_extent with a size of 1. So I wonder if at that stage, we should not set max_size to 1 for the newly created extent record.

Opinions?

Christophe

