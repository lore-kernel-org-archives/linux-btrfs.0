Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:55217 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755364AbaDNTOQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 14 Apr 2014 15:14:16 -0400
Message-ID: <534C3390.10402@fb.com>
Date: Mon, 14 Apr 2014 15:14:24 -0400
From: Chris Mason <clm@fb.com>
MIME-Version: 1.0
To: Shaun Reich <sreich@kde.org>, <linux-btrfs@vger.kernel.org>
Subject: Re: sub del: directory not empty, even though it is
References: <CADVynFCg4KWN9AGNKXAjoamwoLfNO4Q5czv+UCdEhqXWrG8P8A@mail.gmail.com> <534C2D95.4090103@fb.com>
In-Reply-To: <534C2D95.4090103@fb.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 04/14/2014 02:48 PM, Chris Mason wrote:
 
> We have a pretty long list of reasons why the delete will fail, but the 
> not empty one should only pop up if we think this snapshot has a 
> reference on something else.  I wonder if the mv didn't drop the refs.
> 

Ok, latest kernels include this commit:

commit 72de6b5393c15c5228074008bbdc47e92bf6d4f7
Author: Guangyu Sun <guangyu.sun@oracle.com>
Date:   Tue Mar 11 11:24:18 2014 -0700

    Btrfs: return EPERM when deleting a default subvolume
    
    The error message is confusing:
    
     # btrfs sub delete /mnt/mysub/
     Delete subvolume '/mnt/mysub'
     ERROR: cannot delete '/mnt/mysub' - Directory not empty
    
    The error message does not make sense to me: It's not about deleting a
    directory but it's a subvolume, and it doesn't matter if the subvolume is
    empty or not.
    
    Maybe EPERM or is more appropriate in this case, combined with an explanatory
    kernel log message. (e.g. "subvolume with ID 123 cannot be deleted because
    it is configured as default subvolume.")
    
    Reported-by: Koen De Wit <koen.de.wit@oracle.com>
    Signed-off-by: Guangyu Sun <guangyu.sun@oracle.com>
    Reviewed-by: David Sterba <dsterba@suse.cz>
    Signed-off-by: Chris Mason <clm@fb.com>

And your btrfs-debug-tree output confirms you're trying to delete the
default subvolume.

Pick a new default and it will all work ;)

-chris
