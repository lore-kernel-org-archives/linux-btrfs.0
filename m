Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:18183 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751161AbaDIJNV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 9 Apr 2014 05:13:21 -0400
Message-ID: <53450F17.1030905@oracle.com>
Date: Wed, 09 Apr 2014 17:12:55 +0800
From: Anand Jain <anand.jain@oracle.com>
MIME-Version: 1.0
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2] btrfs-progs: Add missing devices check for mounted
 btrfs.
References: <1391755560-4721-1-git-send-email-quwenruo@cn.fujitsu.com> <52F4A8B6.5070009@oracle.com> <52F81EF6.4080901@cn.fujitsu.com> <5344B8A8.1080507@oracle.com> <5344BDFF.70101@cn.fujitsu.com> <5344CDAE.6090900@oracle.com> <5344EEE4.8060401@cn.fujitsu.com>
In-Reply-To: <5344EEE4.8060401@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


> As mentioned at the beginning, I prefer to remove the device remove test
> in testcase, then the patch can be reverted without any complain from me.

  Thats a wrong approach as well.
  The test case 003 is a very real case at the data centers.
  Especially the iscsi/san luns go offline/online all the time.


