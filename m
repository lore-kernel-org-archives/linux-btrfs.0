Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-relay1.uniserve.net ([216.210.109.131]:48903 "EHLO
	smtp-relay1.uniserve.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751367AbcC3SZx (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Mar 2016 14:25:53 -0400
Message-ID: <20160330111116.85832phnfo4ksddw@webmail.uniserve.com>
Date: Wed, 30 Mar 2016 11:11:16 -0700
From: Dave Stevens <geek@uniserve.com>
To: bo.li.liu@oracle.com
Cc: sri <toyours_sridhar@yahoo.co.in>, linux-btrfs@vger.kernel.org
Subject: Re: good documentation on btrfs internals and on disk layout
References: <loom.20160330T155403-473@post.gmane.org>
 <20160330172819.GD20816@localhost.localdomain>
In-Reply-To: <20160330172819.GD20816@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=ISO-8859-1;
 DelSp="Yes";
 format="flowed"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Quoting Liu Bo <bo.li.liu@oracle.com>:

> On Wed, Mar 30, 2016 at 01:58:03PM +0000, sri wrote:
>> Hi,
>>
>> I could find very limited documentation related to on disk layout of btrfs
>> and how all trees are related to each other. Except wiki which has very
>> specific top level details I couldn't able to find more details on btrfs.
>>
>> FSs such as zfs, ext3/4 and XFS there are documents which explains ondisk
>> layout of the file systems.
>>
>> Could anybody please provide pointers for the same for better
>> understanding of btrfs on disk layout and how each tree interacts provided
>> multiple disks are configured for btrfs.
>
> There is a paper[1] about btrfs filesystem which covers all the details.
>
> [1]: BTRFS: The Linux B-Tree Filesystem

and this is where it is:

http://domino.watson.ibm.com/library/CyberDig.nsf/papers/6E1C5B6A1B6EDD9885257A38006B6130/$File/rj10501.pdf

D

>
> Thanks,
>
> -liubo
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
"As long as politics is the shadow cast on society by big business,
the attenuation of the shadow will not change the substance."

-- John Dewey





