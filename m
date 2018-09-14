Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from len.romanrm.net ([91.121.75.85]:53640 "EHLO len.romanrm.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728034AbeINXKr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 14 Sep 2018 19:10:47 -0400
Date: Fri, 14 Sep 2018 22:46:12 +0500
From: Roman Mamedov <rm@romanrm.net>
To: Rafael =?UTF-8?B?SmVzw7pzIEFsY8OhbnRhcmEgUMOpcmV6?=
        <ralcantara@idedalo.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Problem with BTRFS
Message-ID: <20180914224612.07a5db1b@natsu>
In-Reply-To: <c7040285-599d-4f6c-cf16-50dc77c9b5f1@idedalo.com>
References: <c7040285-599d-4f6c-cf16-50dc77c9b5f1@idedalo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 14 Sep 2018 19:27:04 +0200
Rafael Jesús Alcántara Pérez         <ralcantara@idedalo.com> wrote:

> BTRFS info (device sdc1): use lzo compression, level 0
> BTRFS warning (device sdc1): 'recovery' is deprecated, use
> 'usebackuproot' instead
> BTRFS info (device sdc1): trying to use backup root at mount time
> BTRFS info (device sdc1): disk space caching is enabled
> BTRFS info (device sdc1): has skinny extents
> BTRFS error (device sdc1): super_total_bytes 6010266660864 mismatch with
> fs_devices total_rw_bytes 6010266663424

There is a recent feature added to "btrfs rescue" to fix this kind of
condition: https://patchwork.kernel.org/patch/10011399/

You need a recent version of the Btrfs tools for it, not sure which, I see
that it's not in version 4.13 but is present in 4.17.

-- 
With respect,
Roman
