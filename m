From: Thomas Rohwer <trohwer@ennit.de>
Subject: Re: Interpreting Output of "btrfs fi show"
Date: Thu, 26 Apr 2012 11:06:47 +0200
Message-ID: <4F991027.6000903@ennit.de>
References: <4F98B447.30102@ennit.de> <CAGy7UtgsWOmvG16oFTRutFTu5bwq4kT+CQTicqPuYa45YhqUSA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Cc: linux-btrfs@vger.kernel.org
To: Bart Noordervliet <bart@noordervliet.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAGy7UtgsWOmvG16oFTRutFTu5bwq4kT+CQTicqPuYa45YhqUSA@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hello Bart,

> there's a known regression in 3.3.0 that causes btrfs to report
> out-of-space too early. If you upgrade to 3.3.3 or the latest 3.4 rc
> the problem should be gone.

thanks for the information. I will update my kernel.

> As for the two filesystems shown in btrfs fi show... I have no clue
> what that is about. Did you maybe make a mistake to create a btrfs
> filesystem on the whole disk at first?

That is possible. But afterwards I certainly repartioned the device and
created a btrfs filesystem on /dev/sda1. Maybe this info is only in
the partition table? I understand that I should avoid mounting /dev/sda
in this situation.

Sincerely,

Thomas Rohwer
