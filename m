From: Chris Mason <chris.mason@oracle.com>
Subject: Re: parent transid verify failures on 2.6.39
Date: Wed, 22 Jun 2011 21:45:20 -0400
Message-ID: <1308793398-sup-9234@shiny>
References: <4E026FD4.7020606@podzimek.org>
Content-Type: text/plain; charset=UTF-8
Cc: Josef Bacik <josef@redhat.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Andrej Podzimek <andrej@podzimek.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <4E026FD4.7020606@podzimek.org>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from Andrej Podzimek's message of 2011-06-22 18:42:28 -0400:
> 
> Could I try your hack, pretty please? If there's any chance it could either resolve this problem
> 
>     http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg10683.html ,
> 
> or at least restore the data from the filesystem, then I'd like to give it a go. Waiting for the new btrfsck is currently not an option for me :-)

It looks like your box is failing to read the extent allocation tree.
We don't allow the mount to proceed without that tree, but you don't
actually need it for a readonly mount (to copy things off).

Josef, is your hack just a mount option to make -o readonly skip the
extent allocation tree?

I can put this into my -o recovery patch and we can give it a try.

-chris
