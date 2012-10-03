Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e7.ny.us.ibm.com ([32.97.182.137]:45808 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751322Ab2JCBAe (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 2 Oct 2012 21:00:34 -0400
Received: from /spool/local
	by e7.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <clinew@linux.vnet.ibm.com>;
	Tue, 2 Oct 2012 21:00:33 -0400
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay03.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id q9310Uad126844
	for <linux-btrfs@vger.kernel.org>; Tue, 2 Oct 2012 21:00:30 -0400
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id q9310UT7015600
	for <linux-btrfs@vger.kernel.org>; Tue, 2 Oct 2012 21:00:30 -0400
Message-ID: <506B8E2C.7070107@linux.vnet.ibm.com>
Date: Tue, 02 Oct 2012 18:00:28 -0700
From: Wade Cline <clinew@linux.vnet.ibm.com>
MIME-Version: 1.0
To: Josef Bacik <jbacik@fusionio.com>
CC: linux-btrfs@vger.kernel.org,
        "cmm@linux.vnet.ibm.com" <cmm@linux.vnet.ibm.com>
Subject: Re: [RFC] [PATCH] Btrfs: rework can_nocow_odirect
References: <1349118014-6319-1-git-send-email-jbacik@fusionio.com>
In-Reply-To: <1349118014-6319-1-git-send-email-jbacik@fusionio.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Josef,

This patch is causing fragmentation with O_DIRECT on preallocated extents located
-after- the first write to the preallocated extent. This happens regardless of
nodatacow/autodefrag mount options.

Thank you,
Wade

On 10/01/2012 12:00 PM, Josef Bacik wrote:

> I need everybody to go over this with a fine toothed comb since it is a pretty
> big change.  I think it is right and it seems to come out right, but if it's not
> it will mean we screw up O_DIRECT on snapshotted files with preallocated
> extents, so please, make sure it is correct :).

