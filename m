From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Subject: Re: [PATCH][RFC] Complex filesystem operations: split and join
Date: Tue, 15 Jun 2010 21:01:19 +0900
Message-ID: <87typ4h5dc.fsf@devron.myhome.or.jp>
References: <201006092035.46481.knikanth@novell.com>
	<87aaqzp39a.fsf@devron.myhome.or.jp>
	<201006151611.36443.knikanth@novell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christoph Hellwig <hch@lst.de>,
	Chris Mason <chris.mason@oracle.com>,
	linux-btrfs@vger.kernel.org
To: Nikanth Karthikesan <knikanth@novell.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <201006151611.36443.knikanth@novell.com> (Nikanth Karthikesan's
	message of "Tue, 15 Jun 2010 16:11:35 +0530")
List-ID: <linux-btrfs.vger.kernel.org>

Nikanth Karthikesan <knikanth@novell.com> writes:

>> I have no objections to such those operations (likewise make hole,
>> truncate any range, etc. etc.).
>
> As far as FAT is concerned, Sparse files would break the on-disk format?

Yes. In the case of making hole on FAT, I guess it will return the
error, or emulate it by zero fill.

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
