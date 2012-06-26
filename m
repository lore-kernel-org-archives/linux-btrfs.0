Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:56043 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757988Ab2FZBVk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 Jun 2012 21:21:40 -0400
MIME-Version: 1.0
In-Reply-To: <20120625135344.GN5390@mwanda>
References: <4FE473F6.5000109@fusionio.com>
	<20120625111048.GA10393@elgon.mountain>
	<20120625133956.GA2499@localhost.localdomain>
	<20120625135344.GN5390@mwanda>
Date: Tue, 26 Jun 2012 06:51:39 +0530
Message-ID: <CAOD=uF4h5pqfU3u=fVZu74kEP=HLFQWd2+qPRrT69Jtjn+11bw@mail.gmail.com>
Subject: Re: [patch v2] Btrfs: fix error handling in __add_reloc_root()
From: santosh prasad nayak <santoshprasadnayak@gmail.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Josef Bacik <jbacik@fusionio.com>, "Chris L. Mason" <clmason@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I am also facing similar issue while applying this patch.

[santosh@localhost linux-next]$ sudo git am mail_Dan.txt
Patch format detection failed.
[santosh@localhost linux-next]$




regards
santosh

On Mon, Jun 25, 2012 at 7:23 PM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> On Mon, Jun 25, 2012 at 09:41:12AM -0400, Josef Bacik wrote:
>> On Mon, Jun 25, 2012 at 05:15:23AM -0600, Dan Carpenter wrote:
>> > We dereferenced "node" in the error message after freeing it.  Also
>> > btrfs_panic() can return so we should return an error code instead of
>> > continuing.
>> >
>> > Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
>> > ---
>> > v2: in the first version I just deleted the kfree().
>> >
>> > diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
>> > index 790f492..4da0865 100644
>> > --- a/fs/btrfs/relocation.c
>> > +++ b/fs/btrfs/relocation.c
>> > @@ -1239,10 +1239,11 @@ static int __must_check __add_reloc_root(struct btrfs_root *root)
>> >                           node->bytenr, &node->rb_node);
>> >     spin_unlock(&rc->reloc_root_tree.lock);
>> >     if (rb_node) {
>> > -           kfree(node);
>> >             btrfs_panic(root->fs_info, -EEXIST, "Duplicate root found "
>> >                         "for start=%llu while inserting into relocation "
>> >                         "tree\n", node->bytenr);
>> > +           kfree(node);
>> > +           return -EEXIST;
>> >     }
>> >
>> >     list_add_tail(&root->root_list, &rc->reloc_roots);
>>
>> I'm not sure why but it seems like this patch is wrapped.  At first I thought it
>> was thunderbird but then I opened it up and saved it from mutt and I got the
>> same problem.  I will fix it up, but you may want to check your mail client.
>
> The message that went through to kernel-janitors applies fine for
> me.  I'm not sure what to say.
>
> regards,
> dan carpenter
>
> --
> To unsubscribe from this list: send the line "unsubscribe kernel-janitors" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
