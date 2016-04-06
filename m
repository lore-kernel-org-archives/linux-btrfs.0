Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f43.google.com ([74.125.82.43]:36995 "EHLO
	mail-wm0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750725AbcDFEEi (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 Apr 2016 00:04:38 -0400
Received: by mail-wm0-f43.google.com with SMTP id n3so45511685wmn.0
        for <linux-btrfs@vger.kernel.org>; Tue, 05 Apr 2016 21:04:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAOcd+r1TmxAE__Mh0AXpiMPjR=r+5u+H_sW+jv=QU54_skt0eA@mail.gmail.com>
References: <1457608215-18089-1-git-send-email-alex@zadarastorage.com>
	<CAD=QJKhYurWnNrXunX+_=KYamdTqnZ2tzO7_+gFxv12c1bd1Hg@mail.gmail.com>
	<CAOcd+r1TmxAE__Mh0AXpiMPjR=r+5u+H_sW+jv=QU54_skt0eA@mail.gmail.com>
Date: Wed, 6 Apr 2016 00:04:36 -0400
Message-ID: <CAD=QJKjD+CcqkyXG_J6Tq0vLSrx3QD7X1NBU2oPeCt4TmKBd7A@mail.gmail.com>
Subject: Re: [PATCH 2/2] btrfs: do not write corrupted metadata blocks to disk
From: Nicholas D Steeves <nsteeves@gmail.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Alex,

On 13 March 2016 at 05:51, Alex Lyakas <alex@zadarastorage.com> wrote:
> Nicholas,
>
> On Sat, Mar 12, 2016 at 12:19 AM, Nicholas D Steeves <nsteeves@gmail.com> wrote:
>> On 10 March 2016 at 06:10, Alex Lyakas <alex.bolshoy@gmail.com> wrote:
>> Does this mean there is a good chance that everyone has corrupted
>> metadata?
> No, this definitely does not.
>
> The code that I added prevents btrfs from writing a metadata block, if
> it somehow got corrupted before being sent to disk. If it happens, it
> indicates a bug somewhere in the kernel. For example, if some other
> kernel module erroneously uses a page-cache entry, which does not
> belong to it (and contains btrfs metadata block or part of it).

Oh wow, I didn't know that was possible.  If I understand correctly,
this patch makes using bcache a little bit safer?  (I don't use it
since I'm too short on free time to what is--I suspect-- something
that radically increases the chances of having to restore from backup)

>> Is there any way to verify/rebuild it without wipefs+mkfs+restore from backups?
> To verify btrfs metadata: unmount the filesystem and run "btrfs check
> ...". Do not specify the "repair" parameter. Another way to verify is
> to run "btrfs-debug-tree" and redirect its standard output to
> /dev/null. It should not print anything to standard error. But "btrfs
> check" is faster.

Ah, that's exactly what I was looking for!  Thank you.  It took
forever, and brought me back to what it was like to fsck large ext2
volumes.  Is btrfs check conceptually identical to a read-only fsck of
a ext2 volume?  If now how does it defer?

Are the following sort of errors still an issue?:
Extent back ref already exists for 2148837945344 parent 0 root 257
leaf parent key incorrect 504993210368
bad block 504993210368
( https://btrfs.wiki.kernel.org/index.php/Btrfsck )

Cheers,
Nicholas
