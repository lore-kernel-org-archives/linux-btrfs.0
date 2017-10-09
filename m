Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59355 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751257AbdJIQHm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 9 Oct 2017 12:07:42 -0400
Date: Mon, 9 Oct 2017 18:05:56 +0200
From: David Sterba <dsterba@suse.cz>
To: Thomas Meyer <thomas@m3y3r.de>
Cc: clm@fb.com, jbacik@fb.com, dsterba@suse.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] btrfs: Fix bool initialization/comparison
Message-ID: <20171009160556.GG3521@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1507383097081-778026979-0-diffsplit-thomas@m3y3r.de>
 <1507383097083-1296921724-3-diffsplit-thomas@m3y3r.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1507383097083-1296921724-3-diffsplit-thomas@m3y3r.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Oct 07, 2017 at 04:02:21PM +0200, Thomas Meyer wrote:
> Bool initializations should use true and false. Bool tests don't need
> comparisons.
> 
> Signed-off-by: Thomas Meyer <thomas@m3y3r.de>

Reviewed-by: David Sterba <dsterba@suse.com>
