Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from outrelay08.libero.it ([212.52.84.112]:44791 "EHLO
	outrelay08.libero.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752914Ab3KSRo2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 19 Nov 2013 12:44:28 -0500
Message-ID: <528BA37B.6050609@inwind.it>
Date: Tue, 19 Nov 2013 18:44:27 +0100
From: Goffredo Baroncelli <kreijack@inwind.it>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: fdmanana@gmail.com
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH V2] Btrfs: add support for inode properties
References: <1384263757-25627-1-git-send-email-fdmanana@gmail.com> <1384305698-22710-1-git-send-email-fdmanana@gmail.com> <5283CC06.4050703@libero.it> <CAL3q7H6x5_Bh=5yuH0msg3tdomBKQ0RmWmjHcPdSS0yRJChr5Q@mail.gmail.com>
In-Reply-To: <CAL3q7H6x5_Bh=5yuH0msg3tdomBKQ0RmWmjHcPdSS0yRJChr5Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Filipe
On 2013-11-19 17:06, Filipe David Manana wrote:
> On Wed, Nov 13, 2013 at 6:59 PM, Goffredo Baroncelli <kreijack@libero.it> wrote:
>> Hi Filipe,
>>
>> my comments below
>> On 2013-11-13 02:21, Filipe David Borba Manana wrote:
>>> This change adds infrastructure to allow for generic properties for
>>> inodes. Properties are name/value pairs that can be associated with
>>> inodes for different purposes. They're stored as xattrs with the
>>> prefix "btrfs."
[...]
> 
>>
>> Moreover I have a doubt about the opportunity to store the information
>> like the compression both in inode and in the xattr: what happens if the
>> user does an "chattr -c" ? The xattr will be not updated.
> 
> Right, there was no interaction the compression attr/flag.
> The next patch version adds such interaction.
> 
>> I suggest to update/create a real xattr only if there is no space for
>> the new information in the inode. In the other case the xattr should be
>> a fake xattr to get/set the property stored in the inode (or whichever
>> is involved).
>>
>> Of course also the function btrfs_listxattr() should be updated to show
>> the "fake" xattr which doesn't have a real xattr stored on the disk. The
>> same is true for the getxattr() function...
> 
> Adding such fake on the fly stuff seems too complex imho. Just
> adding/removing the xattr compression properties on chattr +c/-c seems
> simpler and more intuitive.


Looking at btrfs_listxattr() it seems that the xattr listing is done in
a very simple way: the function *listxattr() returns a buffer filled
with all the xattr as a zero terminated strings sequences. Because the
"fake" attribute are know in advance, listing these became a memcpy() of
a bytes of buffer statically allocated.

GB

-- 
gpg @keyserver.linux.it: Goffredo Baroncelli (kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
