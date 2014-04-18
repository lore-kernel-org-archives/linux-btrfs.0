Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ee0-f42.google.com ([74.125.83.42]:37074 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753773AbaDRPus (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 18 Apr 2014 11:50:48 -0400
Received: by mail-ee0-f42.google.com with SMTP id d17so1754743eek.1
        for <linux-btrfs@vger.kernel.org>; Fri, 18 Apr 2014 08:50:47 -0700 (PDT)
Message-ID: <535149D4.3090305@gmail.com>
Date: Fri, 18 Apr 2014 17:50:44 +0200
From: "Oliver O." <oliver.o456i@gmail.com>
MIME-Version: 1.0
To: Chris Mason <clm@fb.com>, linux-btrfs@vger.kernel.org
Subject: Solved, false alarm - Re: File changing in snapshot
References: <534FF5C1.8070404@gmail.com> <534FF9B5.4010207@fb.com> <534FFD22.1060500@gmail.com> <535047AB.6030606@gmail.com>
In-Reply-To: <535047AB.6030606@gmail.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am 17.04.2014 23:29, schrieb Oliver O.:
> Conclusions:
>
> The sequence of events seems to be:
>
> 1. The file was changed with generation 193090.
> 2. The snapshot for backup (@home-2014-04-16) was taken (generation 
> 194551).
> 3. As the backup was reading from the snapshot, it was seeing stale 
> data (MyFile still at generation 36067).

This conclusion was wrong:

Rdiff-backup never really considered the modified Excel file for backup, 
as its file modification time did not indicate that the file was newer 
than the last backup. So rdiff-backup always took the file copy already 
available in the previous backup.

What breaks the incremental backup mechanism is Excel modifying a file, 
then changing its modification timestamp back to its original value (see 
comment 10 at https://bugzilla.samba.org/show_bug.cgi?id=1601#c10).

> 4. As the backup comparison was reading from the snapshot, is was 
> seeing more recent data, causing a discrepancy with the stale data 
> just backed up.

The discrepancy between the file's modified contents were discovered 
because the comparison was content-based (MD5 checksums) and compared 
every file regardless of modification dates.

>
> It seems that the snapshot needed some time to become stable for 
> reading. From a file system user's point of view, I'd expect a 
> snapshot to be atomic and stable at any time. Maybe some kind of 
> caching problem here?
>
> Maybe it's time to file a bug report, but first: suggestions and ideas 
> appreciated.
>
Result: False alarm - this is definitely not a Btrfs problem. In this 
case snapshot behavior was as expected: atomic and stable.

Sorry for any irritation.

