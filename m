Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45217 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753109AbeC1OvS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 28 Mar 2018 10:51:18 -0400
Date: Wed, 28 Mar 2018 16:48:50 +0200
From: David Sterba <dsterba@suse.cz>
To: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>, dsterba@suse.com
Subject: Re: error report: misc-test 006 sometimes fails in current devel
 branch
Message-ID: <20180328144850.GJ30422@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cfacefc4-3bd0-8e27-3c51-d681502da6ae@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <cfacefc4-3bd0-8e27-3c51-d681502da6ae@jp.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Mar 28, 2018 at 10:55:56AM +0900, Misono Tomohiro wrote:
> current devel branch of btrfs-progs (github) occasionally fails at misc-test 006:
> (kernel is 4.16.0-rc7)

That's strange, the test should be deterministic. There seems to be some
timing involved. I'm able to reproduce here, thanks for the report.
