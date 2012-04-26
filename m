From: Thomas Rohwer <trohwer@ennit.de>
Subject: Re: Interpreting Output of "btrfs fi show"
Date: Thu, 26 Apr 2012 12:14:48 +0200
Message-ID: <4F992018.9040006@ennit.de>
References: <4F98B447.30102@ennit.de> <CAGy7UtgsWOmvG16oFTRutFTu5bwq4kT+CQTicqPuYa45YhqUSA@mail.gmail.com> <4F991027.6000903@ennit.de> <CAGy7UtioPbdjomzuv3phZcF+HShyYKytkOKnAhP+4VGj29Aahg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Cc: linux-btrfs@vger.kernel.org
To: Bart Noordervliet <bart@noordervliet.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAGy7UtioPbdjomzuv3phZcF+HShyYKytkOKnAhP+4VGj29Aahg@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

> Well I think there is a btrfs superblock still present from the
> full-disk filesystem. Due to the offset of the first partition from
> the start of the disk, this superblock was not overwritten when you
> created the filesystem inside the partition. But they very much
> overlap and the full-disk superblock will probably eventually be
> overwritten by elements from the partition filesystem. How you would
> go about erasing the stale superblock and whether it is safe to do so
> I can't say though.

Ok, that explains it, and it is no problem for me. I was just confused
by the output and thought that this may be related to the "no space"
problem. I just installed kernel 3.3.3, and the problem with "no space"
seems to be gone. Thanks for your quick help.

Sincerely,

Thomas Rohwer
