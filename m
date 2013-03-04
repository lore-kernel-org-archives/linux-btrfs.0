Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:41320 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751805Ab3CDFUP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Mar 2013 00:20:15 -0500
Message-ID: <51342F02.3020504@oracle.com>
Date: Mon, 04 Mar 2013 13:20:02 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: Eric Sandeen <sandeen@redhat.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: traverse to backup super-block only when
 indicated
References: <5127022B.6070200@oracle.com> <1362132800-29563-1-git-send-email-anand.jain@oracle.com> <5130E745.9010306@redhat.com>
In-Reply-To: <5130E745.9010306@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



> flags = BTRFS_SCAN_REGISTER | BTRFS_SCAN_PRIMARY_SB;
> btrfs_scan_one_dir("/dev/", flags)

  I just got too flexed into the current way of coding
  in btrfs-progs :-)

  But let me get at least this part of the code
  in the right-way.

  Thanks Eric for pointing out.

-Anand
