Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54229 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751455AbeBXAas (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 23 Feb 2018 19:30:48 -0500
Date: Sat, 24 Feb 2018 01:28:29 +0100
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/2] btrfs: drop optimal argument from find_live_mirror()
Message-ID: <20180224002829.GW1469@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180130062831.14644-1-anand.jain@oracle.com>
 <20180130062831.14644-3-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180130062831.14644-3-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jan 30, 2018 at 02:28:31PM +0800, Anand Jain wrote:
> Drop optimal argument from the function find_live_mirror()
> as we can deduce it in the function itself.

Yeah the argument is not necessary. It's another misleading variable
name, as it's not 'optimal' but a fallback. Please rename it.
