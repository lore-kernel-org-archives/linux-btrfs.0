Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:48854 "EHLO
        mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752908AbdICOmv (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 3 Sep 2017 10:42:51 -0400
Date: Sun, 3 Sep 2017 07:42:37 -0700
From: Marc MERLIN <marc@merlins.org>
To: Josef Bacik <jbacik@fb.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Chris Murphy <lists@colorremedies.com>, Chris Mason <clm@fb.com>,
        "bo.li.liu@oracle.com" <bo.li.liu@oracle.com>,
        "fdmanana@suse.com" <fdmanana@suse.com>,
        David Sterba <dsterba@suse.cz>
Message-ID: <20170903144237.svgnaclwmcfdfikt@merlins.org>
References: <20170901204329.GH30689@merlins.org>
 <11510543-DAC5-400B-8204-C1FCC12CF335@fb.com>
 <20170902160942.imo2hotpur3pnops@merlins.org>
 <B8F93BCF-0976-4450-A58E-13F6A3C48573@fb.com>
 <20170902235344.sb55vzaloglmqaad@merlins.org>
 <73427BC6-B85B-422C-BCA0-778C7BA203A8@fb.com>
 <20170903010127.eafg2i7ry2tprro7@merlins.org>
 <5D0BC86A-D427-4529-A40E-492A98BA5D16@fb.com>
 <20170903143142.7thdjvkmkdekrzc5@merlins.org>
 <1E7DEC47-01A8-4F50-B266-FA4949090687@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1E7DEC47-01A8-4F50-B266-FA4949090687@fb.com>
Subject: Re: BTRFS: error (device dm-2) in btrfs_run_delayed_refs:2960:
 errno=-17 Object already exists (since 3.4 / 2012)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Sep 03, 2017 at 02:38:57PM +0000, Josef Bacik wrote:
> Oh yeah you need CONFIG_STACKTRACE turned on, otherwise this is going to be difficult ;).  Thanks,
 
Right, except that I thought I did:

saruman:/usr/src/linux-btrfs/btrfs-next# grep STACKTRACE .config
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_HAVE_RELIABLE_STACKTRACE=y
CONFIG_STACKTRACE=y
CONFIG_USER_STACKTRACE_SUPPORT=y

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
