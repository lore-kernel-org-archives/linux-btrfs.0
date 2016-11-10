Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail02.iobjects.de ([188.40.134.68]:59796 "EHLO
        mail02.iobjects.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933919AbcKJPh0 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 10 Nov 2016 10:37:26 -0500
Subject: Re: [PATCH] Btrfs: deal with existing encompassing extent map in
 btrfs_get_extent()
To: dsterba@suse.cz, Omar Sandoval <osandov@osandov.com>,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com, bo.li.liu@oracle.com
References: <262a1e171d091626edbd23c637cb138ba9d84ed8.1478733376.git.osandov@fb.com>
 <20161110150651.GE12522@twin.jikos.cz>
From: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>
Message-ID: <58249434.4080903@applied-asynchrony.com>
Date: Thu, 10 Nov 2016 16:37:24 +0100
MIME-Version: 1.0
In-Reply-To: <20161110150651.GE12522@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 11/10/16 16:06, David Sterba wrote:
> On Wed, Nov 09, 2016 at 03:26:50PM -0800, Omar Sandoval wrote:
>> From: Omar Sandoval <osandov@fb.com>
>> [snip]
>> Commit 8dff9c853410 ("Btrfs: deal with duplciates during extent_map
>> insertion in btrfs_get_extent") fixed a case in btrfs_get_extent() where
>> two threads race on adding the same extent map to an inode's extent map
>> tree. However, if the added em is merged with an adjacent em in the
>> extent tree, then we'll end up with an existing extent that is not
>> identical to but instead encompasses the extent we tried to add. When we
>> call merge_extent_mapping() to find the nonoverlapping part of the new
>> em, the arithmetic overflows because there is no such thing. We then end
>> up trying to add a bogus em to the em_tree, which results in a EEXIST
>> that can bubble all the way up to userspace.
> 
> Is this possibly the same bug that Liu Bo fixes in
> https://patchwork.kernel.org/patch/9413129/ ?

Seem similar, but I can't reproduce without that patch either..

-h

