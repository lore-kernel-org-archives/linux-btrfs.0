From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Having parent transid verify failed
Date: Thu, 05 May 2011 07:42:06 -0400
Message-ID: <1304595695-sup-9289@think>
References: <4DC287D8.3040705@gmail.com>
Content-Type: text/plain; charset=UTF-8
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>
To: Konstantinos Skarlatos <k.skarlatos@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <4DC287D8.3040705@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from Konstantinos Skarlatos's message of 2011-05-05 07:19:52 -0400:
> Hello, I have a 5.5TB Btrfs filesystem on top of a md-raid 5 device. Now 
> if i run some file operations like find, i get these messages.
> kernel is 2.6.38.5-1 on arch linux

Are all of the messages for this one block?

parent transid verify failed on 3062073683968 wanted 5181 found 5188

-chris
