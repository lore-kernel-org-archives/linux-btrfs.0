Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw0-f177.google.com ([209.85.161.177]:34218 "EHLO
	mail-yw0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752357AbcCMJvA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 13 Mar 2016 05:51:00 -0400
Received: by mail-yw0-f177.google.com with SMTP id h129so136991539ywb.1
        for <linux-btrfs@vger.kernel.org>; Sun, 13 Mar 2016 01:51:00 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAD=QJKhYurWnNrXunX+_=KYamdTqnZ2tzO7_+gFxv12c1bd1Hg@mail.gmail.com>
References: <1457608215-18089-1-git-send-email-alex@zadarastorage.com>
	<CAD=QJKhYurWnNrXunX+_=KYamdTqnZ2tzO7_+gFxv12c1bd1Hg@mail.gmail.com>
Date: Sun, 13 Mar 2016 11:51:00 +0200
Message-ID: <CAOcd+r1TmxAE__Mh0AXpiMPjR=r+5u+H_sW+jv=QU54_skt0eA@mail.gmail.com>
Subject: Re: [PATCH 2/2] btrfs: do not write corrupted metadata blocks to disk
From: Alex Lyakas <alex@zadarastorage.com>
To: Nicholas D Steeves <nsteeves@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Nicholas,

On Sat, Mar 12, 2016 at 12:19 AM, Nicholas D Steeves <nsteeves@gmail.com> wrote:
> On 10 March 2016 at 06:10, Alex Lyakas <alex.bolshoy@gmail.com> wrote:
>> csum_dirty_buffer was issuing a warning in case the extent buffer
>> did not look alright, but was still returning success.
>> Let's return error in this case, and also add an additional sanity
>> check on the extent buffer header.
>> The caller up the chain may BUG_ON on this, for example flush_epd_write_bio will,
>> but it is better than to have a silent metadata corruption on disk.
>
> Does this mean there is a good chance that everyone has corrupted
> metadata?
No, this definitely does not.

The code that I added prevents btrfs from writing a metadata block, if
it somehow got corrupted before being sent to disk. If it happens, it
indicates a bug somewhere in the kernel. For example, if some other
kernel module erroneously uses a page-cache entry, which does not
belong to it (and contains btrfs metadata block or part of it).

> Is there any way to verify/rebuild it without wipefs+mkfs+restore from backups?
To verify btrfs metadata: unmount the filesystem and run "btrfs check
...". Do not specify the "repair" parameter. Another way to verify is
to run "btrfs-debug-tree" and redirect its standard output to
/dev/null. It should not print anything to standard error. But "btrfs
check" is faster.

Thanks,
Alex.
