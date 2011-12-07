From: BJ Quinn <bj@placs.net>
Subject: Re: Cloning a Btrfs partition
Date: Wed, 07 Dec 2011 12:49:43 -0600 (CST)
Message-ID: <22fa7cb1-728a-4a3d-a51b-3ff54053380e@mail.placs.net>
References: <CAOjFWZ52tF-UmRT=9wOh-7A0c51=QGhjSu_-fOdz3=d3Z4aDJQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: linux-btrfs@vger.kernel.org
To: Freddie Cash <fjwcash@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAOjFWZ52tF-UmRT=9wOh-7A0c51=QGhjSu_-fOdz3=d3Z4aDJQ@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

>Until an analog of "zfs send" is added to btrfs (and I believe there 
>are some side projects ongoing to add something similar), your only 
>option is the one you are currently using via rsync. 

Well, I don't mind using the rsync script, it's just that it's so slow. I'd love to use my script to "keep up" the backup array, which only takes a couple of hours and is acceptable. But starting with a blank backup array, it takes weeks to get the backup array caught up, which isn't realistically possible. 

What I need isn't really an equivalent "zfs send" -- my script can do that. As I remember, zfs send was pretty slow too in a scenario like this. What I need is to be able to clone a btrfs array somehow -- dd would be nice, but as I said I end up with the identical UUID problem. Is there a way to change the UUID of an array?

-BJ Quinn
