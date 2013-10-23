Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:29897 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755111Ab3JWBxt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Oct 2013 21:53:49 -0400
Message-ID: <52672C20.80000@oracle.com>
Date: Wed, 23 Oct 2013 09:53:36 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org, chris.mason@fusionio.com,
        jbacik@fusionio.com
Subject: Re: [PATCH 2/2] btrfs-progs: filesystem show of specified mounted
 disk should work
References: <1382421202-18494-1-git-send-email-anand.jain@oracle.com> <1382421202-18494-2-git-send-email-anand.jain@oracle.com> <20131022163913.GZ1032@twin.jikos.cz>
In-Reply-To: <20131022163913.GZ1032@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>




As I remember, there was no code to handle the look up by label.
it was a dummy option which did nothing.

So the below commit removed the option.

------
commit 50eaae45f2b47643f9a4c43ce72f7d6e06d4e323
Author: Anand Jain <anand.jain@oracle.com>
Date:   Mon Jul 15 13:30:48 2013 +0800

     btrfs-progs: label option in btrfs filesystem show is not coded

     Signed-off-by: Anand Jain <anand.jain@oracle.com>
     Signed-off-by: David Sterba <dsterba@suse.cz>
-------


On 10/23/13 12:39 AM, David Sterba wrote:
> Somewhere among the updates 'btrfs fi show LABEL' stopped working and
> xfstests/btrfs/006 fails. I did not know that this functionality exists so I
> haven't paid attention to it during reviews.

> I did a quick tested with some older integration branch with
> "btrfs-progs: btrfs_list_find_updated_files: Fix memory leak" on top and it
> worked.

  let me try. If there was any code which managed
  the label lookup option.


Thanks, Anand
