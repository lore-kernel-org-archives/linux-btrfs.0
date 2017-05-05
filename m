Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52876 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751096AbdEESWz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 5 May 2017 14:22:55 -0400
Date: Fri, 5 May 2017 20:22:47 +0200
From: David Sterba <dsterba@suse.cz>
To: Sargun Dhillon <sargun@sargun.me>
Cc: Adam Borowski <kilobyte@angband.pl>,
        BTRFS ML <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs: allow processes with cap_sys_resource to exceed
 quota
Message-ID: <20170505182247.GL10575@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170421100943.GA2942@ircssh-2.c.rugged-nimbus-611.internal>
 <20170421110558.lx56fsrbengxqwuy@angband.pl>
 <CAMp4zn_XkDpmcG4szqv95mAeVeikkTUJWH1vAObduLu7fozL4w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAMp4zn_XkDpmcG4szqv95mAeVeikkTUJWH1vAObduLu7fozL4w@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Apr 21, 2017 at 07:27:23AM -0500, Sargun Dhillon wrote:
> What do you think about putting this behaviour behind a sysctl? Seems
> better than to start introducing a new mechanism of marking tasks?

Technically it's easy to add own btrfs-specific ioctl, temporarily
turning off quota limits, but I'm still not sure about all the
consequences as this would apply to the whole system, no? The
capabilities are per process, much more fine grained. I don't have other
ideas how to address the problem though.
