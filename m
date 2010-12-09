From: Calvin Walton <calvin.walton@gmail.com>
Subject: Re: mount snapshot by object-id
Date: Thu, 09 Dec 2010 09:31:44 -0500
Message-ID: <1291905104.15070.6.camel@ayu>
References: <20101209145114.07f55914@simplux>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
To: Michael Niederle <mniederle@gmx.at>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20101209145114.07f55914@simplux>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 2010-12-09 at 14:51 +0100, Michael Niederle wrote:
> Hi!
> 
> I'm currently writing a btrfs-rescue tool and therefor began to study the
> btrfs-on-disk structures in detail.
> 
> The root tree contains a ROOT_ITEM entry for *every* subvolume in the whole
> file system, but only DIR_ITEM entries for subvolumes that were created in the
> root directory of the filesystem.
> 
> If we have a destroyed root directory, there is no way to access subvolumes
> stored deeper in the fs-tree by name. It might be nice to have the ability to
> mount a subvolume by object-id. A simple tool could list all available
> subvolumes with their object-ids, generation numbers, and so on.

Unless I misunderstand something, this is actually already possible;
just poorly documented. You can use the 'subvolid=' mount option to
mount by object id; the object id can be found using the tool
btrfs subvolume list <filesystem>

The subvolid= mount option was missing from the wiki, so I've just added
it:
https://btrfs.wiki.kernel.org/index.php/Getting_started#Mount_Options

-- 
Calvin Walton <calvin.walton@gmail.com>

