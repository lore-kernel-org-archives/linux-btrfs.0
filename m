Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from azure.uno.uk.net ([95.172.254.11]:57170 "EHLO azure.uno.uk.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751500AbdLCVAq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 3 Dec 2017 16:00:46 -0500
Received: from ty.sabi.co.uk ([95.172.230.208]:60100)
        by azure.uno.uk.net with esmtpsa (TLSv1.2:DHE-RSA-AES128-SHA:128)
        (Exim 4.89)
        (envelope-from <postmaster@root.t00.sabi.co.uk>)
        id 1eLbNU-0002jd-VX
        for linux-btrfs@vger.kernel.org; Sun, 03 Dec 2017 21:00:45 +0000
Received: from from [127.0.0.1] (helo=tree.ty.sabi.co.uk)
        by ty.sabi.co.UK with esmtps(Cipher TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128)(Exim 4.82 3)
        id 1eLbN3-0002Q9-JL
        for <linux-btrfs@vger.kernel.org>; Sun, 03 Dec 2017 21:00:17 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <23076.26079.459369.955773@tree.ty.sabi.co.uk>
Date: Sun, 3 Dec 2017 21:00:15 +0000
To: Linux fs Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 0/7] retry write on error
In-Reply-To: <20171130202253.GA8197@dhcp-whq-twvpn-1-vpnpool-10-159-155-222.vpn.oracle.com>
References: <20171122003558.28722-1-bo.li.liu@oracle.com>
        <20171128192236.GE3553@twin.jikos.cz>
        <bd35756b-0089-0e20-a70c-b66dd3292208@suse.de>
        <23069.62530.53658.314350@tree.ty.sabi.co.uk>
        <aaa69c5c-164a-5cba-452c-5a53d801c792@oracle.com>
        <20171129164708.GH3553@twin.jikos.cz>
        <20171130202253.GA8197@dhcp-whq-twvpn-1-vpnpool-10-159-155-222.vpn.oracle.com>
From: pg@btrfs.list.sabi.co.UK (Peter Grandi)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> [ ... ] btrfs incorporates disk management which is actually a
> version of md layer, [ ... ]

As far as I know Btrfs has no disk management, and was wisely
designed without any, just like MD: Btrfs volumes and MD sets
can be composed from "block devices", not disks, and block
devices are quite high level abstractions, as they closely mimic
the semantics of a UNIX file, not a physical device.
