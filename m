Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:35578 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752127AbbHMOnk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 13 Aug 2015 10:43:40 -0400
Message-ID: <55CCAD10.5070907@oracle.com>
Date: Thu, 13 Aug 2015 22:43:28 +0800
From: Anand Jain <anand.jain@oracle.com>
MIME-Version: 1.0
To: fdmanana@gmail.com
CC: fstests@vger.kernel.org,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "dsterba@suse.cz" <dsterba@suse.cz>,
        Dave Chinner <david@fromorbit.com>, sandeen@sandeen.net
Subject: Re: [PATCH v4 2/3] xfstests: btrfs: test device replace, with EIO
 on the src dev
References: <1430388527-16700-1-git-send-email-anand.jain@oracle.com>	<1437560043-336-1-git-send-email-anand.jain@oracle.com>	<1437560043-336-3-git-send-email-anand.jain@oracle.com> <CAL3q7H5=Oy3qfFt4DTaxCRBNfBW5YfHmcRbCsW3BBbBO7Z3J3w@mail.gmail.com>
In-Reply-To: <CAL3q7H5=Oy3qfFt4DTaxCRBNfBW5YfHmcRbCsW3BBbBO7Z3J3w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>




> So the test always fails due to a mismatch with this expected golden output:
>
>      -Label: none  uuid: <UUID>
>      +Label: none  uuid:  <UUID>
>        Total devices <NUM> FS bytes used <SIZE>
>        devid <DEVID> size <SIZE> used <SIZE> path SCRATCH_DEV
>        devid <DEVID> size <SIZE> used <SIZE> path /dev/mapper/error-test
>
> The extra space after "uuid:" comes from _filter_uuid:
>
>     sed -e "s/\(uuid[ :=]\+\) *[0-9a-f-][0-9a-f-]*/\1 <UUID>/ig"
>
> Which gets \1 with the string "uuid: " and then does "uuid: " + " " + "<UUID>".
>
> We need to either to fix the golden output here or _filter_uuid (and
> make sure it doesn't break any other tests using it directly or
> indirectly such as yours).

commit a092363bbdfa6cc6e44353136bae9d3aa81baae2 (PATCH 3/3 V6] xfs: test 
changing UUID on V5 superblock) caused the regression. btrfs/006 is 
affected as well.

   Thanks
Anand
