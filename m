Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from shinra.asoshared.com ([65.99.237.192]:52522 "EHLO
	shinra.asoshared.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754849AbbCBU7N (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 2 Mar 2015 15:59:13 -0500
Received: from mail-yk0-f174.google.com ([209.85.160.174]:43597)
	by shinra.asoshared.com with esmtpsa (TLSv1.2:AES128-GCM-SHA256:128)
	(Exim 4.85)
	(envelope-from <git@nerdoftheherd.com>)
	id 1YSXQm-0003uB-04
	for linux-btrfs@vger.kernel.org; Mon, 02 Mar 2015 15:59:12 -0500
Received: by ykp9 with SMTP id 9so14631835ykp.10
        for <linux-btrfs@vger.kernel.org>; Mon, 02 Mar 2015 12:59:11 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CABJ34CJR=AjAavwct4v9ud_62mSSzd3StivGHqfhNXBjGTuvjA@mail.gmail.com>
References: <1422295551-25402-1-git-send-email-git@nerdoftheherd.com>
	<20150128125521.GD3641@twin.jikos.cz>
	<CABJ34CJR=AjAavwct4v9ud_62mSSzd3StivGHqfhNXBjGTuvjA@mail.gmail.com>
Date: Mon, 2 Mar 2015 20:59:11 +0000
Message-ID: <CABJ34CJO7rSOOOyxZy=gym7V2dzDtjnFaTXHN1Vcu_+rmaF64w@mail.gmail.com>
Subject: Re: [PATCH 1/1] btrfs: Align EOF length to block in extent_same
From: Matt Robinson <git@nerdoftheherd.com>
To: David Sterba <dsterba@suse.cz>
Cc: linux-btrfs@vger.kernel.org, Mark Fasheh <mfasheh@suse.de>,
        Josef Bacik <jbacik@fb.com>, Chris Mason <clm@fb.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi David,

Have you had a chance to look at this?  Am very happy to answer
further questions, adjust my implementation, provide a different kind
of test case, etc.

Many Thanks,

Matt

On 28 January 2015 at 19:46, Matt Robinson <git@nerdoftheherd.com> wrote:
> On 28 January 2015 at 12:55, David Sterba <dsterba@suse.cz> wrote:
>> On Mon, Jan 26, 2015 at 06:05:51PM +0000, Matt Robinson wrote:
>>> It is not currently possible to deduplicate the last block of files
>>> whose size is not a multiple of the block size, as the btrfs_extent_same
>>> ioctl returns -EINVAL if offset + size is greater than the file size or
>>> is not aligned to the fs block size.
>>
>> Do you have a reproducer for that?
>
> I've been using the (quick and dirty) bash script at the end of this
> mail which uses btrfs-extent-same from
> https://github.com/markfasheh/duperemove/ to call the ioctl.  To
> summarize: it creates a new filesystem, creates a file with a size
> which is not a multiple of the block size, copies it, and then calls
> the ioctl to ask firstly for all of the complete blocks (for
> comparison) and then the entire files to be deduplicated.
>
> Running the script under a kernel compiled from
> git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git gives
> a status of -22 from the second btrfs-extent-same call and the final
> btrfs filesystem df shows:
> Data, single: total=8.00MiB, used=1.91MiB
>
> However, running under the same kernel plus my patch shows this final
> data usage:
> Data, single: total=8.00MiB, used=980.00KiB
>
>> The alignment is required to let btrfs_clone and the extent dropping
>> functions to work. [...]
>
> Which is why it is currently not possible to deduplicate a final
> incomplete block of a file:
> * Passing len + offset = the actual end of the file: Rejected as it is
> not aligned
> * Passing len + offset = the end of the block: Rejected as it exceeds
> the actual end of the file.
>
> Please let me know if you need any further information, if my
> implementation should be different or there is a better way I could
> demonstrate the issue?
>
> Many Thanks,
>
> Matt
>
> ---
>
> #!/bin/bash -e
>
> if [[ $EUID -ne 0 ]]; then
>    echo "This script must be run as root"
>    exit 1
> fi
>
> loopback=$(losetup -f)
>
> echo "## Create new btrfs filesystem on a loopback device"
> dd if=/dev/zero of=testfs bs=1048576 count=1500
> losetup $loopback testfs
> mkfs.btrfs $loopback
> mkdir testfsmnt
> mount $loopback testfsmnt
>
> echo -e "\n## Create 1000000 byte random file"
> dd if=/dev/urandom of=testfsmnt/test1 bs=1000000 count=1
> echo
> btrfs filesystem sync testfsmnt
> btrfs filesystem df testfsmnt
>
> echo -e "\n## Copy file"
> cp testfsmnt/test1 testfsmnt/test2
> echo
> btrfs filesystem sync testfsmnt
> btrfs filesystem df testfsmnt
>
> echo -e "\n## Dedupe to end of last full block"
> btrfs-extent-same 999424 testfsmnt/test1 0 testfsmnt/test2 0
> echo
> btrfs filesystem sync testfsmnt
> btrfs filesystem df testfsmnt
>
> echo -e "\n## Dedupe to end of file"
> btrfs-extent-same 1000000 testfsmnt/test1 0 testfsmnt/test2 0
> echo
> btrfs filesystem sync testfsmnt
> btrfs filesystem df testfsmnt
>
> echo -e "\nClean up"
> umount testfsmnt
> rmdir testfsmnt
> losetup -d $loopback
> rm testfs
