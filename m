Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-out-so.shaw.ca ([64.59.136.138]:43196 "EHLO
        smtp-out-so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753292AbdJMCoK (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 12 Oct 2017 22:44:10 -0400
Subject: Re: btrfs errors over NFS
From: Steve Leung <sjleung@shaw.ca>
To: linux-btrfs@vger.kernel.org
References: <87o9pcmfad.fsf@shaw.ca>
Message-ID: <113b8299-1377-5a35-a727-ec21e67518f7@shaw.ca>
Date: Thu, 12 Oct 2017 20:36:00 -0600
MIME-Version: 1.0
In-Reply-To: <87o9pcmfad.fsf@shaw.ca>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 10/12/2017 11:44 AM, Steve Leung wrote:
> Hi list,
> 
>    TL;DR: ran into some btrfs errors and weird behaviour, but things generally seem
>    to work.  Just posting some details in case it helps devs or other users.
> 
> I've run into a btrfs error trying to do a -j8 build of android on a btrfs
> filesystem exported over NFSv3.  That in itself might be unwise, but should be
> legal.  :)  This is on 64-bit Arch, kernel 4.13.3, and the filesystem is RAID1 on 4
> devices, with nearly 4TiB unallocated.
> 
> The build itself failed when part of the build process noticed that a file got
> created with mode 000.  i.e. in "ls -l" the mode column looked like ?---------.
> 
....
> 
> It booted back up fine.  I tried scrubbing the filesystem at that point and scrub
> returned with no errors.  I then noticed 4.13.5 had some btrfs fixes so I upgraded
> to that.  Now, I still have one bogus file in a directory - it's in the directory
> listing but nothing can stat the file to change it or remove it.  i.e.:
> 
>    > ls -l
>    /bin/ls: cannot access 'tab_unselected_pressed_holo.9.png': No such file or directory
>    total 0
>    -????????? ? ? ? ?            ? tab_unselected_pressed_holo.9.png
> 
>    > stat tab_unselected_pressed_holo.9.png
>    stat: cannot stat 'tab_unselected_pressed_holo.9.png': No such file or directory
> 
>    > rm tab_unselected_pressed_holo.9.png
>    rm: cannot remove 'tab_unselected_pressed_holo.9.png': No such file or directory
> 
>    > cp /dev/null tab_unselected_pressed_holo.9.png
>    > ls -l
>    total 0
>    -rw-r--r-- 1 steve steve 0 Oct 12 10:43 tab_unselected_pressed_holo.9.png
>    -rw-r--r-- 1 steve steve 0 Oct 12 10:43 tab_unselected_pressed_holo.9.png
> 
>    > rm tab_unselected_pressed_holo.9.png
> 
>    > ls -l
>    /bin/ls: cannot access 'tab_unselected_pressed_holo.9.png': No such file or directory
>    total 0
>    -????????? ? ? ? ?            ? tab_unselected_pressed_holo.9.png
> 
> I'm guessing a btrfs check would fix this but haven't gotten around to running it
> yet.

Just looked through the archives and noticed this is something
Tomasz Chmielewski posted about a week or so ago.  But that thread 
didn't seem to come to a definite conclusion.

I'm also in the situation where it's not that easy for me to blow away 
the whole subvol that holds this file, but I can at least move its 
directory to somewhere unnoticeable.  Until I can get around to trying 
btrfs check anyway.

Steve
