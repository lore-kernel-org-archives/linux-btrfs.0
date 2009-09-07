From: "Yan, Zheng " <yanzheng@21cn.com>
Subject: Re: Question about back references
Date: Mon, 7 Sep 2009 17:41:50 +0800
Message-ID: <3d0408630909070241x78f043fdu9bf3f1ddd41a4ddd@mail.gmail.com>
References: <4AA2C7E6.40200@eecs.harvard.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Peter Macko <pmacko@eecs.harvard.edu>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4AA2C7E6.40200@eecs.harvard.edu>
List-ID: <linux-btrfs.vger.kernel.org>

2009/9/6 Peter Macko <pmacko@eecs.harvard.edu>:
> I am trying to understand how exactly the file extent back references work
> in btrfs. Can please someone tell me if the following is correct? - The back
> references are accumulated in an in-memory balanced tree (delayed-ref.c and
> delayed-ref.h) and pushed to disk during the transaction commit (a part of a
> checkpoint). They are placed into the B-tree under the key (bytenr,
> BTRFS_EXTENT_REF_KEY, hash of the four fields of the record), so that they
> are stored next to the file extent forward references.
>
This was correct for btrfs in 2.6.30 and earlier version. We introduced a new
back references format in 2.6.31. For more information about the new format,
please read the comments in extent-tree.c

> I am also wondering about the implications of copy on write: Imagine that
> you have an inode with four file extents and thus also four back references.
> COW of one of the extents then causes the COW of the inode. The new version
> of the inode has a different transaction ID, which is also one of the fields
> of back reference records. This causes the file system to add four new back
> reference records - one for the modified extent and three for the unmodified
> ones (since the transaction ID field has to be updated). Does this really
> happen, or is there some scheme to avoid adding these extra records?
>
It's avoid by using the new back references format.

Yan, Zheng
