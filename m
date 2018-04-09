Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59959 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751803AbeDIQeT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 9 Apr 2018 12:34:19 -0400
Date: Mon, 9 Apr 2018 18:31:49 +0200
From: David Sterba <dsterba@suse.cz>
To: Damenly Su <damenly.su@gmail.com>
Cc: dsterba@suse.cz, Su Yue <suy.fnst@cn.fujitsu.com>,
        linux-btrfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: let mkfs return nozero value on thin
 provision device
Message-ID: <20180409163148.GX8557@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180403083945.13485-1-suy.fnst@cn.fujitsu.com>
 <20180409132538.GM8557@twin.jikos.cz>
 <CABnRu56L4K599tPQoBp6aK8BUARNJnohm6LDmpV603=sS7TupQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CABnRu56L4K599tPQoBp6aK8BUARNJnohm6LDmpV603=sS7TupQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Apr 09, 2018 at 11:46:32PM +0800, Damenly Su wrote:
> Sorry for the previous reply in HTML format which is not delivered to
> the mail list.
> 
> I mean there is already xfstests generic/405 for the situation.
> Thin provision devices need to call dmsetup to setup.
> I wonder If calling dmsetup in progs tests is acceptable or not.
> If it is, I will do it.

Yes dmsetup is already used eg in test
mkfs-tests/005-long-device-name-for-ssd .
