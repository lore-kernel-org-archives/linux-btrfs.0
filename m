Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:31473 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751194AbaDQP4a (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 17 Apr 2014 11:56:30 -0400
Message-ID: <534FF9B5.4010207@fb.com>
Date: Thu, 17 Apr 2014 11:56:37 -0400
From: Chris Mason <clm@fb.com>
MIME-Version: 1.0
To: "Oliver O." <oliver.o456i@gmail.com>, <linux-btrfs@vger.kernel.org>
Subject: Re: File changing in snapshot
References: <534FF5C1.8070404@gmail.com>
In-Reply-To: <534FF5C1.8070404@gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 04/17/2014 11:39 AM, Oliver O. wrote:
> I seem to have observed a file on a (writable) snapshot changing
> although there were no writes occuring on the snapshot itself. This is
> not supposed to happen, right?
>
> Sequence of events:
>
> 1. A (writable) snapshot @home-2014-04-16 is taken on a @home subvolume
> mounted at /home.
>
> 2. The current subvolume (@home) is used (via /home) for continued write
> access, no writes are supposed to occur on the snapshot.
>
> 3. The snapshot @home-2014-04-16 is backed up (using rdiff-backup) to a
> different disk.
>
> 4. As the backup is compared to the snapshot @home-2014-04-16, one file
> differs.
>
> Further analysis:
>
> The file in @home-2014-04-16 changed its contents (but not mtime or
> other metadata) after being backup up from that snapshot. 5 bytes differ.
>
> The previous snapshot @home-2014-04-10 contains the file in its original
> form, which is identical to the backup just taken from @home-2014-04-16.
>
> The file change appears identically
> - on the last snapshot @home-2014-04-16 and
> - on the current subvolume used for writing (@home).
>
> btrfs scrub reports 0 errors.
>
> At the time the snapshot @home-2014-04-16 was taken, the file (an Excel
> file) was probably accessed through Samba, which supposedly uses kernel
> oplocks (if that makes a difference).
>
> Versions:
> - Kernel 3.11.0-19-generic (Ubuntu 13.10)
> - btrfs-tools 0.19+20130705-1
> - Samba 3.6.18

Was this a nodatacow file?

-chris
