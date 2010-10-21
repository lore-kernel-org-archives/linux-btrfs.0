From: Erik Jensen <eriksjunk@rkjnsn.net>
Subject: Re: kernel BUG when removing missing drive (Take 2)
Date: Wed, 20 Oct 2010 17:53:34 -0700
Message-ID: <AANLkTimu9bpQSPfM1fBsJHnWH-BwysvfKTaN2=d5w2gx@mail.gmail.com>
References: <AANLkTimECim-kSVfuZkAS2pfNJi1rtA-voC98YR3iYoT@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTimECim-kSVfuZkAS2pfNJi1rtA-voC98YR3iYoT@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

After some more investigation, I discovered that for some reason btrfs
is trying to write to the missing drive (devid 5) in the course of
removing it from the array.  Since this drive is missing, it is
naturally not writable, leading to the BUG.

If any other tests would be helpful in tracking down this problem,
please let me know.

Thanks,
Erik
