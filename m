Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.162]:32428 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750906Ab2GFPOW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 6 Jul 2012 11:14:22 -0400
Message-ID: <4FF700C5.5050406@giantdisaster.de>
Date: Fri, 06 Jul 2012 17:14:13 +0200
From: Stefan Behrens <sbehrens@giantdisaster.de>
MIME-Version: 1.0
To: Jan Schmidt <list.btrfs@jan-o-sch.net>
CC: Mark Fasheh <mfasheh@suse.de>, linux-btrfs@vger.kernel.org,
        Chris Mason <chris.mason@oracle.com>, Mark Fasheh <mfasheh@suse.com>
Subject: Re: [PATCH 1/3] btrfs: extended inode refs
References: <1337636781-12575-1-git-send-email-mfasheh@suse.de> <1337636781-12575-2-git-send-email-mfasheh@suse.de> <4FF6FCA8.2060100@jan-o-sch.net>
In-Reply-To: <4FF6FCA8.2060100@jan-o-sch.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 06 Jul 2012 16:56:40 +0200, Jan Schmidt wrote:
> On Mon, May 21, 2012 at 23:46 (+0200), Mark Fasheh wrote:
>> +int find_name_in_ext_backref(struct btrfs_path *path, const char *name,
>> +			     int name_len,
>> +			     struct btrfs_inode_extref **extref_ret)
> 
> Exported functions should be prefixed "btrfs_". What about btrfs_find_extref_name?

>> +
>> +static struct btrfs_inode_ref *
>>  btrfs_lookup_inode_ref(struct btrfs_trans_handle *trans,
> 
> static functions should not be prefixed "btrfs_".

Prefixing _all_ functions with the module name has some advantages:
- uniqueness for ctags(1)
- unique names in stack traces that allow to identify the module and to
find the source code

IMO Mark should not change it.
