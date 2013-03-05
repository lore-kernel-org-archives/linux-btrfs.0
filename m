Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ia0-f174.google.com ([209.85.210.174]:49863 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932721Ab3CEBzs (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Mar 2013 20:55:48 -0500
Received: by mail-ia0-f174.google.com with SMTP id u20so5416657iag.5
        for <linux-btrfs@vger.kernel.org>; Mon, 04 Mar 2013 17:55:48 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAEzrpqf2ioE+Q8rZrJJoOZw0=EWStoWWd-9fSPh4+OevAiV2XQ@mail.gmail.com>
References: <CAEx9m45BO=McK-NrL3fX7QiJMtf-T+bKoc1D1G=6vHxYT8b36g@mail.gmail.com>
 <20130220175410.GB2062@localhost.localdomain> <CAEx9m46b9rW4xDiQi8QiTmyC5Wa9hNcasL_nXF4Y2qdyPE+D6g@mail.gmail.com>
 <CAEzrpqcGeiq=tHEvcH9625vZpCZaD94PrpjYO1_r4nS2GP9ByA@mail.gmail.com>
 <CAEx9m45V6aUkNQe0PTf+qJjpkJLHyMc4UBfSex9mxGOy-X7GrQ@mail.gmail.com>
 <20130225172719.GA2434@localhost.localdomain> <CAEx9m44BBv-rZqF_tv5PgKkHjfzBYo9p-4h3WeGLdykA+s+71A@mail.gmail.com>
 <CAEx9m454t17kngaKv+PWL2V=DLYr6viT6J_eWEtHFfc10csioQ@mail.gmail.com>
 <CAEzrpqe86eFRTr+AL+1agmaF712nGS0fXwpDf67CnaDd86KuLQ@mail.gmail.com>
 <CAEx9m44R=sF9pMzCZix-LxZg0VFRHPT5Mdek3T-sEuPO1r7CRQ@mail.gmail.com> <CAEzrpqf2ioE+Q8rZrJJoOZw0=EWStoWWd-9fSPh4+OevAiV2XQ@mail.gmail.com>
From: Aastha Mehta <aasthakm@gmail.com>
Date: Tue, 5 Mar 2013 02:55:27 +0100
Message-ID: <CAEx9m46242WuS4QxhDNLAnS2556oTEPNKtTKvoBk61RoQz0hWQ@mail.gmail.com>
Subject: Re: basic questions regarding COW in Btrfs
To: Josef Bacik <josef@toxicpanda.com>
Cc: Josef Bacik <jbacik@fusionio.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Okay, that makes lot more sense to me now.

Thank you very much.

Regards,
Aastha.

On 5 March 2013 02:51, Josef Bacik <josef@toxicpanda.com> wrote:
> On Mon, Mar 4, 2013 at 7:57 PM, Aastha Mehta <aasthakm@gmail.com> wrote:
>> I must admit, it is quite convoluted :-)
>>
>> Please tell me if I understand this. A file system tree (containing
>> the inodes, the extents of all the inodes, etc.) is itself laid out in
>> the leaf extents of another big tree, which is the root tree. This is
>> why you say that inode and other such metadata may be lying in the
>> leaf nodes. Correct?
>>
>
> Sort of.  We have lot's of tree's, but the inode data is laid out in
> what we refer to as fs trees.  All these trees are just b-trees that
> have different data in them.  In the fs-trees they will hold inode
> items, directory items, file extent items, xattr items and orphan
> items.  So any given leaf in this tree could have any number of those
> items in them referring to any number of inodes.  You could have
>
> [inode item for inode 1][file extent item for inode 1][inode item for
> inode 2][xattr for inode 2][file extent item for inode 2]
>
> all contained within one leaf.  Does that make sense?
>
>> I did not completely understand what you meant when you said that the
>> metadata (the file extent items and such) for the inodes are stored
>> inside the same tree that the inode resides in. I thought the
>> btrfs_file_extent_item associated with EXTENT_DATA_KEY corresponds to
>> the actual data of a file.
>>
>
> Yes the btrfs_file_extent_item points to a [offset, size] pair that
> describes a data extent.
>
>> Okay, now I am not even sure if in btrfs there is something like an
>> indirect block for a huge file. In file systems with fixed block size,
>> one can hold only as many pointers to data blocks and hence when the
>> file size grows indirects are added in the file's tree. Is there any
>> equivalent indirect extent required for huge files in btrfs, or do all
>> the files fit within one level? If there are indirects, what item type
>> do they have? Would something like btrfs_get_extent() be useful to get
>> the indirect extents of a file?
>>
>
> So there are no indirects, there are just btrfs_file_extent_items that
> are held within the btree that describe all of the extents that relate
> to a particular file.  So you can have (in the case of large
> fragmented files) hundreds of leaves within the btree that just
> contain btrfs_file_extent_items for all the ranges for a file.
> btrfs_get_extent() just looks up the relevant btrfs_file_extent_item
> for the range that you are wondering about, and maps it to our
> extent_map structure internally.  Hth,
>
> Josef
