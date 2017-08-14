Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:64197 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752060AbdHNHJQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 14 Aug 2017 03:09:16 -0400
Subject: Re: RedHat 7.4 Release Notes: "Btrfs has been deprecated" - wut?
To: kreijack@inwind.it, Hugo Mills <hugo@carfax.org.uk>,
        Christoph Anton Mitterer <calestyo@scientia.net>,
        Christoph Hellwig <hch@infradead.org>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <84806456-eed9-00b9-b3f6-99e46cefba33@swiftspirit.co.za>
 <4c094049-f8c8-a0ea-674b-33c6905d744a@gmx.com>
 <CAJCQCtRGUBWD6Mw6pAiKGAPgGz+vqy3sgmbEBDETPYsxJw8G7w@mail.gmail.com>
 <b14a36dd-fcab-a38b-cbf9-adbd096da3a3@gmx.com>
 <1502496618.6092.6.camel@scientia.net> <20170812074248.GA3352@infradead.org>
 <1502538706.3996.1.camel@scientia.net> <20170812121257.GZ7140@carfax.org.uk>
 <1219eff6-7020-444c-efd7-6afb5ef551d9@libero.it>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <86a8d523-8dc3-8406-af4c-8bb93e7859c5@gmx.com>
Date: Mon, 14 Aug 2017 15:08:37 +0800
MIME-Version: 1.0
In-Reply-To: <1219eff6-7020-444c-efd7-6afb5ef551d9@libero.it>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 2017年08月13日 22:08, Goffredo Baroncelli wrote:
> On 08/12/2017 02:12 PM, Hugo Mills wrote:
>> On Sat, Aug 12, 2017 at 01:51:46PM +0200, Christoph Anton Mitterer wrote:
>>> On Sat, 2017-08-12 at 00:42 -0700, Christoph Hellwig wrote:
> [...]
>>>                good, but csum is not
>>
>>     I don't think this is a particularly good description of the
>> problem. I'd say it's more like this:
>>
>>     If you write data and metadata separately (which you have to do in
>> the nodatacow case), and the system halts between the two writes, then
>> you either have the new data with the old csum, or the old csum with
>> the new data. Both data and csum are "good", but good from different
>> states of the FS. In both cases (data first or metadata first), the
>> csum doesn't match the data, and so you now have an I/O error reported
>> when trying to read that data.
>>
>>     You can't easily fix this, because when the data and csum don't
>> match, you need to know the _reason_ they don't match -- is it because
>> the machine was interrupted during write (in which case you can fix
>> it), or is it because the hard disk has had someone write data to it
>> directly, and the data is now toast (in which case you shouldn't fix
>> the I/O error)?
> 
> I am still inclined to think that this kind of problems could be solved using a journal: if you track which blocks are updated in the transaction and their checksum, if the transaction are interrupted, you can always rebuild the pair data/checksum:
> in case of interruption of a transaction:
> - all COW data are trashed
> - some NOCOW data might be written
> - all metadata (which are COW) are trashed

The idea itself sounds good, however btrfs doesn't use journal (yet) and 
that means we need to introduce journal while btrfs uses metadata CoW to 
handle most work of journal.

> 
> Supposing to log for each transaction BTRFS which "data NOCOW blocks" will be updated and their checksum, in case a transaction is interrupted you know which blocks have to be checked and are able to verify if the checksum matches and correct the mismatch. Logging also the checksum could help to identify if:
> - the data is old
> - the data is updated
> - the updated data is correct
> 
> The same approach could be used also to solving also the issue related to the infamous RAID5/6 hole: logging which block are updated, in case of transaction aborted you can check the parity which have to be rebuild.
Indeed Liu is using journal to solve RAID5/6 write hole.

But to address the lack-of-journal nature of btrfs, he introduced a 
journal device to handle it, since btrfs metadata is either written or 
trashed, we can't rely existing btrfs metadata to handle journal.

PS: This reminds me why ZFS is still using journal (called ZFS intent 
log) but not mandatory metadata CoW of btrfs.

Thanks,
Qu

> 
>>
>>     Basically, nodatacow bypasses the very mechanisms that are meant to
>> provide consistency in the filesystem.
>>
>>     Hugo.
>>
> 
> 
