Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:45229 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750983AbaLWOo1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 23 Dec 2014 09:44:27 -0500
Date: Tue, 23 Dec 2014 09:44:13 -0500
From: Chris Mason <clm@fb.com>
Subject: Re: [RFC PATCH 05/17] btrfs: remove bio splitting and
 merge_bvec_fn() calls
To: Dongsu Park <dongsu.park@profitbricks.com>
CC: <linux-kernel@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Kent Overstreet <kmo@daterainc.com>, Ming Lin <mlin@minggr.net>,
        Dongsu Park <dongsu.park@profitbricks.com>,
        Josef Bacik <jbacik@fb.com>, <linux-btrfs@vger.kernel.org>
Message-ID: <1419345853.13012.10@mail.thefacebook.com>
In-Reply-To: <e4b7b017eaa81784889ebb2a4e6a7d4366adf13a.1419241597.git.dongsu.park@profit
	bricks.com>
References: <cover.1419241597.git.dongsu.park@profitbricks.com>
	<e4b7b017eaa81784889ebb2a4e6a7d4366adf13a.1419241597.git.dongsu.park@profitbricks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Dec 22, 2014 at 6:48 AM, Dongsu Park 
<dongsu.park@profitbricks.com> wrote:
> From: Kent Overstreet <kmo@daterainc.com>
> 
> Btrfs has been doing bio splitting from btrfs_map_bio(), by checking
> device limits as well as calling ->merge_bvec_fn() etc. That is not
> necessary any more, because generic_make_request() is now able to
> handle arbitrarily sized bios. So clean up unnecessary code paths.
> 
> Signed-off-by: Kent Overstreet <kmo@daterainc.com>
> [dpark: add more description in commit message]
> Signed-off-by: Dongsu Park <dongsu.park@profitbricks.com>
> Cc: Chris Mason <clm@fb.com>
> Cc: Josef Bacik <jbacik@fb.com>
> Cc: linux-btrfs@vger.kernel.org
> ---

Looks good, I'll test it here too.  Thanks!

Signed-off-by: Chris Mason <clm@fb.com>



