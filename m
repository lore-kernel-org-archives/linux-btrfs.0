From: Sean Bartell <wingedtachikoma@gmail.com>
Subject: Re: Creation time
Date: Mon, 15 Mar 2010 10:38:05 -0400
Message-ID: <20100315143805.GA5980@flcl.lan>
References: <201003140255.13309.hka@qbs.com.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Hubert Kario <hka@qbs.com.pl>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201003140255.13309.hka@qbs.com.pl>
List-ID: <linux-btrfs.vger.kernel.org>

There is room in btrfs for a fourth time called "otime", but it is not
currently used or even initialized. Once there are APIs, it should be
possible to add crtime support with a slight format upgrade.

On Sun, Mar 14, 2010 at 02:55:12AM +0100, Hubert Kario wrote:
> From what I could find, btrfs supports only the trinity of UNIX time stamps: 
> atime, ctime and mtime.
> 
> Is there any plan to support crtime (creation time)?
> 
> Side note: ZFS already supports it, ext4 and cifs (samba) are waiting for APIs 
> and userland support, so it could be a good time to coordinate efforts and 
> solidify the interface.
