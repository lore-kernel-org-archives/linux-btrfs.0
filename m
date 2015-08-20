Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:22286 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751944AbbHTDC0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 19 Aug 2015 23:02:26 -0400
Message-ID: <55D542A2.2020309@oracle.com>
Date: Thu, 20 Aug 2015 10:59:46 +0800
From: Anand Jain <anand.jain@oracle.com>
MIME-Version: 1.0
To: Daniel Pocock <daniel@pocock.pro>
CC: linux-btrfs@vger.kernel.org, clm@fb.com, dsterba@suse.cz
Subject: Re: disk failure but no alert
References: <55D44409.40100@pocock.pro>
In-Reply-To: <55D44409.40100@pocock.pro>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



> is BtrFs failing to alert?

  Yes. Btrfs does not do that. as of now.

  Only action that it takes is to put FS into readonly mode. That may
  be fine for ext4 kind of FS but its not correct from the btrfs Volume
  Manager perspective.

  A work in progress at my end to fix that.

 > [996932.735110] end_request: critical target error, dev sdd, sector 
526344
 > [996932.735280] md: super_written gets error=-121, uptodate=0
 > [996932.735290] md/raid1:md2: Disk failure on sdd2, disabling device.
 > md/raid1:md2: Operation continuing on 1 devices.

  MD is a complete volume manager, Btrfs isn't yet.

  My recent patch (below), is a step towards that. Its not yet
  integrated.

   [PATCH 3/3] Btrfs: introduce function to handle device offline


HTH, Anand
