From: Sean Bartell <wingedtachikoma@gmail.com>
Subject: Re: crc32c
Date: Mon, 11 Oct 2010 11:09:33 -0400
Message-ID: <20101011150933.GA3060@lelouch.nomadic.ncsu.edu>
References: <AANLkTi=8xYEQ=pwo5faCMqD7gV=OLJxXTmfKvcDvp5i-@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Nathan Caza <mastercactapus@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTi=8xYEQ=pwo5faCMqD7gV=OLJxXTmfKvcDvp5i-@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Oct 11, 2010 at 03:47:58AM -0500, Nathan Caza wrote:
> I think I'm on the verge of getting all my data back; the only missing
> piece is to recalculate the crc checksum of my altered superblock and
> I'm having trouble finding the correct function/method; the data I am
> checksumming is (based on the sheet) 0x20 (directly after the
> checksum) to 0x32b + n (226 bytes); if im doing something wrong let me
> know; or if theres a quick/dirty way to get the right checksum

The checksum seems to be from 0x20 to 0x1000.
