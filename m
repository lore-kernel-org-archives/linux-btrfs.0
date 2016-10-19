Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from parrot.pmhahn.de ([88.198.50.102]:34023 "EHLO parrot.pmhahn.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751783AbcJSRVA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 19 Oct 2016 13:21:00 -0400
Subject: Re: bio linked list corruption.
To: Chris Mason <clm@fb.com>, Linus Torvalds <torvalds@linux-foundation.org>,
        Jens Axboe <axboe@fb.com>, Dave Jones <davej@codemonkey.org.uk>,
        Al Viro <viro@zeniv.linux.org.uk>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
References: <20161011144507.okg6baqvodn2m2lh@codemonkey.org.uk>
 <20161018224205.bjgloslaxcej2td2@codemonkey.org.uk>
 <e9e28964-4540-6e95-b4b7-aafd509fd8bc@fb.com>
 <20161018233148.GA93792@clm-mbp.masoncoding.com>
 <CA+55aFz37uBqo9LG6pwRCB1pU94o3yz1SXwj3xwzHRXtg5Cgyw@mail.gmail.com>
 <20161018234248.GB93792@clm-mbp.masoncoding.com>
From: Philipp Hahn <pmhahn@pmhahn.de>
Message-ID: <9ba0cd0b-33f6-2156-aaf2-ad9ed9a00115@pmhahn.de>
Date: Wed, 19 Oct 2016 19:09:46 +0200
MIME-Version: 1.0
In-Reply-To: <20161018234248.GB93792@clm-mbp.masoncoding.com>
Content-Type: text/plain; charset=iso-8859-15
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

Am 19.10.2016 um 01:42 schrieb Chris Mason:
> On Tue, Oct 18, 2016 at 04:39:22PM -0700, Linus Torvalds wrote:
>> On Tue, Oct 18, 2016 at 4:31 PM, Chris Mason <clm@fb.com> wrote:
>>>
>>> Jens, not sure if you saw the whole thread.  This has triggered bad page
>>> state errors, and also corrupted a btrfs list.  It hurts me to say,
>>> but it
>>> might not actually be your fault.
>>
>> Where is that thread, and what is the "this" that triggers problems?
>>
>> Looking at the "->mq_list" users, I'm not seeing any changes there in
>> the last year or so. So I don't think it's the list itself.
> 
> Seems to be the whole thing:
> 
> http://www.gossamer-threads.com/lists/linux/kernel/2545792
> 
> My guess is xattr, but I don't have a good reason for that.

Nearly a month ago I reported also a "list_add corruption", but with 4.1.6:
<http://marc.info/?l=linux-kernel&m=147508265316854&w=2>

That server rungs Samba4, which also is a heavy user of xattr.

Might be that it is related.

Philipp Hahn
