Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:41612 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751127AbeA2JFA (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 29 Jan 2018 04:05:00 -0500
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.22/8.16.0.22) with SMTP id w0T94lY6057151
        for <linux-btrfs@vger.kernel.org>; Mon, 29 Jan 2018 04:05:00 -0500
Received: from e06smtp13.uk.ibm.com (e06smtp13.uk.ibm.com [195.75.94.109])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2fsyp9tp5y-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-btrfs@vger.kernel.org>; Mon, 29 Jan 2018 04:04:59 -0500
Received: from localhost
        by e06smtp13.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
        Mon, 29 Jan 2018 09:04:55 -0000
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: Josef Bacik <josef@toxicpanda.com>
Cc: Jan Kara <jack@suse.cz>, Dave Chinner <david@fromorbit.com>,
        hannes@cmpxchg.org, linux-mm@kvack.org, akpm@linux-foundation.org,
        linux-fsdevel@vger.kernel.org, kernel-team@fb.com,
        linux-btrfs@vger.kernel.org, Josef Bacik <jbacik@fb.com>
Subject: Re: [PATCH v3 06/10] writeback: introduce super_operations->write_metadata
Date: Mon, 29 Jan 2018 14:36:15 +0530
In-Reply-To: <20180103162922.rxs2jpvmpxa62usa@destiny>
References: <20171212180534.c5f7luqz5oyfe7c3@destiny> <20180103162603.GO4911@quack2.suse.cz> <20180103162922.rxs2jpvmpxa62usa@destiny>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-Id: <2857272.fAFXmvyrml@dhcp-9-109-247-21>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wednesday, January 3, 2018 9:59:24 PM IST Josef Bacik wrote:
> On Wed, Jan 03, 2018 at 05:26:03PM +0100, Jan Kara wrote:

> 
> Oh ok well if that's the case then I'll fix this up to be a ratio, test
> everything, and send it along probably early next week.  Thanks,
> 

Hi Josef,

Did you get a chance to work on the next version of this patchset?


-- 
chandan

