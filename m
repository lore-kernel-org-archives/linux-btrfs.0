Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from resqmta-ch2-12v.sys.comcast.net ([69.252.207.44]:53060 "EHLO
	resqmta-ch2-12v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750836AbaK0AcE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 26 Nov 2014 19:32:04 -0500
Message-ID: <547670FF.3090407@pobox.com>
Date: Wed, 26 Nov 2014 16:31:59 -0800
From: Robert White <rwhite@pobox.com>
MIME-Version: 1.0
To: Roman Mamedov <rm@romanrm.net>
CC: linux-btrfs@vger.kernel.org
Subject: Re: Can't cp --reflink files on a Ext4-converted FS w/o checksums
References: <20141127005527.42a7fe59@natsu> <54765FC2.2050309@pobox.com> <20141127043337.198d6084@natsu> <54766997.1040101@pobox.com> <20141127052021.47734be0@natsu>
In-Reply-To: <20141127052021.47734be0@natsu>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 11/26/2014 04:20 PM, Roman Mamedov wrote:
> On Wed, 26 Nov 2014 16:00:23 -0800
> Robert White <rwhite@pobox.com> wrote:
>
>> Uh... you may _still_ have no checksums on any of those data extents.
>> They are not going to come back until you write them to a normal file
>> with a normal copy. So you may be lacking most of the data validation
>> features of this filesystem.
>
> Well, this FS is coming from being Ext4 for years, so it's not worse off now
> than it was before. And anyways the main feature that I wanted were snapshots.

Given that you wont be able to scrub the data and BTRFS is usable but 
still a little brittle, it might be a little worse off than you think.

Plus if you ever find yourself in need of balancing you've tossed out 
one level of data integrity right here at the start.


>> You might want to go experiment. Make another new subvol (or at least a
>> directory in a directory/root/subvol that never had the +C attribute
>> set) and see if you can cp --reflink any of these files into that
>> subdirectory without repeating the +C trick.
>
> Ha, indeed I can't. Maybe there should be a way to generate checksums without
> rewriting files, just via reading them, then calculating and writing checksum
> to metadata.

That problem would be "computationally hard" because you'd have to 
verify that no other file was using that extent before you put that 
extent under control of the csum machinery, otherwise you might break 
later break the COW promise when the file that knows those blocks by 
their checksum changes the contents out from underneath the other 
references.


>> Clearing NODATACOW does _not_ clear NODATASUM (at least not on a
>> non-empty file) as near as I can tell, so that directory hierarchy and
>> its subsequent snapshots is likely "less safe" than you think.
>
> The nodatasum flag also isn't accessible via chattr, is it?

It is not. NODATASUM and NODATACOW are private features. The linux 
kernel has no general concept of data checksums. The BTRFS guys mapped 
the NODATACOW attribute onto the existing lsattr/chattr bit because it 
was defined for another file system long ago.

You'll also find that you can not set or clear the C attr on a file in a 
BTRFS unless its size is zero. So all your files now have the C 
attribute more-or-less forever. Only a normal copy operation (e.g. 
allocating new extents and writing the data into them wiht the checksum 
feature in force) will change that.


