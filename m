Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:35169 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751335Ab3LLJzT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 12 Dec 2013 04:55:19 -0500
Message-ID: <52A987FD.9000208@oracle.com>
Date: Thu, 12 Dec 2013 17:55:09 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: Josef Bacik <jbacik@fb.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: Updated btrfs-next
References: <52A8B9BF.9030707@fb.com>
In-Reply-To: <52A8B9BF.9030707@fb.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Josef,

 > I just updated and pushed btrfs-next, if it is missing something let me
 > know.

  below two patches are missing, should it be re-based? let me know.

----
[PATCH v2] btrfs: add framework to read fs info from btrfs-control
   btrfs-progs side of the patch is:
   [PATCH v4 1/3] btrfs-progs: mechanism to fetch fsinfo from btrfs-control

[PATCH v2] btrfs: scrub maintenance event should be recorded in the messages
----

Thanks, Anand
