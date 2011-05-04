From: "Gao, Yunpeng" <yunpeng.gao@intel.com>
Subject: RE: Is it possible for the ext4/btrfs file system to pass some
 context related info to low level block driver?
Date: Wed, 4 May 2011 18:31:19 +0800
Message-ID: <CE761E84DADF2947A4AF22FB8D97A47358EE523B@shsmsx501.ccr.corp.intel.com>
References: <CE761E84DADF2947A4AF22FB8D97A47358E28022@shsmsx501.ccr.corp.intel.com>
 <BANLkTikm-ZMG7KRjjz0DtduPDC4KUw7_Bg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>
To: Kyungmin Park <kmpark@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
In-Reply-To: <BANLkTikm-ZMG7KRjjz0DtduPDC4KUw7_Bg@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hi Park,

Thanks a lot for the response.

>It seems similar with TRIM. So how about to consider TRIM
>implementation or extend it?

Yes, file system set REQ_DISCARD flag to notify block device driver to execute TRIM.
And I noticed there's already a flag REQ_META used for file system meta data.
But seems only gfs2 file system uses the REQ_META flag, other file systems (including ext4 and btrfs) have not used this flag.
Is the flag useless or any other reason?

>I'm not familiar with NCQ implementation but it's also helpful to implement it.

I don't know much about NCQ, too. Just have a impression that NCQ is only for SATA hard disk, can it also be used for block device, such as the mmc block device?

Thanks.

Regards,
Yunpeng

