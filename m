From: Konstantinos Skarlatos <k.skarlatos@gmail.com>
Subject: Re: Having parent transid verify failed
Date: Thu, 05 May 2011 19:07:43 +0300
Message-ID: <4DC2CB4F.7060903@gmail.com>
References: <4DC287D8.3040705@gmail.com> <1304595695-sup-9289@think> <4DC28DC4.7050308@gmail.com> <1304605365-sup-4172@think> <4DC2B3D2.6080307@gmail.com> <1304607926-sup-3304@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1304607926-sup-3304@think>
List-ID: <linux-btrfs.vger.kernel.org>



On 5/5/2011 6:06 =CE=BC=CE=BC, Chris Mason wrote:
> Excerpts from Konstantinos Skarlatos's message of 2011-05-05 10:27:30=
 -0400:
>> attached you can find the whole dmesg log. I can trigger the error a=
gain
>> if more logs are needed
>
> Yes, I'll send you a patch to get rid of the printk for the transid
> failed message.  That way we can get a clean view of the other errors=
=2E
>
> Will you be able to compile/test it?

Yes, i think i will be able to make it, but because i have only done=20
this once and in a quite hackish way, i may need some help in order to=20
do it right.

>
> -chris
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
