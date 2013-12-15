Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from atl4mhob02.myregisteredsite.com ([209.17.115.40]:56661 "EHLO
	atl4mhob02.myregisteredsite.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753596Ab3LODrP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 14 Dec 2013 22:47:15 -0500
Received: from mailpod1.hostingplatform.com ([10.30.71.116])
	by atl4mhob02.myregisteredsite.com (8.14.4/8.14.4) with ESMTP id rBF3lDKh023707
	for <linux-btrfs@vger.kernel.org>; Sat, 14 Dec 2013 22:47:13 -0500
Message-ID: <52AD2656.804@chinilu.com>
Date: Sat, 14 Dec 2013 19:47:34 -0800
From: George Mitchell <george@chinilu.com>
Reply-To: george@chinilu.com
MIME-Version: 1.0
To: Hans-Kristian Bakke <hkbakke@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Blocket for more than 120 seconds
References: <CAD_cGvFdrhwC2erqYTMjPRG7Y=69tsT2O+S-GHYK7+wpBwFSFQ@mail.gmail.com>	<46A0D70E-99DF-46FE-A4E8-71E9AC45129F@colorremedies.com>	<CAD_cGvHkpkuveYFKm4kjgc0SkJ=mQ4mpChes0F25fdjc5r3PmQ@mail.gmail.com>	<337E6C9D-298E-4F77-91D7-648A7C65D360@colorremedies.com> <CAD_cGvGLHgHagW-G5Qz1yXY4w14BBiZsJj3K0-FmjEGzoo-_rw@mail.gmail.com>
In-Reply-To: <CAD_cGvGLHgHagW-G5Qz1yXY4w14BBiZsJj3K0-FmjEGzoo-_rw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 12/14/2013 04:28 PM, Hans-Kristian Bakke wrote:
>
> I would normally expect that there is no difference in 1TB free space
> on a FS that is 2TB in total, and 1TB free space on a filesystem that
> is 30TB in total, other than my sense of urge and that you would
> probably expect data growth to be more rapid on the 30TB FS as there
> is obviously a need to store a lot of stuff.
> Is "free space needed" really a different concept dependning on the
> size of your FS?
I would suggest there just might be a very significant difference. In 
the case of a 30TB array as opposed to a 3TB array, you are dealing with 
a much higher ratio of used space to free space.  I believe this creates 
a higher likelihood that the free space is occurring as a larger number 
of very small pieces of drive space as opposed to a 3TB drive where 
1/3rd of the drive space free would imply actual USABLE space on the 
drives.  My concern would be that with only 1/30th of the space on the 
drives left free, that remaining space likely involves a lot of very 
small segments that create a situation where the filesystem is 
struggling to compute how to lay out new files.  And, on top of that, 
defragmentation could become a nightmare of complexity as well, since 
the filesystem first has to clear contiguous space to somewhere in order 
to defragment each file.  And then throw in the striping and mirroring 
requirements.  I know those algorithms are likely pretty sophisticated, 
but something tells me that the higher the RATIO of used space to free 
space, the more difficult things might get for the filesystem.  Just 
about everybody here knows a whole lot more about this than I do, but 
something really concerns me about this ratio issue.  Ideally of course 
it probably should work, but its just got to be significantly more 
complex than a 3TB situation. These are just my thoughts as a 
comparative novice when it comes to btrfs or filesystems in general.
