Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33054 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1168354AbcKAKIy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 1 Nov 2016 06:08:54 -0400
Date: Tue, 1 Nov 2016 11:08:51 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v3 1/4] btrfs-progs: utils: Introduce function to escape
 characters
Message-ID: <20161101100851.GV12522@suse.cz>
Reply-To: dsterba@suse.cz
References: <20161101080147.13163-1-quwenruo@cn.fujitsu.com>
 <20161101080147.13163-2-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20161101080147.13163-2-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Nov 01, 2016 at 04:01:43PM +0800, Qu Wenruo wrote:
> Introduce new function, escape_string_inplace(), to escape specified
> characters in place.

Sorry, the pointer to seq_path was misleading. The actual escape
function is mangle_path and it copies one string to another. As we just
print the path, we can simply switch and call putchar.
