Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:34953 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S933192AbcLSQrl (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 19 Dec 2016 11:47:41 -0500
Date: Mon, 19 Dec 2016 11:46:23 -0500
From: Josef Bacik <jbacik@fb.com>
Subject: Re: [PATCH] btrfs: use rb_entry()
To: Geliang Tang <geliangtang@gmail.com>
CC: Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>,
        <linux-btrfs@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Message-ID: <1482165983.6766.0@smtp.office365.com>
In-Reply-To: <e7f25691fb620d01df75e3526897c7fb0e0ef6f8.1482158996.git.geliangtang@gmail.
        com>
References: <e7f25691fb620d01df75e3526897c7fb0e0ef6f8.1482158996.git.geliangtang@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Dec 19, 2016 at 9:53 AM, Geliang Tang <geliangtang@gmail.com> 
wrote:
> To make the code clearer, use rb_entry() instead of container_of() to
> deal with rbtree.
> 
> Signed-off-by: Geliang Tang <geliangtang@gmail.com>

Reviewed-by: Josef Bacik <jbacik@fb.com>

Thanks,

Josef

