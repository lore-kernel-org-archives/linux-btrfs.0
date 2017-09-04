Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43443 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752687AbdIDQtX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 4 Sep 2017 12:49:23 -0400
Date: Mon, 4 Sep 2017 18:47:55 +0200
From: David Sterba <dsterba@suse.cz>
To: Gu Jinxiang <gujx@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: Make the process of create root tree to a
 function
Message-ID: <20170904164755.GD31874@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1503645816-3450-1-git-send-email-gujx@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1503645816-3450-1-git-send-email-gujx@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 25, 2017 at 03:23:36PM +0800, Gu Jinxiang wrote:
> make_btrfs is too long to understand, make creatation of root tree
> in a function.

Good cleanup, but the changelog could be improved. There are some
changes not obvious from the changes, like that you now iterate some of
the roots and use the reference_root_table for translation. This makes
it a bit harder to review the patch as the code is not just moved to a
function but also improved on the way. Sometimes it's better to do it in
two steps, but not absolutely necessary in this case.

Nevertheless, patch applied, with the updated changelog.
