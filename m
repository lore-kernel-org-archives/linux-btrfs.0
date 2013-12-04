Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:51121 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755229Ab3LDKZs (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 4 Dec 2013 05:25:48 -0500
Received: from /spool/local
	by e28smtp09.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Wed, 4 Dec 2013 15:55:46 +0530
Received: from d28relay04.in.ibm.com (d28relay04.in.ibm.com [9.184.220.61])
	by d28dlp01.in.ibm.com (Postfix) with ESMTP id 440F9E004A
	for <linux-btrfs@vger.kernel.org>; Wed,  4 Dec 2013 15:57:55 +0530 (IST)
Received: from d28av01.in.ibm.com (d28av01.in.ibm.com [9.184.220.63])
	by d28relay04.in.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id rB4APaZK57737402
	for <linux-btrfs@vger.kernel.org>; Wed, 4 Dec 2013 15:55:37 +0530
Received: from d28av01.in.ibm.com (localhost [127.0.0.1])
	by d28av01.in.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id rB4APeEf029300
	for <linux-btrfs@vger.kernel.org>; Wed, 4 Dec 2013 15:55:40 +0530
From: chandan <chandan@linux.vnet.ibm.com>
To: dsterba@suse.cz
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [RFC PATCH] Btrfs: Add linear chunk allocation support.
Date: Wed, 04 Dec 2013 15:55:39 +0630
Message-ID: <1724490.Of3xKU2eYm@localhost.localdomain>
In-Reply-To: <20131204000644.GX25312@twin.jikos.cz>
References: <1674620.BNzKaL6CNE@localhost.localdomain> <20131204000644.GX25312@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thanks for the review comments David. I will come up with another patch
that implements your suggestion.

