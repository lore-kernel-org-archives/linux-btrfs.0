Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:35743 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754517AbdLTEpj (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 19 Dec 2017 23:45:39 -0500
Subject: Re: [PATCH RESEND 1/2] btrfs: handle volume split brain scenario
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>, linux-btrfs@vger.kernel.org
References: <20171217135247.1838-1-anand.jain@oracle.com>
 <c010dd5d-734a-6aad-e693-93041224735c@gmail.com>
 <2722fb00-5fed-44b7-7516-272ea052c3cc@oracle.com>
 <bbdcdfd8-0ff4-060c-e1db-4725aed8154f@gmail.com>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <53f056f9-5427-3b3c-5cc7-c1627439fe61@oracle.com>
Date: Wed, 20 Dec 2017 12:46:15 +0800
MIME-Version: 1.0
In-Reply-To: <bbdcdfd8-0ff4-060c-e1db-4725aed8154f@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



> Suppose you have 3 
> devices in a raid1 and one goes missing.  The user can now, in trying to 
> fix this, mount each of the two remaining devices separately (by 
> accident of course), in which case you can still have a split brain 
> situation.

Austin, that's not possible a N disk raid1 can still miss only one 
device. Sorry if I had confused you by the hard to parse commit log.
Which I have fixed it in v2.

Thanks, Anand
