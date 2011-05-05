From: Konstantinos Skarlatos <k.skarlatos@gmail.com>
Subject: Re: Having parent transid verify failed
Date: Thu, 05 May 2011 14:45:08 +0300
Message-ID: <4DC28DC4.7050308@gmail.com>
References: <4DC287D8.3040705@gmail.com> <1304595695-sup-9289@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1304595695-sup-9289@think>
List-ID: <linux-btrfs.vger.kernel.org>



On 5/5/2011 2:42 =CE=BC=CE=BC, Chris Mason wrote:
> Excerpts from Konstantinos Skarlatos's message of 2011-05-05 07:19:52=
 -0400:
>> Hello, I have a 5.5TB Btrfs filesystem on top of a md-raid 5 device.=
 Now
>> if i run some file operations like find, i get these messages.
>> kernel is 2.6.38.5-1 on arch linux
>
> Are all of the messages for this one block?
>
> parent transid verify failed on 3062073683968 wanted 5181 found 5188
yes, only this block
>
> -chris
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
