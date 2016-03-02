Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:18042 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750858AbcCBHHJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 2 Mar 2016 02:07:09 -0500
Subject: Re: [RFC] Experimental btrfs encryption
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>, linux-btrfs@vger.kernel.org
References: <1456848492-4814-1-git-send-email-anand.jain@oracle.com>
 <56D5C64F.3000800@gmail.com>
Cc: clm@fb.com, dsterba@suse.cz
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <56D69114.5020002@oracle.com>
Date: Wed, 2 Mar 2016 15:07:00 +0800
MIME-Version: 1.0
In-Reply-To: <56D5C64F.3000800@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Thanks Austin for commenting.

  Yes to most of it. And probably I should have titled known-issues
  to known-bugs, which I meant to fix before final integration.


In general:
Its good to explore options of both compression+encryption OR an
algorithm engine which can automatically do both because whether
data centers will look for it or not is a balance trade off between

      CPU load VS Storage space saved VS Network bandwidth needed

  Yes, network as well because of the remote replication and remote
  backup data center use cases.

  So its good to keep that option open.

Thanks, Anand

