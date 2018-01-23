Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50071 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751565AbeAWOcC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 23 Jan 2018 09:32:02 -0500
Date: Tue, 23 Jan 2018 15:29:50 +0100
From: David Sterba <dsterba@suse.cz>
To: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 00/67] btrfs-progs: add the stack prefix for the set/get
Message-ID: <20180123142949.GJ15713@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180111050939.21251-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180111050939.21251-1-lufq.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jan 11, 2018 at 01:08:32PM +0800, Lu Fengqi wrote:
> These set/get functions defined by BTRFS_SETGET_STACK_FUNCS macro is
> missing the prefix stack. I can't add an extent buffer version set/get
> function as the result of the function name conflict.

Why do you need to add the extent buffer set/get helpers?

The function names will become quite long after adding the _stack
string, so I'd rather be sure we really need it before changing the
names everywhere.
