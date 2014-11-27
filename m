Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from resqmta-po-01v.sys.comcast.net ([96.114.154.160]:55866 "EHLO
	resqmta-po-01v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752544AbaK0A5I (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 26 Nov 2014 19:57:08 -0500
Message-ID: <547676DF.5080601@pobox.com>
Date: Wed, 26 Nov 2014 16:57:03 -0800
From: Robert White <rwhite@pobox.com>
MIME-Version: 1.0
To: Roman Mamedov <rm@romanrm.net>
CC: linux-btrfs@vger.kernel.org
Subject: Re: Can't cp --reflink files on a Ext4-converted FS w/o checksums
References: <20141127005527.42a7fe59@natsu> <54765FC2.2050309@pobox.com> <20141127043337.198d6084@natsu> <54766997.1040101@pobox.com> <20141127052021.47734be0@natsu> <547670FF.3090407@pobox.com>
In-Reply-To: <547670FF.3090407@pobox.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 11/26/2014 04:31 PM, Robert White wrote:
> On 11/26/2014 04:20 PM, Roman Mamedov wrote:
>> On Wed, 26 Nov 2014 16:00:23 -0800
>> Robert White <rwhite@pobox.com> wrote:
>>> You might want to go experiment. Make another new subvol (or at least a
>>> directory in a directory/root/subvol that never had the +C attribute
>>> set) and see if you can cp --reflink any of these files into that
>>> subdirectory without repeating the +C trick.
>>
>> Ha, indeed I can't. Maybe there should be a way to generate checksums
>> without
>> rewriting files, just via reading them, then calculating and writing
>> checksum
>> to metadata.
>
> That problem would be "computationally hard" because you'd have to
> verify that no other file was using that extent before you put that
> extent under control of the csum machinery, otherwise you might break
> later break the COW promise when the file that knows those blocks by
> their checksum changes the contents out from underneath the other
> references.

I explained this poorly/incorrectly...

So some guy like yourself converts a file system, or mounts an existing 
file system with nodatasum and creates some file. As a result there is a 
file called /One that has no checksums on its extents.

Then the guy creates a directory and sets +C on it, and copies the file 
into that directory with "cp --reflink /One /d/Two". File /d/Two is a 
no-cow file.

Now the guy somes back and decides to put the data checksums onto the 
extents of /One.

At this moment everything _looks_ fine.

Then the guy alters the first byte of /d/Two, which modifies the no-cow 
file in place.

Now the guy tires to read /One ... what happens? The checksum doesn't 
match and the data has changed because of the NOCOW.

(So I think, in practice, the 1COW mechanism prevents this just like it 
works for snapshots)

But thats a _lot_ of corner cases that can be solved by telling someone 
to copy the file if they want the checksums to be recreated.

e.g. the set of all files and all possibilities gets well into the 
"computationally hard" end of the swimming pool.
