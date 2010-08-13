From: Ben Chociej <bchociej@gmail.com>
Subject: Re: [PATCH 2/2] Btrfs-progs: Add hot data support in mkfs
Date: Fri, 13 Aug 2010 09:10:24 -0500
Message-ID: <AANLkTinQAa=DujQ2Tm1oi2kVqF9z1RX2_M3SCCO_MKZG@mail.gmail.com>
References: <1281652177-23562-1-git-send-email-bchociej@gmail.com>
 <1281652177-23562-3-git-send-email-bchociej@gmail.com> <20100813131422.GA615@centrinvest.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: bchociej@gmail.com, chris.mason@oracle.com,
	linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, cmm@us.ibm.com, bcchocie@us.ibm.com,
	mrlupfer@us.
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100813131422.GA615@centrinvest.ru>
List-ID: <linux-btrfs.vger.kernel.org>

It's a good point, of course. Ideally we would be able to prioritize
data and place them on 15k versus 7.2krpm disks, etc. However you get
to a point where's there's only incremental benefit. For that reason,
the scope of this project was simply to take advantage of SSD and HDD
in hybrid. Of course, you could register the same complaint about the
ZFS SSD caching: why not take advantage of faster vs. slower spinning
disks? Unfortunately it just wasn't in the scope of our 12-week
project here.

That's not to say it *shouldn't* be done in the future, of course!
And, incidentally, you could hack it together at this point by setting
the /sys/block/<blockdev>/queue/rotational flag to 0 and using it like
an SSD. :)

BC

On Fri, Aug 13, 2010 at 8:14 AM, Andrey Panin <pazke@centrinvest.ru> wr=
ote:
> On 224, 08 12, 2010 at 05:29:37PM -0500, bchociej@gmail.com wrote:
>> From: Ben Chociej <bchociej@gmail.com>
>>
>> Modified mkfs.btrfs to add hot data relocation option (-h) which
>> preallocates BTRFS_BLOCK_GROUP_DATA_SSD and
>> BTRFS_BLOCK_GROUP_METADATA_SSD at mkfs time for future use by hot da=
ta
>> relocation code. =A0Also added a userspace function to detect whethe=
r a
>> block device is an SSD by reading the sysfs block queue rotational f=
lag.
>
> IMHO this policy is too inflexible. What if I have large array of slo=
w SATA
> disks and some fast SAS ones ?
>
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
