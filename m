From: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>
Subject: Re: PATCH 3/6 - direct-io: do not merge logically non-contiguous
 requests
Date: Sat, 07 Aug 2010 09:31:14 +0200
Message-ID: <4C5D0BC2.1040706@linux.vnet.ibm.com>
References: <4C5BE8DB.5030503@linux.vnet.ibm.com> <20100806120358.GA31601@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Cc: Josef Bacik <josef@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20100806120358.GA31601@infradead.org>
List-ID: <linux-btrfs.vger.kernel.org>



On 08/06/2010 02:03 PM, Christoph Hellwig wrote:
> Something is deeply wrong here.  Raw block device access has a 1:1
> mapping between logical and physical block numbers.  They really shou=
ld
> never be non-contiguous.

At least I did nothing I know about to break it :-)

As I mentioned just iozone using direct I/O (-I flag of iozone then=20
using O_DIRECT for the file) on a ext2 file-system.
The file system was coming clean out of mkfs the file was written with=20
iozone one step before the traced read run.

The only uncommon thing here might be the block device, which is a scsi=
=20
disk on our SAN servers (I'm running on s390) - so the driver in charge=
=20
is zfcp (drivers/s390/scsi/).
I could use dasd (drivers/s390/block) disks as well, but I have no=20
blktrace of them yet - what I already know is that they show a similar=20
cost increase. On monday I should be able to get machine resources to=20
verify that both disk types are affected.

Let me know if I can do anything else on my system to shed some light o=
n=20
the matter.



--=20

Gr=FCsse / regards, Christian Ehrhardt
IBM Linux Technology Center, System z Linux Performance
--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
