Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43799 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752898AbdLDUtj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 4 Dec 2017 15:49:39 -0500
Subject: Re: [PATCH 0/7] retry write on error
To: bo.li.liu@oracle.com, dsterba@suse.cz, Anand Jain <anand.jain@oracle.com>,
        Peter Grandi <pg@btrfs.list.sabi.co.UK>,
        Linux fs Btrfs <linux-btrfs@vger.kernel.org>
References: <20171122003558.28722-1-bo.li.liu@oracle.com>
 <20171128192236.GE3553@twin.jikos.cz>
 <bd35756b-0089-0e20-a70c-b66dd3292208@suse.de>
 <23069.62530.53658.314350@tree.ty.sabi.co.uk>
 <aaa69c5c-164a-5cba-452c-5a53d801c792@oracle.com>
 <20171129164708.GH3553@twin.jikos.cz>
 <20171130202253.GA8197@dhcp-whq-twvpn-1-vpnpool-10-159-155-222.vpn.oracle.com>
From: Edmund Nadolski <enadolski@suse.de>
Message-ID: <89ffe153-7f1a-8d14-7a68-d95fcf9a8e25@suse.de>
Date: Mon, 4 Dec 2017 13:49:28 -0700
MIME-Version: 1.0
In-Reply-To: <20171130202253.GA8197@dhcp-whq-twvpn-1-vpnpool-10-159-155-222.vpn.oracle.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 11/30/2017 01:22 PM, Liu Bo wrote:
>>>>>>> If the underlying protocal doesn't support retry and there
>>>>>>> are some transient errors happening somewhere in our IO
>>>>>>> stack, we'd like to give an extra chance for IO.

> Anyway, this is for a corner case, not for everyone, I think I need to
> make it configurable so that at least we can provide some extra
> robustness for people who super care about their data.

Not sure I follow -- wouldn't such users prefer a transport like e.g.
scsi that *does* perform retries (as well as other error recovery)?

(Possibly they would also want features like mirroring & multipath, but
in those scenarios doing additional retries from the filesystem is also
unlikely to help much.)

Ed

