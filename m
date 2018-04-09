Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44928 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752688AbeDINdH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 9 Apr 2018 09:33:07 -0400
Date: Mon, 9 Apr 2018 15:30:36 +0200
From: David Sterba <dsterba@suse.cz>
To: Gu Jinxiang <gujx@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: remove unused function path_cat and
 path_cat3
Message-ID: <20180409133036.GN8557@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1523252610-4843-1-git-send-email-gujx@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1523252610-4843-1-git-send-email-gujx@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Apr 09, 2018 at 01:43:30PM +0800, Gu Jinxiang wrote:
> Since function path_cat and path_cat3 are not used anymore, remove them.

It's good to document when the functions where deprecated, 4.0, which
lets us check that the period was long enough for any users to adapt as
it's in the public interface.

Anyway, 16 releases should be enough. Applied.
