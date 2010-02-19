From: Mike Fedyk <mfedyk@mikefedyk.com>
Subject: Re: btrfs testing suite?
Date: Fri, 19 Feb 2010 10:55:24 -0800
Message-ID: <93cdabd21002191055w2e6b9470o93525fb0879ff708@mail.gmail.com>
References: <BLU120-W29F99FB7CDE39C3532F475D8460@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: "Mr. Tux" <tuxoholic@hotmail.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <BLU120-W29F99FB7CDE39C3532F475D8460@phx.gbl>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Feb 19, 2010 at 10:46 AM, Mr. Tux <tuxoholic@hotmail.de> wrote:
>
>
> Hi listIs there a btrfs testing suite the btrfs developers use to check the codebase? I did some research and found a projectcalled xfstests-dev. It supports ext4 as well - are there any patches to get btrfs support with xfstests?

There are also different versions of fsx that attempt to "fuzz" the
filesystems.  Btrfs has additional "edges" that need to be fuzzed so
it will need to be extended.  Running those as well as normal every
day use and your typical workload will help btrfs most.

Just install it and use it like normal, but make sure you have backups
and another system you can switch to if something goes wrong.
