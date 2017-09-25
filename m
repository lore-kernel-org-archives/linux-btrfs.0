Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52715 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932698AbdIYOGn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 25 Sep 2017 10:06:43 -0400
Date: Mon, 25 Sep 2017 16:05:09 +0200
From: David Sterba <dsterba@suse.cz>
To: Josef Bacik <josef@toxicpanda.com>
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        Josef Bacik <jbacik@fb.com>
Subject: Re: [PATCH][v2] Btrfs: rework outstanding_extents
Message-ID: <20170925140509.GF31640@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1503323194-20812-1-git-send-email-jbacik@fb.com>
 <20170821141119.GB16884@destiny>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170821141119.GB16884@destiny>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Aug 21, 2017 at 10:11:20AM -0400, Josef Bacik wrote:
> Ignore this, I git format-patch'ed the wrong patch.

So if you're going to send another version, please split the tracepoints
to another patch and update the format strings to the preferred format

https://btrfs.wiki.kernel.org/index.php/Development_notes#Tracepoints
