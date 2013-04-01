Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:44983 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756976Ab3DAXAo (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 1 Apr 2013 19:00:44 -0400
Message-ID: <515A1195.3010500@oracle.com>
Date: Tue, 02 Apr 2013 07:00:37 +0800
From: anand jain <anand.jain@oracle.com>
MIME-Version: 1.0
To: Roman Mamedov <rm@romanrm.ru>
CC: linux-btrfs@vger.kernel.org
Subject: Re: BTRFS error in __btrfs_inc_extent_ref:1935: Object already exists
References: <20130401041540.4b8a4ab3@natsu> <20130401043605.2eb250a7@natsu> <20130401141207.533886a2@natsu>
In-Reply-To: <20130401141207.533886a2@natsu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


> I tried btrfsck --repair,

  I am not indicating this is the cause but, kindly note that
  btrfsck --repair has a bug which it will let kernel to reset
  the uuid of the root.

  the fix is at:

[PATCH] btrfs-progs: root_item generation_v2 is out of sync after btrfsck

Thanks, Anand
