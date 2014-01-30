Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:1377 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752374AbaA3Vwg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 30 Jan 2014 16:52:36 -0500
Message-ID: <52EAC999.7070609@fb.com>
Date: Thu, 30 Jan 2014 16:52:25 -0500
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: Fengguang Wu <fengguang.wu@intel.com>,
        Steven Whitehouse <swhiteho@redhat.com>
CC: Al Viro <viro@zeniv.linux.org.uk>, <linux-fsdevel@vger.kernel.org>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [btrfs/i_size] xfstests generic/299 TFAIL
References: <20140130035440.GB12017@localhost>
In-Reply-To: <20140130035440.GB12017@localhost>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On 01/29/2014 10:54 PM, Fengguang Wu wrote:
> Hi Steven,
>
> We noticed xfstests generic/299 TFAIL on btrfs since
>
> commit 9fe55eea7e4b444bafc42fa0000cc2d1d2847275
> Author:     Steven Whitehouse <swhiteho@redhat.com>
> AuthorDate: Fri Jan 24 14:42:22 2014 +0000
> Commit:     Al Viro <viro@zeniv.linux.org.uk>
> CommitDate: Sun Jan 26 08:26:42 2014 -0500
>
>      Fix race when checking i_size on direct i/o read
>      
Ok this took a bit but it's because truncate() can fail on btrfs and the 
test didn't take this into account.  I'll send a patch for the test.  
Thanks,

Josef
