Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:22537 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1948502AbcBSJPW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 19 Feb 2016 04:15:22 -0500
Subject: Re: [PATCH 13/13] btrfs: optimize check for stale device
To: dsterba@suse.cz
References: <1455328900-1476-1-git-send-email-anand.jain@oracle.com>
 <1455328900-1476-14-git-send-email-anand.jain@oracle.com>
 <20160218151348.GY4374@twin.jikos.cz> <56C6BFD8.30801@oracle.com>
Cc: linux-btrfs@vger.kernel.org
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <56C6DD20.3090907@oracle.com>
Date: Fri, 19 Feb 2016 17:15:12 +0800
MIME-Version: 1.0
In-Reply-To: <56C6BFD8.30801@oracle.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Dave,

>> I see crashes with btrfs/011 on a non-debugging config

  Could you share your xfstests config file ? especially the
  devices config part.

Thanks, Anand
