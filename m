Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ee0-f54.google.com ([74.125.83.54]:58713 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751725Ab3AZHqK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 26 Jan 2013 02:46:10 -0500
Received: by mail-ee0-f54.google.com with SMTP id c41so520838eek.27
        for <linux-btrfs@vger.kernel.org>; Fri, 25 Jan 2013 23:46:09 -0800 (PST)
Message-ID: <510389E3.1070002@gmail.com>
Date: Sat, 26 Jan 2013 08:46:43 +0100
From: Goffredo Baroncelli <kreijack@gmail.com>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: russell@coker.com.au
CC: Gene Czarcinski <gene@czarc.net>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs-progs: Exit if not running as root
References: <1359113550-23962-1-git-send-email-gene@czarc.net> <51029EFB.90301@czarc.net> <201301261318.59880.russell@coker.com.au>
In-Reply-To: <201301261318.59880.russell@coker.com.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 01/26/2013 03:18 AM, Russell Coker wrote:
> On Sat, 26 Jan 2013, Gene Czarcinski<gene@czarc.net>  wrote:
>> OK, I think I have gotten the message that this is a bad idea as
>> implemented and that it should be dropped as such.  I believe that there
>> are some things ("btrfs fi show" comes to mind) which will need root and
>> I am going to explore doing something for that case.  And it also might
>> be reasonable for some situations to issue the message about root if
>> something errors-out.
>
> I think that a message such as Eric proposed of "failed to open /dev/sda:
> Permission denied" is clear enough.  If you run as non-root on a system with
> no security system other than Unix permissions then it will be quite obvious
> that such an error can be fixed by running as root.

Being pedantic, I would point out that the kernel is checking if the 
user has CAP_SYS_ADMIN, which could be different than geteuid() == 0. I 
can have both a root users without CAP_SYS_ADMIN and a normal user with 
this capability.

If I can make a suggestion, the work of Gene could be changed in 
checking which command really requires to be root.

To day I can create a subvolume, and remove a subvolume [1] without 
needing root. I am guessing if there is a valid reason to require "root" 
to list the subvolumes.

I know that behind the command "find-subvolumes" there is the ioctl 
BTRFS_IOC_TREE_SEARCH which requires to be root, because it could export 
some sensible information. But this can be easy solved creating an ioctl 
which export only not-sensible data (i.e. it export only the name and 
the path of the subvolume).

I think that a good analysis of these situations could improve the btrfs 
usability.

My 2¢

BR
G.Baroncelli
>
> But if you are running SE Linux or some other security system then you could
> be prevented from running the program without the root/non-root status of it
> being relevant.
>

[1] Passing user_subvol_rm_allowed in option
-- 
gpg @keyserver.linux.it: Goffredo Baroncelli (kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
