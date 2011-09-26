From: Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: kernel bug
Date: Mon, 26 Sep 2011 08:50:11 +0800
Message-ID: <4E7FCC43.9080505@cn.fujitsu.com>
References: <CABVOS0-ELuCKZ5PGvMuZ=RO+V81LPPKXTwDPVEBGtZ=sWKOWvw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Roman Kapusta <roman.kapusta@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CABVOS0-ELuCKZ5PGvMuZ=RO+V81LPPKXTwDPVEBGtZ=sWKOWvw@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Roman Kapusta wrote:
> Segfault and kernel bug after reflinking several files (20-30 files)
> each of size around 1GB through following command:
> 
> cp -r --reflink sorce_dir .
> Segmentation fault
> 
> I'm on Fedora 15, kernel 3.0.4

This has been fixed in Linux 3.1-rc7.

