From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Having parent transid verify failed
Date: Thu, 05 May 2011 11:06:15 -0400
Message-ID: <1304607926-sup-3304@think>
References: <4DC287D8.3040705@gmail.com> <1304595695-sup-9289@think> <4DC28DC4.7050308@gmail.com> <1304605365-sup-4172@think> <4DC2B3D2.6080307@gmail.com>
Content-Type: text/plain; charset=UTF-8
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>
To: Konstantinos Skarlatos <k.skarlatos@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <4DC2B3D2.6080307@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from Konstantinos Skarlatos's message of 2011-05-05 10:27:30 -0400:
> attached you can find the whole dmesg log. I can trigger the error again 
> if more logs are needed

Yes, I'll send you a patch to get rid of the printk for the transid
failed message.  That way we can get a clean view of the other errors.

Will you be able to compile/test it?

-chris
