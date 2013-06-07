Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.160]:21647 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753657Ab3FGOkr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 7 Jun 2013 10:40:47 -0400
Message-ID: <51B1F130.90401@giantdisaster.de>
Date: Fri, 07 Jun 2013 16:41:52 +0200
From: Stefan Behrens <sbehrens@giantdisaster.de>
MIME-Version: 1.0
To: Josef Bacik <jbacik@fusionio.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v4 6/8] Btrfs: introduce uuid-tree-gen field
References: <cover.1370534937.git.sbehrens@giantdisaster.de> <49cfd0aca92177345f59f3f700f6d43f8445f405.1370534938.git.sbehrens@giantdisaster.de> <20130607143916.GE29248@localhost.localdomain>
In-Reply-To: <20130607143916.GE29248@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 06/07/2013 16:39, Josef Bacik wrote:
> On Fri, Jun 07, 2013 at 04:27:51AM -0600, Stefan Behrens wrote:
>> In order to be able to detect the case that a filesystem is mounted
>> with an old kernel, add a uuid-tree-gen field like the free space
>> cache is doing it. It is part of the super block and written with
>> each commit. Old kernels do not know this field and don't update it.
>>
>
> So to get around the whole crashing before we finish creating the uuid tree
> maybe set some flag or something that doesn't actually set the
> super->uuid_tree_generation until _after_ it finishes populating the tree, and
> then have the scan deal with having a half populated tree.  Just an idea, but we
> have to deal with it some way.  Thanks,

That's what the patch 7/8 is doing.

