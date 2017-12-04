Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:33358 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753550AbdLDJOQ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Dec 2017 04:14:16 -0500
Subject: Re: [PATCH 0/7] retry write on error
To: bo.li.liu@oracle.com
References: <20171122003558.28722-1-bo.li.liu@oracle.com>
 <20171128192236.GE3553@twin.jikos.cz>
 <bd35756b-0089-0e20-a70c-b66dd3292208@suse.de>
 <23069.62530.53658.314350@tree.ty.sabi.co.uk>
 <aaa69c5c-164a-5cba-452c-5a53d801c792@oracle.com>
 <20171129164708.GH3553@twin.jikos.cz>
 <20171130202253.GA8197@dhcp-whq-twvpn-1-vpnpool-10-159-155-222.vpn.oracle.com>
Cc: dsterba@suse.cz, Peter Grandi <pg@btrfs.list.sabi.co.UK>,
        Linux fs Btrfs <linux-btrfs@vger.kernel.org>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <52cde20f-8221-65c2-4942-9d3e6cd1f6d2@oracle.com>
Date: Mon, 4 Dec 2017 17:14:37 +0800
MIME-Version: 1.0
In-Reply-To: <20171130202253.GA8197@dhcp-whq-twvpn-1-vpnpool-10-159-155-222.vpn.oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>




>>>>>>> If the underlying protocal doesn't support retry
>>>>>>> and there
>>>>>>> are some transient errors happening somewhere in our IO
>>>>>>> stack, we'd like to give an extra chance for IO.


> It's true that scsi's sd layer has done SD_MAX_RETRIES(5) retries, but
> can we really depend on other layers for all robustness?


  You are contradicting on your own problem statement as above.


Thanks, Anand



