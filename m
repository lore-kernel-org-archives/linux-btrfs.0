Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:63398 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754301Ab2JBIRf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 2 Oct 2012 04:17:35 -0400
Received: by obbuo13 with SMTP id uo13so5872678obb.19
        for <linux-btrfs@vger.kernel.org>; Tue, 02 Oct 2012 01:17:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20121001164514.GA2370@localhost.localdomain>
References: <1348516979-2343-1-git-send-email-jbacik@fusionio.com>
	<CAHf9xvbZTizo6nbDbX8vjbT2RrwzPm=JMm-ms2MB-SVVcDKRhQ@mail.gmail.com>
	<20121001164514.GA2370@localhost.localdomain>
Date: Tue, 2 Oct 2012 10:17:34 +0200
Message-ID: <CAHf9xvYrNPj7W_VfjA7H8k6xojSGRFjnxOP1sEUGze1JWvOMJQ@mail.gmail.com>
Subject: Re: [PATCH] Btrfs: try to avoid doing a search in btrfs_next_leaf
From: Alex Lyakas <alex.bolshoy.btrfs@gmail.com>
To: Josef Bacik <jbacik@fusionio.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Josef,
thanks for clarifying.
By "wants to walk forward based on a particular item" you mean - find
all items that have the same objectid, until objectid changes? I wrote
some code once (for educational purposes) that just walked the tree
irrespective of a particular objectid, so that's why I was somewhat
puzzled by your change. If you decide to keep your change, can you pls
update the comment of btrfs_next_leaf()/next_old_leaf().

Thanks again,
Alex.


On Mon, Oct 1, 2012 at 6:45 PM, Josef Bacik <jbacik@fusionio.com> wrote:
> On Sun, Sep 30, 2012 at 05:28:23AM -0600, Alex Lyakas wrote:
>> Hi Josef,
>> I guess I am missing something, but I thought btrfs_next_leaf() should
>> just jump to the next leaf (or item, if it was added meanwhile)
>> irrespective of the key that is in the last slot of the current leaf.
>> The change you added is effective when there is a next leaf, but you
>> refuse to go there unless its first key has the same objectid. (I
>> think you use the ctree property that the key in the first node/leaf
>> of a tree block is equal to its parent's key).
>> Can you pls explain why you insist on the same objectid?
>>
>
> It's to avoid another search forward.  Unless I missed something everybody who
> calls btrfs_next_leaf() only wants to walk forward based on a particular item.
> If I've missed something and that's not the case then this needs to be dropped,
> or we can set some flag in path to ignore this logic, either way.  Thanks,
>
> Josef
