Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e36.co.us.ibm.com ([32.97.110.154]:50832 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754758Ab2JCRlD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 3 Oct 2012 13:41:03 -0400
Received: from /spool/local
	by e36.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <clinew@linux.vnet.ibm.com>;
	Wed, 3 Oct 2012 11:40:59 -0600
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by d03dlp02.boulder.ibm.com (Postfix) with ESMTP id E17D73E4005E
	for <linux-btrfs@vger.kernel.org>; Wed,  3 Oct 2012 11:40:51 -0600 (MDT)
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id q93HelaV178038
	for <linux-btrfs@vger.kernel.org>; Wed, 3 Oct 2012 11:40:47 -0600
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id q93HeZFu020075
	for <linux-btrfs@vger.kernel.org>; Wed, 3 Oct 2012 11:40:37 -0600
Message-ID: <506C786B.4080704@linux.vnet.ibm.com>
Date: Wed, 03 Oct 2012 10:39:55 -0700
From: Wade Cline <clinew@linux.vnet.ibm.com>
MIME-Version: 1.0
To: "Theodore Ts'o" <tytso@mit.edu>
CC: "cmm@linux.vnet.ibm.com" <cmm@linux.vnet.ibm.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [e2fsprogs] ext2_dir_entry To ext2_dir_entry_2 Casting
References: <506B31B7.40405@linux.vnet.ibm.com> <506B3A3E.1060003@linux.vnet.ibm.com> <20121002210836.GA15277@thunk.org>
In-Reply-To: <20121002210836.GA15277@thunk.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 10/02/2012 02:08 PM, Theodore Ts'o wrote:

> On Tue, Oct 02, 2012 at 12:02:22PM -0700, Wade Cline wrote:
>> Hello Theodore Ts'o,
>>
>> Is there a function similar to ext2fs_dir_iterate2() that will call a hook
>> function on an ext2_dir_entry_2 structure and not an ext2_dir_entry
>> structure?
>>
>> The reason I ask is because btrfs-convert currently tries to do a cast
>> between the two structures as such:
>>
>> 	static int dir_iterate_proc(..., struct ext2_dir_entry *old, ...)
>> 	{
>> 	...
>> 		struct ext2_dir_entry_2 *dirent = (struct ext2_dir_entry_2 *)old;
>>
>> which works fine on little-endian machines, but breaks on big-endian machines.
> The reason why we don't have that function today is because what most
> programs (especially inside e2fsprogs) have done is to use the
> ext2_dir_entry structure and just simply used (name_len&  0xff) to get
> the actual name length, and in the case of e2fsck (which is the only
> program which in practice has cared about the file type) to get the
> file type by doing (name_len>>  8).
>
I see. That should work fine, too.

>> If there isn't, would you be interested in a patch that adds a
>> function, say, ext2_dir_entry_upgrade(struct ext2_dir_entry *old,
>> struct ext2_dir_entry_2 *new) that will convert one structure to the
>> other and take into account the endianness of the machine? This
>> would be better than just ad-hoc fixing the code in btrfs.
> We could do that, but that would mean needing to copy the data
> structure somewhere else, which means you would have to allocate
> memory for the new data structure, and then you'd have to release that
> memory later, etc.
>
> I would think that using (name_len&  0xFF) is a much simpler solution,
> and my suggestion is to not depend on the file type in the directory
> entry (since there might be some very old ext2 file systems that don't
> set the file type), and to use the inode's mode bits as authoratative
> for the file type of the inode.
>
> Regards,
>
> 							- Ted
Interesting compatibility issue. Will keep it in mind.

Thank you for the help.

Sincerely,
Wade

